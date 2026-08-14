{
  imports = [
    ./hardware.nix
    ./kernel.nix
    ./networking.nix
    ./locale.nix
    ./user.nix
    ./secrets.nix
    ./fifine.nix
    ./nvidia-prime.nix
    ./state-version.nix

    ../../modules/nixos/nix.nix
    ../../modules/nixos/nixpkgs.nix
    ../../modules/nixos/bootloader.nix
    ../../modules/nixos/documentation.nix
    ../../modules/nixos/default-packages.nix
    ../../modules/nixos/fonts.nix
    ../../modules/nixos/portals.nix
    ../../modules/nixos/power.nix
    ../../modules/nixos/zram.nix

    ../../modules/nixos/hardware/audio.nix
    ../../modules/nixos/hardware/bluetooth.nix
    ../../modules/nixos/hardware/graphics.nix
    ../../modules/nixos/hardware/nvidia.nix

    ../../modules/nixos/programs/dconf.nix
    ../../modules/nixos/programs/fish.nix
    ../../modules/nixos/programs/gamemode.nix
    ../../modules/nixos/programs/nano.nix
    ../../modules/nixos/programs/nautilus.nix
    ../../modules/nixos/programs/niri.nix
    ../../modules/nixos/programs/steam.nix

    ../../modules/nixos/services/avahi.nix
    ../../modules/nixos/services/gnome-keyring.nix
    ../../modules/nixos/services/gnome-user-share.nix
    ../../modules/nixos/services/greetd.nix
    ../../modules/nixos/services/gvfs.nix
    ../../modules/nixos/services/logrotate.nix
    ../../modules/nixos/services/modemmanager.nix
    ../../modules/nixos/services/pcscd.nix
    ../../modules/nixos/services/printing.nix
    ../../modules/nixos/services/udisks2.nix
    ../../modules/nixos/services/usbmuxd.nix
  ];
}
