{
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
      check = "nix run nixpkgs#alejandra -- --check . && nix run nixpkgs#statix -- check . && nix run nixpkgs#deadnix -- --fail . && nix flake check";
      format = "nix run nixpkgs#alejandra -- .";
    };
  };
}
