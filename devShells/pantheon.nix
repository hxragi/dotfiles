{
  pkgs,
  rust,
  java,
  python,
}:
let
  bazelFhs = pkgs.buildFHSEnv {
    name = "bazelisk";
    targetPkgs = pkgs: [
      pkgs.bazelisk
      pkgs.stdenv.cc.cc.lib
      pkgs.zlib
      pkgs.gcc
      pkgs.glibc
      pkgs.git
    ];
    runScript = "bazelisk";
  };

  bazelWrapper = pkgs.runCommand "bazel-wrapper" { } ''
    mkdir -p $out/bin
    ln -s ${bazelFhs}/bin/bazelisk $out/bin/bazelisk
    ln -s ${bazelFhs}/bin/bazelisk $out/bin/bazel
  '';
in
pkgs.mkShell {
  inputsFrom = [
    rust
    java
    python
  ];

  packages = with pkgs; [
    bazelWrapper
    buf
    just
    protobuf
  ];

  shellHook = ''
    export PATH="$PWD/.venv/bin:$PATH"
  '';
}
