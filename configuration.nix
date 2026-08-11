{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./modules/hardware/bluetooth.nix
    ];

  nixpkgs.config.allowUnfree = true;

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  sops.secrets.hxragi-password = {
    neededForUsers = true;
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "shinoa";
  networking.networkmanager.enable = false;
  networking.dhcpcd.enable = true;

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";
  
  users = {
    mutableUsers = false;
    users.hxragi = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.fish;
      hashedPasswordFile = config.sops.secrets.hxragi-password.path;
    };
  };

  programs.fish.enable = true;
  programs.niri.enable = true;
  programs.nano.enable = false;

  security.rtkit.enable = true;
  
  documentation.enable = false;
  documentation.man.enable = false;
  documentation.doc.enable = false;
  documentation.info.enable = false;
  documentation.nixos.enable = false;

  services.gnome.gnome-keyring.enable = false;

  boot.binfmt.emulatedSystems = lib.mkForce [];

  programs.dconf.profiles = lib.mkForce {};
  
  services.gnome.gnome-user-share.enable = false;
  
  services.gvfs.enable = false;
  services.usbmuxd.enable = false;
  
  services.logrotate.enable = false;
  
  services.pcscd.enable = false;
  
  services.udisks2.enable = false;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    
    config = {
      niri = lib.mkForce {
        default = [ "gtk" "wlr" ];
        "org.freedesktop.impl.portal.Screencast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
      };
      
      common = {
        default = [ "gtk" "wlr" ];
      };
    };
  };

  services.printing.enable = false;

  systemd.services.ModemManager.enable = false;
  services.avahi.enable = false;

  environment.defaultPackages = lib.mkForce [];
  environment.systemPackages = with pkgs; [
    intel-media-driver
    awww
  ];
  
  environment.gnome.excludePackages = with pkgs; [
    nautilus
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];

  services.getty.autologinUser = "hxragi";
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    
    wireplumber.extraConfig."10-fifine-mic" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            { "device.name" = "alsa_card.usb-3142_Fifine_Microphone-00"; }
          ];
          actions = {
            update-props = {
              "api.alsa.soft-mixer" = true;
            };
          };
        }
      ];
    };
  };

  hardware.alsa.enablePersistence = true;

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.nvidia = {
    open = true;
    modesetting.enable = true;
    powerManagement.enable = true;
    nvidiaPersistenced = true;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0@0:2:0";
      nvidiaBusId = "PCI:1@0:0:0";
    };
  };
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  
  zramSwap = {
    enable = true;
    memoryPercent = 25;
    algorithm = "zstd";
    priority = 5;
  };

  boot.kernelParams = [
    "i915.force_probe=!a7a8"
    "xe.force_probe=a7a8"
  ];

  powerManagement.cpuFreqGovernor = "schedutil";

  services.xserver.videoDrivers = [ "nvidia" ];

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  system.stateVersion = "26.05";
}
