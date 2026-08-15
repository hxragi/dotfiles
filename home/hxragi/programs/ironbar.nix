{ironbar, ...}: {
  imports = [
    ironbar.homeManagerModules.default
  ];

  programs.ironbar = {
    enable = true;
    systemd = true;

    config = {
      position = "top";
      height = 24;

      start = [
        {
          type = "workspaces";
        }
      ];

      center = [];

      end = [
        {
          type = "tray";
        }
        {
          type = "clock";
        }
      ];
    };
  };

  xdg.configFile."ironbar/style.css".text = ''
    @define-color lavender #b4befe;
    @define-color red #f38ba8;

    @define-color text #cdd6f4;
    @define-color subtext0 #a6adc8;

    @define-color overlay0 #6c7086;

    @define-color surface0 #313244;
    @define-color surface1 #45475a;
    @define-color surface2 #585b70;

    @define-color base #1e1e2e;
    @define-color mantle #181825;
    @define-color crust #11111b;

    * {
      border: none;
      border-radius: 0;
      box-shadow: none;
      background-image: none;

      font-family: "JetBrainsMono Nerd Font Mono";
      font-size: 16px;
    }

    box,
    button,
    label,
    image {
      background-color: transparent;
      color: @text;
    }

    button {
      padding: 0 6px;
      margin: 0;

      background-color: transparent;
      background-image: none;

      border: none;
      box-shadow: none;
    }

    button:hover {
      background-color: @surface0;
    }

    button:active {
      background-color: @surface1;
    }

    #bar {
      background-color: @base;
      color: @text;
    }

    #start {
      margin-left: 4px;
    }

    #end {
      margin-right: 6px;
    }

    /* Workspaces */

    .workspaces {
      background-color: transparent;
    }

    .workspaces .item {
      min-width: 18px;

      padding: 0 5px;

      background-color: transparent;
      color: @overlay0;

      box-shadow: inset 0 -2px transparent;
    }

    .workspaces .item:hover {
      background-color: transparent;
      color: @text;

      box-shadow: inset 0 -2px @surface1;
    }

    .workspaces .item.visible {
      background-color: transparent;
      color: @subtext0;
    }

    .workspaces .item.focused {
      background-color: transparent;
      color: @lavender;

      box-shadow: inset 0 -2px @lavender;
    }

    .workspaces .item.urgent {
      background-color: transparent;
      color: @red;

      box-shadow: inset 0 -2px @red;
    }

    .tray {
      padding: 0;
      margin-right: 8px;

      background-color: transparent;
    }

    .tray button {
      min-width: 18px;

      padding: 0 3px;

      background-color: transparent;
      background-image: none;

      border: none;
      box-shadow: none;
    }

    .tray button:hover {
      background-color: @surface0;

      border-radius: 4px;
    }

    .tray button:active {
      background-color: @surface1;

      border-radius: 4px;
    }

    .clock {
      padding: 0 2px;

      background-color: transparent;
      color: @text;

      font-weight: bold;
    }

    .clock:hover {
      color: @lavender;
    }

    popover {
      background-color: transparent;
      color: @text;

      border: none;
      box-shadow: none;
    }

    popover > contents,
    popover contents {
      background-color: @mantle;
      color: @text;

      padding: 6px;

      border: 1px solid @surface1;
      border-radius: 8px;
      box-shadow: none;
    }

    popover box,
    popover label,
    popover image {
      background-color: transparent;
    }

    popover.menu {
      background-color: transparent;

      border: none;
      box-shadow: none;
    }

    popover.menu > contents,
    popover.menu contents {
      background-color: @mantle;
      color: @text;

      padding: 5px;

      border: 1px solid @surface1;
      border-radius: 8px;
      box-shadow: none;
    }

    popover.menu box {
      background-color: transparent;
    }

    popover.menu button,
    popover.menu button.model {
      min-height: 24px;

      padding: 4px 9px;
      margin: 1px 0;

      background-color: transparent;
      background-image: none;

      color: @text;

      border: none;
      border-radius: 5px;
      box-shadow: none;
    }

    popover.menu button:hover,
    popover.menu button.model:hover {
      background-color: @surface0;
      color: @lavender;
    }

    popover.menu button:active,
    popover.menu button.model:active {
      background-color: @surface1;
      color: @lavender;
    }

    popover.menu button:checked,
    popover.menu button.model:checked {
      background-color: @surface0;
      color: @lavender;
    }

    popover.menu button label,
    popover.menu button.model label {
      background-color: transparent;
      color: inherit;
    }

    popover.menu separator {
      min-height: 1px;

      margin: 4px 5px;

      background-color: @surface1;
    }

    popover arrow {
      background-color: @mantle;
      color: @text;
    }

    .popup-clock {
      background-color: @mantle;
      color: @text;
    }

    .popup-clock .calendar-clock {
      background-color: transparent;
      color: @lavender;

      font-size: 1.4em;
      font-weight: bold;
    }

    calendar,
    calendar.view {
      padding: 8px;

      background-color: @mantle;
      color: @text;

      border: none;
      border-radius: 8px;
      box-shadow: none;
    }

    calendar header {
      padding: 2px;

      background-color: transparent;
      color: @text;
    }

    calendar header button {
      min-width: 24px;
      min-height: 24px;

      padding: 0;

      background-color: transparent;
      background-image: none;

      color: @subtext0;

      border: none;
      border-radius: 5px;
      box-shadow: none;
    }

    calendar header button:hover {
      background-color: @surface0;
      color: @lavender;
    }

    calendar header button:active {
      background-color: @surface1;
      color: @lavender;
    }

    calendar header stack,
    calendar header stack.month,
    calendar header label,
    calendar header label.year {
      background-color: transparent;
      color: @text;

      font-weight: bold;
    }

    calendar grid {
      background-color: transparent;
    }

    calendar grid label {
      padding: 3px 5px;

      background-color: transparent;
      color: @text;

      border-radius: 4px;
    }

    calendar grid label.day-name {
      color: @lavender;
      font-weight: bold;
    }

    calendar grid label.week-number {
      color: @overlay0;
    }

    calendar grid label.other-month {
      color: @overlay0;
    }

    calendar grid label.today {
      background-color: @lavender;
      color: @crust;

      font-weight: bold;
    }

    calendar grid label:selected {
      background-color: @lavender;
      color: @crust;
    }

    tooltip {
      background-color: @mantle;

      border: 1px solid @surface1;
      border-radius: 6px;
      box-shadow: none;
    }

    tooltip label {
      padding: 4px 6px;

      background-color: transparent;
      color: @text;
    }

    scale > trough {
      min-height: 4px;

      background-color: @surface0;

      border-radius: 4px;
    }

    scale > trough > highlight {
      background-color: @lavender;

      border-radius: 4px;
    }

    scale > trough > slider {
      min-width: 12px;
      min-height: 12px;

      background-color: @text;

      border-radius: 999px;
    }

    switch {
      background-color: @surface0;

      border-radius: 999px;
    }

    switch > slider {
      background-color: @text;

      border-radius: 999px;
    }

    switch:checked {
      background-color: @lavender;
    }
  '';
}
