{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "dota2-mod-manager";
  version = "4.7.1";

  src = fetchurl {
    url = "https://github.com/dota2modmanager/dota2-mod-manager/releases/download/v${version}/Dota-2-Mod-Manager.AppImage";
    hash = "sha256-HD5yjqYpAyY3TDD/mwiAMtRpRl5VTKxwQCb8azI03UM=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    desktop_file="$(find ${appimageContents} -maxdepth 2 -name '*.desktop' | head -n 1)"
    if [ -n "$desktop_file" ]; then
      install -m 444 -D "$desktop_file" "$out/share/applications/${pname}.desktop"
      substituteInPlace "$out/share/applications/${pname}.desktop" \
        --replace-fail 'Exec=dota-2-mod-manager' 'Exec=${pname}'
    fi
    if [ -d "${appimageContents}/usr/share/icons" ]; then
      cp -r "${appimageContents}/usr/share/icons" "$out/share/"
    fi
  '';

  meta = {
    description = "Mod manager and modding toolkit for Dota 2";
    homepage = "https://github.com/dota2modmanager/dota2-mod-manager";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "dota2-mod-manager";
  };
}
