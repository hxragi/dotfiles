{ pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    cargo
    cargo-nextest
    cargo-llvm-cov
    clippy
    rust-analyzer
    rustc
    rustfmt
    sqlx-cli
  ];

  RUST_BACKTRACE = "1";

  LLVM_COV = "${pkgs.llvmPackages_22.llvm}/bin/llvm-cov";
  LLVM_PROFDATA = "${pkgs.llvmPackages_22.llvm}/bin/llvm-profdata";
}
