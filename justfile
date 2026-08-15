set shell := ["bash", "-euo", "pipefail", "-c"]

default:
    @just --list

fmt:
    nix fmt

check:
    nix flake check --print-build-logs

build:
    nh os build

switch:
    nh os switch

boot:
    nh os boot

update:
    nix flake update
    nix flake check --print-build-logs

services:
    systemctl --user --no-pager --type=service --state=running
