{ pkgs, ... }: {
  programs.helium = {
    enable = true;
    package = pkgs.helium;
    flags = [ "--disable-features=NtpSimplification,BookmarkBar" ];
  };
}
