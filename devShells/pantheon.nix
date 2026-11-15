{
  pkgs,
  rust,
  java,
  python,
}:
pkgs.mkShell {
  inputsFrom = [
    rust
    java
    python
  ];

  packages = with pkgs; [
    bazelisk
    buf
    just
    protobuf
  ];

  shellHook = ''
    export PATH="$PWD/.venv/bin:$PATH"
  '';
}
