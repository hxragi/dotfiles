{
  programs.starship.settings = {
    directory = {
      style = "bold lavender";
      format = "[$path]($style) ";
      truncation_length = 3;
      truncate_to_repo = true;
    };
    git_branch = {
      style = "bold lavender";
      format = "[on](dimmed text)[ $symbol$branch]($style) ";
      symbol = "󰊢 ";
    };
    git_status = {
      style = "bold peach";
      format = "[$all_status$ahead_behind]($style) ";
    };
    character = {
      success_symbol = "[❯](bold green)";
      error_symbol = "[❯](bold red)";
      vimcmd_symbol = "[❮](bold green)";
    };
    cmd_duration = {
      style = "dimmed overlay0";
      format = "[$duration]($style) ";
      min_time = 2000;
    };
    c = {
      style = "bold blue";
      format = "[$symbol]($style)";
      symbol = " ";
    };
    rust = {
      style = "bold maroon";
      format = "[$symbol]($style)";
      symbol = "󱘗 ";
    };
    golang = {
      style = "bold sapphire";
      format = "[$symbol]($style)";
      symbol = " ";
    };
    nodejs = {
      style = "bold green";
      format = "[$symbol]($style)";
      symbol = " ";
      detect_files = [
        "package.json"
        ".nvmrc"
      ];
    };
    python = {
      style = "bold yellow";
      format = "[$symbol]($style)";
      symbol = " ";
    };
  };
}
