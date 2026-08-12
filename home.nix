{
  pkgs,
  lib,
  catppuccin,
  ...
}: {
  imports = [catppuccin.homeModules.catppuccin];

  manual.manpages.enable = false;

  catppuccin = {
    enable = true;
    autoEnable = true;
    flavor = "mocha";
    accent = "mauve";
    cursors.enable = true;
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      extensions.force = true;
      settings = {
        "browser.ml.chat.enabled" = false;
        "browser.ml.chat.sidebar" = false;
        "browser.ml.enable" = false;
        "extensions.ml.enabled" = false;
        "browser.tabs.groups.smart.enabled" = false;
        "browser.translations.enable" = false;
        "browser.ai.control.linkPreviewKeyPoints" = false;
      };
    };
  };

  catppuccin.firefox = {
    enable = true;
    profiles.default.enable = true;
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting ""
    '';
    shellAliases = {
      ls = "eza --icons=always --group-directories-first";
      ll = "eza -l --icons=always --group-directories-first -g";
      la = "eza -a --icons=always --group-directories-first";
      lla = "eza -la --icons=always --group-directories-first -g";
      tree = "eza --tree --icons=always";
      cat = "bat --style=plain";
      grep = "rg";
      find = "fd";
      du = "dust";
      df = "duf";
      ps = "procs";
      rebuild = "sudo nixos-rebuild switch --flake .#shinoa";
    };
  };

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
        style = "bold mauve";
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
        detect_files = ["package.json" ".nvmrc"];
      };

      python = {
        style = "bold yellow";
        format = "[$symbol]($style)";
        symbol = " ";
      };
    };
  };

  home.packages = with pkgs; [
    eza
    bat
    ripgrep
    fd
    dust
    duf
    procs
    ironbar
    neovim
    alacritty
    bluetuith
    delta
    xwayland-satellite
    wl-clipboard
    gamemode
  ];

  programs.vesktop = {
    enable = true;

    settings = {
      minimizeToTray = true;
      discordBranch = "stable";
    };

    settings.plugins = {
      VolumeBooster.enable = true;
      FakeNitro.enable = true;
      ShowHiddenChannels.enable = true;
    };
  };

  home.file.".config/niri" = {
    source = ./home/.config/niri;
  };

  home.file.".config/ironbar" = {
    source = ./home/.config/ironbar;
  };

  home.file.".config/nvim" = {
    source = ./home/.config/nvim;
  };

  systemd.user.services.awww-daemon = {
    Unit = {
      Description = "Awww wallpaper daemon";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      Restart = "always";
      RestartSec = 5;
      Environment = ["PATH=${lib.makeBinPath [pkgs.awww]}"];
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "hxragi";
        email = "mixintrace@gmail.com";
      };

      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        cm = "commit -m";
        lg = "log --oneline --graph --decorate";
      };

      core = {
        editor = "nvim";
        pager = "delta";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      pull.rebase = true;
      diff.algorithm = "histogram";
      merge.conflictstyle = "diff3";

      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        side-by-side = true;
      };
    };
  };

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrainsMono:size=20";
        width = 45;
        lines = 7;
        horizontal-pad = 15;
        vertical-pad = 15;
        inner-pad = 15;
        prompt = "run: ";
        icons-enabled = "no";
      };

      colors = {
        background = "1e1e2edd";
        text = "cdd6f4ff";
        prompt = "bac2deff";
        placeholder = "7f849cff";
        input = "cdd6f4ff";
        match = "74c7ecff";
        selection = "585b70ff";
        selection-text = "cdd6f4ff";
        selection-match = "74c7ecff";
        border = "74c7ecff";
      };

      border = {
        width = 2;
        radius = 8;
      };
    };
  };

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.username = "hxragi";
  home.homeDirectory = "/home/hxragi";
  home.stateVersion = "26.05";
}
