{ config, lib, options, pkgs, /* inputs, */ ... }:
let unstable =
  import <nixpkgs-unstable> { config = config.nixpkgs.config; };
in
{
  # not needed with flakes
  environment.darwinConfig = "/Users/cbarrett/.local/etc/nix/darwin-configuration.nix";
  environment.systemPackages =
    with pkgs;
    [
      (agda.withPackages (p: [
        p.cubical
        p.standard-library
        # Warning: HoTTest Summer School needs stdlib-1.3
/*
        (p.mkDerivation {
          pname = "plfa";
          version = "1.0.0";
          src = /Users/cbarrett/Documents/Code/plfa.github.io/src/plfa.agda-lib;
          meta.description = "Programming Language Foundations in Agda";
         })
*/
      ]))
      unstable.bun
      cachix
      cmake
      unstable.doctl
      # (haskellPackages.ghcWithPackages (p: [p.tidal p.hakyll]))
      inkscape
      ispell
      imgcat
      # nodejs
      # ocamlPackages.dune_3
      # ocamlPackages.merlin
      # ocamlPackages.ocaml
      # ocamlPackages.ocp-indent
      # ocamlPackages.utop
      # ocamlformat
      ripgrep
      streamlink
      update-nix-fetchgit
      uv
      xz
    ];
  environment.variables.EDITOR = "/usr/bin/vim";
  environment.variables.NIX_REMOTE = "daemon";

  imports = [
    (let
      module = fetchTarball {
        name = "source";
        url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.1-3.tar.gz";
        sha256 = "sha256-Yg/5ijDktWPsAXivL3V1KLx9pp9auIsiEZR5rBgOAA8";
      };
        lixSrc = fetchTarball {
          name = "source";
          url = "https://git.lix.systems/lix-project/lix/archive/2.91.1.tar.gz";
          sha256 = "sha256-hiGtfzxFkDc9TSYsb96Whg0vnqBVV7CUxyscZNhed0U";
        };
    in import "${module}/module.nix" { lix = lixSrc; })
  ];

  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    set fish_function_path /Users/cbarrett/.local/etc/fish/functions $fish_function_path
  '';

  services.nix-daemon.enable = true;
  /* services.mysql.enable = true; */
  /* services.mysql.package = pkgs.mysql80; */
  /* services.postgresql.enable = true; */
  /* services.redis.enable = true; */

  # system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 5;

  # not needed with flakes
  /* nix.nixPath = [ "darwin=/Users/cbarrett/Documents/Code/nix-darwin/default.nix" ]; */
  nix.settings.experimental-features = "nix-command";
  nix.settings.max-jobs = 2;
  nix.settings.substituters = [ "https://nix-community.cachix.org" ];
  nix.settings.trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
  nix.settings.trusted-users = [ "root" "cbarrett" ];

  nixpkgs.hostPlatform = "x86_64-darwin";

}
