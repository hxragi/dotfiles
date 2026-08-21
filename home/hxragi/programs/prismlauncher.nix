{pkgs, ...}: {
  home.packages = [
    (pkgs.prismlauncher.override {
      jdks = [
        pkgs.temurin-jre-bin-25
      ];
    })
  ];
}
