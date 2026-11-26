# just es un ejecutor de comandos; Justfile es muy parecido a Makefile, pero más simple.

############################################################################
#
#  Commandos de Nix relacionados con la máquina local
#
############################################################################

# HOSTNAME := env_var('HOST')
HOSTNAME := `hostname`
# HOSTNAME := `cat /etc/hostname 2>/dev/null || echo "localhost"`

default:
  @just --list

build:
  nh os build

boot:
  nh os boot

deploy:
  nh os switch

up:
  nix flake update

# Actualizar un input específico
# uso: make upp i=home-manager
upp:
  nix flake update $(i)

history:
  nix profile history --profile /nix/var/nix/profiles/system

repl:
  nix repl -f flake:nixpkgs

clean:
  nh clean
