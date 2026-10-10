{ pkgs, ... }: {
  programs.prismlauncher = {
    enable = true;
    package = pkgs.prismlauncher.override {
      jdks = [
        pkgs.temurin-jre-bin-25
      ];
      additionalLibs = with pkgs; [
        libxi
        libxcursor
        libxrandr
        libxxf86vm
      ];
    };
  };
}
