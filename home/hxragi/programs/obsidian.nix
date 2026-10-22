{ fonts, pkgs, ... }: {
  programs.obsidian = {
    enable = true;
    vaults.notes.target = "documents";

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
        "graph"
        "file-explorer"
        "canvas"
      ];

      hotkeys = {
        "periodic-notes:open-daily-note" = [
          { modifiers = [ "Alt" ]; key = "D"; }
        ];
        "periodic-notes:open-weekly-note" = [
          { modifiers = ["Alt" ]; key = "W"; }
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
            templates_folder = "99 System/Templates";
            trigger_on_file_creation = true;
          };
        }
        {
          pkg = periodic-notes;
          settings = {
            daily = {
              enabled = true;
              format = "YYYY-MM-DD";
              template = "99 System/Templates/T_Daily.md";
              folder = "01 Periodic/Daily";
            };
            weekly = {
              enabled = true;
              format = "YYYY-[W]WW";
              template = "99 System/Templates/T_Weekly.md";
              folder = "01 Periodic/Weekly";
            };
          };
        }
      ];
    };
  };
}
