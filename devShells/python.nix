{ pkgs }:
let
  python = pkgs.python315;
in
pkgs.mkShell {
  packages = [
    python
    pkgs.uv
    pkgs.ruff
    pkgs.basedpyright
  ];

  UV_PYTHON = "${python}/bin/python";
  UV_PYTHON_DOWNLOADS = "never";

  PYTHONDONTWRITEBYTECODE = "1";
  PYTHONUNBUFFERED = "1";

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    pkgs.stdenv.cc.cc.lib
    pkgs.zlib
  ];

  shellHook = ''
    export PATH="$PWD/.venv/bin:$PATH"
  '';
}
