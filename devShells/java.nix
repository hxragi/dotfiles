{pkgs}: let
  jdk = pkgs.temurin-bin-25;
in
pkgs.mkShell {
  packages = with pkgs; [
    jdk
    jdt-language-server
    gradle
  ];

  JAVA_HOME = "${jdk}";
}
