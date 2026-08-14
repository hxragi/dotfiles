{pkgs, ...}: {
  programs.tmux = {
    enable = true;

    prefix = "C-a";
    mouse = true;
    baseIndex = 1;
    keyMode = "vi";

    plugins = [
      pkgs.tmuxPlugins.sensible

      {
        plugin = pkgs.tmuxPlugins.resurrect;

        extraConfig = ''
          set -g @resurrect-strategy-nvim 'session'
        '';
      }
    ];

    extraConfig = ''
      set -g automatic-rename off

      set -g window-status-format "#[bg=#{@thm_surface_0},fg=#{@thm_fg}] #I #W "
      set -g window-status-current-format "#[bg=#{@thm_mauve},fg=#{@thm_crust},bold] #I #W "

      bind-key -n M-1 select-window -t :=1
      bind-key -n M-2 select-window -t :=2
      bind-key -n M-3 select-window -t :=3
      bind-key -n M-4 select-window -t :=4
      bind-key -n M-5 select-window -t :=5
      bind-key -n M-6 select-window -t :=6
      bind-key -n M-7 select-window -t :=7
      bind-key -n M-8 select-window -t :=8
      bind-key -n M-9 select-window -t :=9
    '';
  };
}
