{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    cargo
    clippy
    rust-analyzer
    rustc
    rustfmt
    sqlx-cli
  ];

  RUST_BACKTRACE = "1";
}
