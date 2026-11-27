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
    nh clean all --keep 5 --keep-since 14d
    sudo nix-store --optimise
    sudo journalctl --vacuum-time=1month
    sudo journalctl --vacuum-size=50M
    sudo systemd-tmpfiles --create --clean --exclude-prefix=/dev
    df -h / /nix/store

audit:
    systemctl list-units --type=service --state=running --no-pager
    systemctl list-timers --all --no-pager
    systemctl list-sockets --all --no-pager
    systemctl --user list-units --type=service --no-pager
