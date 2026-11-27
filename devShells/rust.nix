{ pkgs }:
let
  rustToolchain = pkgs.rust-bin.stable.latest.default.override {
    extensions = [
      "llvm-tools"
      "rust-analyzer"
      "rust-src"
    ];
  };
in
pkgs.mkShell {
  packages = with pkgs; [
    (cargo-llvm-cov.overrideAttrs {
      doCheck = false;
    })
    cargo-nextest
    mold
    rustToolchain
    sccache
    sqlx-cli
  ];

  RUST_BACKTRACE = "1";
  RUSTFLAGS = "-C link-arg=-fuse-ld=mold";
  RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";

  LLVM_COV = "${pkgs.llvmPackages_22.llvm}/bin/llvm-cov";
  LLVM_PROFDATA = "${pkgs.llvmPackages_22.llvm}/bin/llvm-profdata";
}
