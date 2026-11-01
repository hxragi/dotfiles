{ fonts, pkgs, ... }: {
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
      };

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
            folder = "05-System/Templates";
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
      };

      communityPlugins = with pkgs.obsidianPlugins; [
        obsidian-kanban
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
            templates_folder = "05-System/Templates";
            trigger_on_file_creation = true;
          };
        }
        {
          pkg = periodic-notes;
          settings = {
            daily = {
              enabled = true;
              format = "YYYY-MM-DD";
              template = "05-System/Templates/Daily.md";
              folder = "01-Daily";
            };
            weekly = {
              enabled = true;
              format = "GGGG-[W]WW";
              template = "05-System/Templates/Weekly.md";
              folder = "02-Weekly";
            };
          };
        }
      ];
    };
  };
}
