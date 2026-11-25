{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
}:

stdenv.mkDerivation rec {
  pname = "superseedr";
  version = "1.0.17";

  src = fetchurl {
    url = "https://github.com/Jagalite/superseedr/releases/download/v${version}/superseedr_v${version}_linux-amd64.tar.gz";
    hash = "sha256-/WMOMhW54p6a/5mRf9dOS4agds7suRuuakomDxlPmnA=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 superseedr "$out/bin/superseedr"
    install -Dm644 LICENSE "$out/share/licenses/${pname}/LICENSE"
    install -Dm644 README.md "$out/share/doc/${pname}/README.md"
    install -Dm644 CHANGELOG.md "$out/share/doc/${pname}/CHANGELOG.md"

    runHook postInstall
  '';

  meta = {
    description = "Terminal-based BitTorrent client written in Rust";
    homepage = "https://github.com/Jagalite/superseedr";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "superseedr";
  };
}
