# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = [
    "type:bridge"
    "interface-name:br*"
    "type:bluetooth"
  ];

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  hardware.alsa.enablePersistence = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    wireplumber.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # PipeWire/WirePlumber are user services on NixOS; for headless boot we need them on default.target.
  systemd.user.services.pipewire.wantedBy = [ "default.target" ];
  systemd.user.services.wireplumber.wantedBy = [ "default.target" ];
  systemd.user.services.pipewire-pulse.wantedBy = [ "default.target" ];

  systemd.user.services.pipewire-default-volume-150 = {
    description = "Force default sink volume via pactl (headless boot)";
    wantedBy = [ "default.target" ];
    wants = [ "pipewire.service" "wireplumber.service" "pipewire-pulse.service" ];
    after = [ "pipewire.service" "wireplumber.service" "pipewire-pulse.service" ];
    serviceConfig = {
      Type = "oneshot";
      TimeoutStartSec = "90s";
      Restart = "on-failure";
      RestartSec = "2s";
    };
    script = ''
      set -euo pipefail

      # Wait for pipewire-pulse socket then apply volume on the default sink.
      for _ in $(seq 1 90); do
        if [ -S "$XDG_RUNTIME_DIR/pulse/native" ]; then
          break
        fi
        sleep 1
      done

      export PULSE_SERVER="unix:$XDG_RUNTIME_DIR/pulse/native"

      # Wait until at least one sink exists, then set volume on that sink explicitly.
      sink=""
      for _ in $(seq 1 90); do
        sink="$(${pkgs.pulseaudio}/bin/pactl list short sinks 2>/dev/null | ${pkgs.gawk}/bin/awk 'NR==1{print $2}')"
        if [ -n "$sink" ]; then
          break
        fi
        sleep 1
      done

      [ -n "$sink" ]
      ${pkgs.coreutils}/bin/timeout 2 ${pkgs.pulseaudio}/bin/pactl set-default-sink "$sink"
      ${pkgs.coreutils}/bin/timeout 2 ${pkgs.pulseaudio}/bin/pactl set-sink-mute "$sink" 0
      ${pkgs.coreutils}/bin/timeout 2 ${pkgs.pulseaudio}/bin/pactl set-sink-volume "$sink" 150%
    '';
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # QEMU
  services.qemuGuest.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.bluetooth.settings = {
    General = {
      AutoEnable = true;
      ControllerMode = "dual";
      FastConnectable = true;
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.xac = {
    isNormalUser = true;
    description = "xac";
    # Important: audio group is required for headless boot of PipeWire/WirePlumber
    extraGroups = [ "networkmanager" "wheel" "audio" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Keep user systemd running without interactive login (needed for PipeWire/WirePlumber user units)
  systemd.tmpfiles.rules = [
    "f /var/lib/systemd/linger/xac 0644 root root -"
  ];

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nix.settings.experimental-features = ["nix-command" "flakes" ];
  nix.settings.substituters = [ "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store" ];
  environment.systemPackages = with pkgs; [
    git
    vim
    wget

    bluez
    pulseaudio
    pulsemixer
    # pavucontrol

    linux-firmware
  ];
  environment.variables.EDITOR = "vim";

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}