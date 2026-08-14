{pkgs, ...}: {
  programs.firefox = {
    enable = true;

    profiles.default = {
      isDefault = true;
      extensions = {
        force = true;

        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
        ];
      };

      search = {
        force = true;
        default = "DuckDuckGo No AI";
        privateDefault = "DuckDuckGo No AI";

        engines = {
          "DuckDuckGo No AI" = {
            name = "DuckDuckGo No AI";

            urls = [
              {
                template = "https://noai.duckduckgo.com/";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];

            definedAliases = ["@ddg"];
          };

          google.metaData.hidden = true;
        };
      };

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
        "identity.fxaccounts.enabled" = false;
        "browser.toolbars.bookmarks.visibility" = "never";
        "extensions.autoDisableScopes" = 0;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      userChrome = ''
        #firefox-view-button,
        #fxa-toolbar-menu-button,
        #star-button-box,
        #pageActionButton,
        #stop-reload-button,
        #tabs-newtab-button,
        #new-tab-button,
        #alltabs-button,
        .tab-close-button {
          display: none !important;
        }

        .tabbrowser-tab[fadein]:not([pinned]) {
          flex-grow: 1 !important;
          max-width: none !important;
        }
      '';
    };
  };
}
