{ pkgs, ... }:
let
  makeWrappedVesktop =
    args:
    let
      base = pkgs.vesktop.override args;
    in
    (pkgs.symlinkJoin {
      name = "vesktop-wrapped";
      paths = [ base ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/vesktop \
          --add-flags "--js-flags=--max-old-space-size=256 --disable-gpu-memory-buffer-compositor-resources"
      '';
    })
    // {
      override = newArgs: makeWrappedVesktop (args // newArgs);
    };
in
{
  programs.vesktop = {
    enable = true;
    package = makeWrappedVesktop { };
  };
}
