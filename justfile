set shell := ["bash", "-euo", "pipefail", "-c"]

default:
    @just --list

fmt:
    nix fmt

check:
    nix flake check --print-build-logs

switch:
    nh os switch

update:
    nix flake update
    nix flake check --print-build-logs

gc:
    sudo nh clean all --keep 1
    sudo nix-collect-garbage -d

audit:
    systemctl list-units --type=service --state=running --no-pager
    systemctl list-timers --all --no-pager
    systemctl list-sockets --all --no-pager
    systemctl --user list-units --type=service --no-pager
