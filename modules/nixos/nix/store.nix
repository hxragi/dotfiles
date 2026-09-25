{
  nix.settings = {
    auto-optimise-store = true;

    # Do not keep the intermediate .drv files or build-only outputs of every
    # derivation around after the fact. Systems already have GC roots through
    # their profile links, so nothing bootable is affected.
    keep-derivations = false;
  };
}
