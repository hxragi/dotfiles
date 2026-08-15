{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.hxragi.profiles.development;
in {
  options.hxragi.profiles.development.enable =
    lib.mkEnableOption "hxragi development profile";

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.just
    ];
  };
}
