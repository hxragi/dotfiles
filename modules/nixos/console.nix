{
  lib,
  ...
}:
let
  p = (import ../../lib/palette.nix).mocha;
  hex = name: lib.removePrefix "#" p.${name};
in
{
  console.colors = [
    (hex "surface2")
    (hex "red")
    (hex "green")
    (hex "yellow")
    (hex "blue")
    (hex "pink")
    (hex "teal")
    (hex "subtext1")
    (hex "surface1")
    (hex "red")
    (hex "green")
    (hex "yellow")
    (hex "blue")
    (hex "mauve")
    (hex "sky")
    (hex "text")
  ];
}
