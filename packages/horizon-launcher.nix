{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  autoPatchelfHook,
  makeWrapper,
  patchelf,
  libxkbcommon,
  libxcb,
  vulkan-loader,
  wayland,
  libGL,
  fontconfig,
  freetype,
  alsa-lib,
  udev,
  openssl,
  libx11,
  libxcursor,
  libxrandr,
  libxi,
  temurin-bin-25,
}:

let
  pname = "horizon-launcher";
  version = "0.2.78";

  src = fetchurl {
    url = "https://github.com/horizon-rust/horizon/releases/download/launcher%40${version}/horizon-launcher-linux-x86_64.AppImage";
    hash = "sha256-xxyoUJwTpL12AKX0NVUhq+fEZRd7nsar/wmw6ttcsV8=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };

  runtimeLibs = [
    libxkbcommon
    libxcb
    vulkan-loader
    wayland
    libGL
    fontconfig
    freetype
    alsa-lib
    udev
    openssl
    libx11
    libxcursor
    libxrandr
    libxi
    stdenv.cc.cc.lib
  ];

  dynamicLinker = "${stdenv.cc.bintools.dynamicLinker}";
  runRpath = lib.makeLibraryPath runtimeLibs;
in
stdenv.mkDerivation {
  inherit pname version;

  src = appimageContents;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    libxkbcommon
    libxcb
  ];

  appendRunpaths = [
    runRpath
  ];

  installPhase = ''
    runHook preInstall

    install -m 755 -D usr/bin/horizon-launcher $out/libexec/horizon-launcher
    install -m 444 -D horizon-launcher.desktop $out/share/applications/horizon-launcher.desktop
    install -m 444 -D horizon.png $out/share/pixmaps/horizon.png
    cp -r usr/share/icons $out/share/

    substituteInPlace $out/share/applications/horizon-launcher.desktop \
      --replace-fail "Exec=horizon-launcher" "Exec=$out/bin/horizon-launcher"

    mkdir -p $out/bin
    cat > $out/bin/horizon-launcher <<EOF
    #!${stdenv.shell}
    set -e

    VERSIONS_DIR="\''${XDG_DATA_HOME:-\$HOME/.local/share}/horizon-launcher/versions"
    DYNAMIC_LINKER="${dynamicLinker}"
    RUN_RPATH="${runRpath}"

    patch_bin() {
      local target="\$1"
      if [[ -f "\$target" && -x "\$target" && ! -L "\$target" ]]; then
        local interp
        interp=\$(${patchelf}/bin/patchelf --print-interpreter "\$target" 2>/dev/null || true)
        if [[ "\$interp" != "\$DYNAMIC_LINKER" && -n "\$interp" ]]; then
          ${patchelf}/bin/patchelf \\
            --set-interpreter "\$DYNAMIC_LINKER" \\
            --set-rpath "\$RUN_RPATH" \\
            "\$target" 2>/dev/null || true
        fi
      fi
    }

    if [[ -d "\$VERSIONS_DIR" ]]; then
      for bin in "\$VERSIONS_DIR"/*/horizon-client "\$VERSIONS_DIR"/*/horizon-prepare "\$VERSIONS_DIR"/*/horizon-server "\$VERSIONS_DIR"/*/horizon-ctl; do
        patch_bin "\$bin"
      done
    fi

    exec $out/libexec/horizon-launcher "\$@"
    EOF

    chmod 755 $out/bin/horizon-launcher
    ln -s $out/bin/horizon-launcher $out/bin/horizon

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/libexec/horizon-launcher \
      --prefix PATH : ${lib.makeBinPath [ temurin-bin-25 ]} \
      --prefix LD_LIBRARY_PATH : ${runRpath}
  '';

  meta = {
    description = "Launcher for Horizon, a Minecraft: Java Edition rewrite in Rust";
    homepage = "https://playhorizon.dev";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "horizon-launcher";
  };
}
