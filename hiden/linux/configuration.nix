{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

    # Bootloader
    boot.supportedFilesystems = [ "ntfs" ];
    boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot";
    };
    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = true;
      version = 2;
    };
  };

  networking.hostName = "typhoon"; # Hostname
  #networking.wireless.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "America/Chicago";
  time.hardwareClockInLocalTime = true;

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # X11
  services.xserver.enable = true;

  # KDE Plasma
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # X11 keymap
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # CUPS
  services.printing.enable = true;

  # Pipewire
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # account go br
  users.users.sarah = {
    isNormalUser = true;
    description = "Sarah";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      discord
      freetube
      hyfetch
      librewolf
      steam
      yt-dlp
      kate
      chromium
      spotify
      bitwarden
      vscodium
      obs-studio
      winetricks
      libsForQt5.kdenlive
      plexamp
    ];
  };

  # Non-free stuff
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    python3
    home-manager
    winePackages.staging
  ];

  # Flatpak
  services.flatpak.enable = true;

  # SSH
  services.openssh.enable = true; 

  system.stateVersion = "23.05";

  # Graphics accel
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.nvidiaSettings = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    sync.enable = true;

    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };
}