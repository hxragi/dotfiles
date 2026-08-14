{
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
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.showSearch" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      userChrome = ''
        #firefox-view-button {
          display: none !important;
        }
      '';
    };
  };
}
