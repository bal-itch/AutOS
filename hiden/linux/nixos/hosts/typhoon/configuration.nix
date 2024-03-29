# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

 {
  # You can import other NixOS modules here
  imports = [
    ./hardware-configuration.nix
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vulkan-validation-layers
      intel-media-driver
      vaapiIntel
      vaapiVdpau
      libvdpau-va-gl
      nvidia-vaapi-driver
    ];
  };

  services.xserver = {
    enable = true;
    layout = "us";
    videoDrivers = [ "nvidia" ];
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;
    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
  };

  hardware.nvidia = {
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    nvidiaSettings = true;
    modesetting.enable = true;
    forceFullCompositionPipeline = true;
    nvidiaPersistenced = true;
  };

  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
    sync.enable = true;
  };

  nixpkgs = {
    # Configure your nixpkgs instance
    config = {
      packageOverrides = pkgs: {
        vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
      };
      # Disable if you don't want unfree packages
      allowUnfree = true;

    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: {flake = value;}) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # the configuration (pain)
  programs = {
    adb.enable = true;
    dconf.enable = true;
    fish.enable = true;
  };

  environment.systemPackages = with pkgs; [
    bluez
    bluez-alsa
    mesa
    pulseaudio
    temurin-bin-18
    temurin-jre-bin-8
    vulkan-extension-layer
    vulkan-loader
    vulkan-tools
    vulkan-validation-layers
    wget
    python3
    winePackages.staging
  ];

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  fonts.packages = with pkgs; [
	font-awesome
	jetbrains-mono
        noto-fonts
        noto-fonts-cjk
        noto-fonts-emoji
        source-han-sans
        source-han-sans-japanese
        source-han-serif-japanese
  ];
  fonts.fontconfig.defaultFonts = {
    serif = [ "Noto Serif" "Source Han Serif" ];
    sansSerif = [ "Noto Sans" "Source Han Sans" ];
  };

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;
  services.dbus.enable = true;
  services.flatpak.enable = true;
  services.printing.enable = true;
 
  console.useXkbConfig = true;

  # Hostname
  networking.hostName = "typhoon";

  # Bootloader
  boot.loader = {
    efi.canTouchEfiVariables = true;
    efi.efiSysMountPoint = "/boot";
    grub = {
      devices = [ "nodev" ];
      efiSupport = true;
      enable = true;
      useOSProber = true;
    };
  };
  boot.initrd.systemd.enable = true;
  boot.supportedFilesystems = [ "exfat" "ntfs" "xfs" "btrfs"];
  boot.kernelPackages = pkgs.linuxPackages_lqx;
  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  boot.blacklistedKernelModules = [ "nouveau" ];

  # enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = ["192.168.40.66"]; # pihole

  # Set a time zone, idiot
  time.timeZone = "America/Chicago";

  # Use local time for the hardware clock, because Windows sucks
  time.hardwareClockInLocalTime = true;

  # Fun internationalisation stuffs (AAAAAAAA)
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

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Sound (kill me now)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # define user acc

  users.defaultUserShell = pkgs.fish;

  users.users.sarah = {
    isNormalUser = true;
    description = "sarah";
    extraGroups = ["networkmanager" "libvirtd" "wheel" "adbusers"];
    openssh.authorizedKeys.keys = [
      # TODO: Add SSH public key(s) here
    ];
  };

  # SSH server

  services.openssh.enable = true;
  services.openssh.settings = {
    # Forbid root login through SSH.
    PermitRootLogin = "no";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    #PasswordAuthentication = False;
  };

  # Samba, I really don't want to put this in the main configuration, but oh well
  # this is broken, i don't really care right now
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
      workgroup = WORKGROUP
      # who needs security anyway? (i love networking with Windows XP machines)
      min protocol = NT1
      client min protocol = NT1
      server string = typhoon
      netbios name = typhoon
      security = user 
      # note: localhost is an alias for ipv6's localhost address (::1)
      hosts allow = 192.168.40. 127.0.0.1 localhost
      hosts deny = 0.0.0.0/0
      guest account = nobody
      map to guest = Bad User
    '';
    shares = {
      private = {
        path = "/run/media/sarah/External Drive/";
        browseable = "yes";
        writeable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0666";
        "directory mask" = "0777";
        "force user" = "sarah";
      };
    };
  };

  # VMware and QEMU/KVM
  virtualisation.vmware.host.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "24.05";
}
