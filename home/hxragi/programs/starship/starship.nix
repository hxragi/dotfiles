{ lib, ... }: {
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$c$rust$golang$nodejs$python"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];
      add_newline = true;
      palette = "catppuccin_mocha";
    };
  };
}
