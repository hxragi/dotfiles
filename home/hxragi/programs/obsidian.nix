{ fonts, pkgs, ... }: {
  programs.obsidian = {
    enable = true;
    vaults.notes.target = "documents";
    defaultSettings = {
      app = {
        showInlineTitle = false;
      };
      appearance = {
        textFontFamily = fonts.plain;
        interfaceFontFamily = fonts.plain;
        monospaceFontFamily = fonts.plain;
      };
      communityPlugins = with pkgs.obsidianPlugins; [
        obsidian-kanban
        dataview
      ];
    };
  };
}
