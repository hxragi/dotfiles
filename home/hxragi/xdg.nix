{
  xdg = {
    userDirs = {
      enable = true;
      createDirectories = true;

      download = "$HOME/downloads";
      pictures = "$HOME/pictures";
      projects = "$HOME/projects";
      desktop = "$HOME";
      documents = "$HOME";
      music = "$HOME";
      publicShare = "$HOME";
      templates = "$HOME";
      videos = "$HOME";
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
}
