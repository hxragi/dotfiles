{
  programs.zellij = {
    enable = true;
    enableFishIntegration = false;

    settings = {
      default_layout = "compact";
      pane_frames = false;
      mouse_mode = true;
      copy_on_select = true;
      scrollback_editor = "nvim";
      session_serialization = true;
      serialize_pane_viewport = true;
      scrollback_lines_to_serialize = 10000;
      show_startup_tips = false;
    };
  };
}
