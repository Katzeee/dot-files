using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;
using System.Web.Script.Serialization;

internal static class InputStatus
{
    [StructLayout(LayoutKind.Sequential)]
    private struct Rect { public int Left, Top, Right, Bottom; }

    [StructLayout(LayoutKind.Sequential)]
    private struct GuiThreadInfo
    {
        public uint Size, Flags;
        public IntPtr Active, Focus, Capture, MenuOwner, MoveSize, Caret;
        public Rect CaretRect;
    }

    [DllImport("user32.dll")]
    private static extern IntPtr GetForegroundWindow();
    [DllImport("user32.dll", SetLastError = true)]
    private static extern uint GetWindowThreadProcessId(IntPtr window, out uint process);
    [DllImport("user32.dll", SetLastError = true)]
    private static extern bool GetGUIThreadInfo(uint thread, ref GuiThreadInfo info);
    [DllImport("user32.dll")]
    private static extern IntPtr GetKeyboardLayout(uint thread);
    [DllImport("imm32.dll")]
    private static extern IntPtr ImmGetDefaultIMEWnd(IntPtr window);
    [DllImport("user32.dll", SetLastError = true)]
    private static extern IntPtr SendMessageTimeout(
        IntPtr window, uint message, UIntPtr command, IntPtr argument,
        uint flags, uint timeout, out UIntPtr result);
    [DllImport("kernel32.dll", CharSet = CharSet.Unicode)]
    private static extern int GetLocaleInfo(uint locale, uint kind, StringBuilder value, int count);

    private static bool ReadIme(IntPtr ime, uint command, out ulong value)
    {
        UIntPtr result;
        IntPtr success = SendMessageTimeout(ime, 0x0283, new UIntPtr(command), IntPtr.Zero, 0x0002, 60, out result);
        value = result.ToUInt64();
        return success != IntPtr.Zero;
    }

    private static int Main(string[] args)
    {
        Console.OutputEncoding = new UTF8Encoding(false);
        var result = new Dictionary<string, object>();
        result["label"] = "?";
        result["description"] = "输入状态暂不可读";
        try
        {
            IntPtr foreground = GetForegroundWindow();
            if (foreground == IntPtr.Zero) throw new InvalidOperationException("No foreground window.");
            uint process;
            uint thread = GetWindowThreadProcessId(foreground, out process);
            var info = new GuiThreadInfo();
            info.Size = (uint)Marshal.SizeOf(typeof(GuiThreadInfo));
            IntPtr target = GetGUIThreadInfo(thread, ref info) && info.Focus != IntPtr.Zero ? info.Focus : foreground;
            thread = GetWindowThreadProcessId(target, out process);
            uint language = (uint)(GetKeyboardLayout(thread).ToInt64() & 0xffff);
            uint primary = language & 0x3ff;
            var code = new StringBuilder(32);
            GetLocaleInfo(language, 0x59, code, code.Capacity);
            string layout = code.Length > 0 ? code.ToString().ToUpperInvariant() : "?";
            result["layout"] = layout;
            if (primary == 0x04)
            {
                IntPtr ime = ImmGetDefaultIMEWnd(target);
                if (ime == IntPtr.Zero && target != foreground) ime = ImmGetDefaultIMEWnd(foreground);
                ulong open = 0, conversion = 0;
                bool hasOpen = ime != IntPtr.Zero && ReadIme(ime, 0x0005, out open);
                bool hasConversion = ime != IntPtr.Zero && ReadIme(ime, 0x0001, out conversion);
                string mode = "?";
                if (hasConversion) mode = (conversion & 1) != 0 ? "中" : "A";
                else if (hasOpen) mode = open != 0 ? "中" : "A";
                result["label"] = "ZH · " + mode;
                result["description"] = mode == "?" ? "中文输入法：暂时无法读取中英模式" :
                    (mode == "中" ? "中文输入法 · 中文模式" : "中文输入法 · 英文模式");
                if (Array.IndexOf(args, "--diagnostic") >= 0)
                {
                    result["foreground"] = foreground.ToInt64();
                    result["focus"] = target.ToInt64();
                    result["ime"] = ime.ToInt64();
                    result["open_read"] = hasOpen;
                    result["open"] = open;
                    result["conversion_read"] = hasConversion;
                    result["conversion"] = conversion;
                }
            }
            else
            {
                result["label"] = primary == 0x09 ? "EN" : layout;
                result["description"] = primary == 0x09 ? "英文键盘布局" : "当前键盘布局：" + layout;
            }
        }
        catch (Exception error)
        {
            result["description"] = "输入状态暂不可读：" + error.Message;
        }
        Console.WriteLine(new JavaScriptSerializer().Serialize(result));
        return 0;
    }
}
