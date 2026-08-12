{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware.nix
    ./modules/hardware/bluetooth.nix
  ];

  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
    secrets.hxragi-password = {
      neededForUsers = true;
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    binfmt.emulatedSystems = lib.mkForce [];
    kernelParams = [
      "i915.force_probe=!a7a8"
      "xe.force_probe=a7a8"
    ];
  };

  networking = {
    hostName = "shinoa";
    networkmanager.enable = false;
    dhcpcd.enable = true;
  };

  time.timeZone = "Europe/Moscow";

  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    mutableUsers = false;
    users.hxragi = {
      isNormalUser = true;
      extraGroups = ["wheel"];
      shell = pkgs.fish;
      hashedPasswordFile = config.sops.secrets.hxragi-password.path;
    };
  };

  programs = {
    niri.enable = true;
    nano.enable = false;
    dconf.profiles = lib.mkForce {};
    steam = {
      enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };
  };

  security.rtkit.enable = true;

  documentation = {
    enable = false;
    man.enable = false;
    doc.enable = false;
    info.enable = false;
    nixos.enable = false;
  };

  services = {
    gnome = {
      gnome-keyring.enable = false;
      gnome-user-share.enable = false;
    };
    gvfs.enable = false;
    usbmuxd.enable = false;
    logrotate.enable = false;
    pcscd.enable = false;
    udisks2.enable = false;
    printing.enable = false;
    avahi.enable = false;
    getty.autologinUser = "hxragi";
    xserver.videoDrivers = ["nvidia"];
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;

      wireplumber.extraConfig."10-fifine-mic" = {
        "monitor.alsa.rules" = [
          {
            matches = [
              {"device.name" = "alsa_card.usb-3142_Fifine_Microphone-00";}
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
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];

    config = {
      niri = lib.mkForce {
        default = ["gtk" "wlr"];
        "org.freedesktop.impl.portal.Screencast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
      };

      common = {
        default = ["gtk" "wlr"];
      };
    };
  };

  systemd.services.ModemManager.enable = false;

  environment = {
    defaultPackages = lib.mkForce [];
    systemPackages = with pkgs; [
      intel-media-driver
      awww
    ];
    gnome.excludePackages = with pkgs; [
      nautilus
    ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-color-emoji
    jetbrains-mono
    nerd-fonts.jetbrains-mono
  ];

  hardware = {
    alsa.enablePersistence = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
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

  powerManagement.cpuFreqGovernor = "schedutil";

  system.stateVersion = "26.05";
}
