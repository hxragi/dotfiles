{ pkgs, ... }: {
  programs.prismlauncher = {
    enable = true;
    package = pkgs.prismlauncher.override {
      jdks = [
        pkgs.temurin-jre-bin-25
      ];
    };
  };
}
