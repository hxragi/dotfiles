{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "proton-cachyos";
  version = "11.0-20260703-slr-x86_64_v3";
  releaseTag = "cachyos-11.0-20260703-slr";

  src = fetchzip {
    url = "https://github.com/CachyOS/proton-cachyos/releases/download/${finalAttrs.releaseTag}/proton-cachyos-${finalAttrs.version}.tar.xz";
    hash = "sha256-8Y7orUvnFOG0zSqCrMyvmclmy3JInj7d8A2h0Y7RwhE=";
  };

  outputs = [
    "out"
    "steamcompattool"
  ];

  buildCommand = ''
    runHook preBuild
    echo "${finalAttrs.pname} нельзя ставить в окружение, используй programs.steam.extraCompatPackages" > $out
    ln -s $src $steamcompattool
    runHook postBuild
  '';

  meta = {
    description = "Proton-CachyOS compatibility tool for Steam Play";
    homepage = "https://github.com/CachyOS/proton-cachyos";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
