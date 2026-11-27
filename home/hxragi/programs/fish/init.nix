{
  programs.fish.interactiveShellInit = ''
    set fish_greeting ""

    if test "$_tide_cfg_ver" != "3"
        if not set -q tide_cmd_duration_decimals
            source (functions --details _tide_sub_configure)
            _load_config lean
            _tide_finish
        end

        set -U tide_left_prompt_items pwd git newline character
        set -U tide_right_prompt_items cmd_duration

        set -U tide_prompt_add_newline_before true
        set -U tide_prompt_pad_items false
        set -U tide_prompt_transient_enabled true

        set -U tide_left_prompt_separator_diff_color " "
        set -U tide_left_prompt_separator_same_color " "
        set -U tide_left_prompt_prefix ""
        set -U tide_left_prompt_suffix ""
        set -U tide_right_prompt_prefix ""
        set -U tide_right_prompt_suffix ""

        set -U tide_pwd_bg_color normal
        set -U tide_pwd_color_dirs b4befe
        set -U tide_pwd_color_anchors b4befe
        set -U tide_pwd_color_truncated_dirs 6c7086

        set -U tide_git_bg_color normal
        set -U tide_git_color_branch b4befe
        set -U tide_git_color_dirty fab387
        set -U tide_git_color_staged a6e3a1
        set -U tide_git_color_stash f9e2af
        set -U tide_git_color_untracked f38ba8
        set -U tide_git_color_upstream 89dceb
        set -U tide_git_color_conflicted f38ba8

        set -U tide_cmd_duration_bg_color normal
        set -U tide_cmd_duration_color 6c7086
        set -U tide_cmd_duration_decimals 0
        set -U tide_cmd_duration_icon ""
        set -U tide_cmd_duration_threshold 2000

        set -U tide_character_color a6e3a1
        set -U tide_character_color_failure f38ba8
        set -U tide_character_icon "❯"
        set -U tide_character_vi_icon_default "❯"

        set -U _tide_cfg_ver 3
    end
  '';
}
