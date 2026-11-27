{ config, ... }:
let
  home = config.home.homeDirectory;
in
{
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;

      download = "${home}/downloads";
      pictures = "${home}/pictures";
      projects = "${home}/projects";
      desktop = "${home}/desktop";
      documents = "${home}/documents";
      music = "${home}/media/music";
      videos = "${home}/media/videos";
      publicShare = "${home}/public";
      templates = "${home}/templates";
    };

    mimeApps = {
      enable = true;

      defaultApplications = {
        "text/html" = "helium.desktop";
        "application/xhtml+xml" = "helium.desktop";
        "application/pdf" = "helium.desktop";
        "image/svg+xml" = "helium.desktop";
        "x-scheme-handler/http" = "helium.desktop";
        "x-scheme-handler/https" = "helium.desktop";
        "x-scheme-handler/ftp" = "helium.desktop";
      };
    };
  };

  home.sessionVariables = {
    HISTFILE = "${config.xdg.stateHome}/bash/history";
    LESSHISTFILE = "${config.xdg.stateHome}/lesshst";
    INPUTRC = "${config.xdg.configHome}/readline/inputrc";
    WGETRC = "${config.xdg.configHome}/wgetrc";

    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
    GOPATH = "${config.xdg.dataHome}/go";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    NODE_REPL_HISTORY = "${config.xdg.stateHome}/node_repl_history";
    CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
    __GL_SHADER_DISK_CACHE_PATH = "${config.xdg.cacheHome}/nv";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
  };

  home.sessionPath = [
    "${home}/.local/bin"
    "${config.xdg.dataHome}/cargo/bin"
  ];
}
