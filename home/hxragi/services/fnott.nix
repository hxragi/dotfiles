{
  fonts,
  lib,
  palette,
  ...
}:
let
  p = palette.mocha;
  hex = name: "${lib.removePrefix "#" p.${name}}ff";
in
{
  services.fnott = {
    enable = true;

    settings = {
      main = {
        output = "";
        anchor = "top-right";
        edge-margin-vertical = 8;
        edge-margin-horizontal = 8;
        notification-margin = 6;
        padding-vertical = 10;
        padding-horizontal = 12;

        max-width = 360;
        max-height = 120;

        border-size = 2;
        border-radius = 8;
        border-color = hex "lavender";
        background = hex "base";

        title-font = "${fonts.mono}:size=11:weight=bold";
        title-color = hex "text";
        summary-font = "${fonts.mono}:size=10";
        summary-color = hex "subtext1";
        body-font = "${fonts.mono}:size=10";
        body-color = hex "subtext0";

        default-timeout = 5;
        max-timeout = 10;
      };

      critical = {
        border-color = hex "red";
      };
    };
  };
}
