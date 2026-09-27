set shell := ["bash", "-euo", "pipefail", "-c"]

default:
    @just --list

fmt:
    nix fmt

check:
    nix flake check --print-build-logs

switch:
    sudo nixos-rebuild switch --flake .#shinoa

update:
    nix flake update
    nix flake check --print-build-logs

gc:
    sudo nix-collect-garbage --delete-older-than 14d
    sudo nix-store --optimise
    sudo find /nix/var/nix/profiles /nix/var/nix/gcroots/per-user -maxdepth 1 -xtype l -delete
    sudo journalctl --vacuum-time=1month
    sudo journalctl --vacuum-size=50M
    sudo systemd-tmpfiles --create --clean --exclude-prefix=/dev
    df -h / /nix/store

audit:
    systemctl list-units --type=service --state=running --no-pager
    systemctl list-timers --all --no-pager
    systemctl list-sockets --all --no-pager
    systemctl --user list-units --type=service --no-pager
