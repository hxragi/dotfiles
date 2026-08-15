{lib, ...}: {
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

      palettes.catppuccin_mocha = {
        rosewater = "#f5e0dc";
        flamingo = "#f2cdcd";
        pink = "#f5c2e7";
        mauve = "#cba6f7";
        red = "#f38ba8";
        maroon = "#eba0ac";
        peach = "#fab387";
        yellow = "#f9e2af";
        green = "#a6e3a1";
        teal = "#94e2d5";
        sky = "#89dceb";
        sapphire = "#74c7ec";
        blue = "#89b4fa";
        lavender = "#b4befe";
        text = "#cdd6f4";
        subtext1 = "#bac2de";
        subtext0 = "#a6adc8";
        overlay2 = "#9399b2";
        overlay1 = "#7f849c";
        overlay0 = "#6c7086";
        surface2 = "#585b70";
        surface1 = "#45475a";
        surface0 = "#313244";
        base = "#1e1e2e";
        mantle = "#181825";
        crust = "#11111b";
      };

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
  };
}
