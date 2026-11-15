{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitMinimal;
    ignores = [
      ".envrc"
      ".direnv/"
    ];
  };
}
