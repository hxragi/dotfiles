{pkgs, ...}: {
  environment.gnome.excludePackages = [
    pkgs.nautilus
  ];
}
