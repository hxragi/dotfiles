{ pkgs, ... }: {
  programs.helium = {
    enable = true;
    package = pkgs.helium;
    flags = [
      "--disable-features=NtpSimplification,BookmarkBar,Translate,MediaRouter"
      "--memory-model=low"
      "--enable-low-end-device-mode"
      "--js-flags=--max-old-space-size=512"
    ];
  };
}
