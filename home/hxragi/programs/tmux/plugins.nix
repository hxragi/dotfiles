{ pkgs, ... }: {
  programs.tmux.plugins = [
    pkgs.tmuxPlugins.sensible
    {
      plugin = pkgs.tmuxPlugins.resurrect;
      extraConfig = ''
        set -g @resurrect-strategy-nvim 'session'
      '';
    }
  ];
}
