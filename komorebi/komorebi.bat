@echo off
komorebic.exe stop
komorebic.exe start

komorebic.exe focus-follows-mouse enable
komorebic.exe mouse-follows-focus disable
komorebic.exe ensure-workspaces 0 3
komorebic.exe ensure-workspaces 1 3
komorebic.exe manage-rule exe WINDWORD.exe
komorebic.exe float-rule exe uTools.exe
komorebic.exe float-rule title Qv2ray
komorebic.exe float-rule exe mailmaster.exe
komorebic.exe identify-tray-application exe WeChat.exe
komorebic.exe identify-tray-application exe TIM.exe
komorebic.exe identify-tray-application title "Clash for Windows"
komorebic.exe identify-tray-application exe uTools.exe
komorebic.exe identify-tray-application exe qv2ray.exe
komorebic.exe identify-tray-application exe cloudmusic.exe
komorebic.exe identify-tray-application exe mailmaster.exe

py -3.9 D:\github-codes\yasb-xac\src\main.py