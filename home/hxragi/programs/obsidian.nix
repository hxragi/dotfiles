{ fonts, pkgs, ... }: {
  catppuccin.obsidian.enable = false;

  programs.obsidian = {
    enable = true;
    vaults.notes.target = "documents/vault";

    defaultSettings = {
      app = {
        showInlineTitle = false;
        promptDelete = false;
      };

      appearance = {
        textFontFamily = fonts.plain;
        interfaceFontFamily = fonts.plain;
        monospaceFontFamily = fonts.plain;
        cssTheme = "Minimal";
      };

      cssSnippets = [
        {
          name = "cortex-ui";
          source = ./cortex-ui.css;
        }
      ];

      themes = with pkgs.obsidianThemes; [
        minimal
      ];

      corePlugins = [
        "file-explorer"
        "global-search"
        "switcher"
        "graph"
        "backlink"
        "canvas"
        "outgoing-link"
        "tag-pane"
        "properties"
        "page-preview"
        "command-palette"
        "editor-status"
        "bookmarks"
        "outline"
        "word-count"
        "file-recovery"
        {
          name = "templates";
          settings = {
            folder = "99_Engine/Templates";
          };
        }
      ];

      hotkeys = {
        "periodic-notes:open-daily-note" = [
          {
            modifiers = [ "Alt" ];
            key = "D";
          }
        ];
        "periodic-notes:open-weekly-note" = [
          {
            modifiers = [ "Alt" ];
            key = "W";
          }
        ];
        "workspace:goto-tab-1" = [
          {
            modifiers = [ "Alt" ];
            key = "1";
          }
        ];
        "templater-obsidian:create-new-note-from-template" = [
          {
            modifiers = [ "Alt" ];
            key = "N";
          }
        ];
      };

      communityPlugins = with pkgs.obsidianPlugins; [
        obsidian-minimal-settings
        quickadd
        {
          pkg = dataview;
          settings = {
            enableDataviewJs = true;
            enableInlineDataview = true;
          };
        }
        {
          pkg = templater-obsidian;
          settings = {
            templates_folder = "99_Engine/Templates";
            trigger_on_file_creation = true;
          };
        }
        {
          pkg = periodic-notes;
          settings = {
            daily = {
              enabled = true;
              format = "YYYY-MM-DD";
              template = "99_Engine/Templates/Daily.md";
              folder = "01_Timeline";
            };
            weekly = {
              enabled = true;
              format = "GGGG-[W]WW";
              template = "99_Engine/Templates/Weekly.md";
              folder = "01_Timeline";
            };
          };
        }
      ];
    };
  };
}
