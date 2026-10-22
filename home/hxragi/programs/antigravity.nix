{ inputs, pkgs, ... }:

let
  patched-antigravity-cli = inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli.overrideAttrs (oldAttrs: {
    nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [
      pkgs.perl
      pkgs.gnugrep
    ];

    postFixup = (oldAttrs.postFixup or "") + ''
      BIN="$out/bin/agy"

      if [ -f "$BIN" ]; then
        perl -pi -e '
          BEGIN { $/ = undef; }
          s/\x48\x85\xc9\x0f\x84....\x80\x79\x08\x00\x0f\x85....\x48\x89\xc8\x90\xe8....\x48\x89\x84\x24\xe0\x00\x00\x00\x48\x89\x9c\x24\xe8\x00\x00\x00\x48\x89\x8c\x24\xf0\x00\x00\x00/\x48\x85\xc9\x0f\x84$&=~s@\x80\x79\x08\x00@\x48\x85\xc9\x90@r/se;
        ' "$BIN" 2>/dev/null || true

        ${pkgs.python3}/bin/python3 -c "
import re, sys
with open('$BIN', 'rb') as f:
    data = f.read()

search = rb'\x48\x85\xc9\x0f\x84.{4}\x80\x79\x08\x00\x0f\x85.{4}\x48\x89\xc8\x90\xe8.{4}\x48\x89\x84\x24\xe0\x00\x00\x00\x48\x89\x9c\x24\xe8\x00\x00\x00\x48\x89\x8c\x24\xf0\x00\x00\x00'
m = re.search(search, data, re.DOTALL)
if not m:
    print('❌ Signature NOT found in binary')
    sys.exit(1)

match_bytes = bytearray(m.group())
offset = m.start()
data_ba = bytearray(data)
data_ba[offset+9:offset+13] = b'\x48\x85\xc9\x90'

with open('$BIN', 'wb') as f:
    f.write(data_ba)
print('✅ Patch applied successfully at offset', hex(offset))
"
      else
        echo "⚠️ Binary not found at $BIN"
        ls -la "$out/bin/" || true
        exit 1
      fi
    '';

    dontPatchELF = true;
  });
in
{
  home.packages = [
    patched-antigravity-cli
  ];
}
