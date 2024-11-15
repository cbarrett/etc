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
      cmake
      doctl
      (haskellPackages.ghcWithPackages (p: [p.tidal]))
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
      xz
      update-nix-fetchgit
      # unstable.yarn-berry
    ];
  environment.variables.EDITOR = "/usr/bin/vim";
  environment.variables.NIX_REMOTE = "daemon";

  ids.uids.nixbld = 300;

  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    set fish_function_path /Users/cbarrett/.local/etc/fish/functions $fish_function_path
  '';

  services.activate-system.enable = true;
  services.nix-daemon.enable = true;
  /* services.mysql.enable = true; */
  /* services.mysql.package = pkgs.mysql80; */
  /* services.postgresql.enable = true; */
  /* services.redis.enable = true; */

  # system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 5;

  # not needed with flakes
  /* nix.nixPath = [ "darwin=/Users/cbarrett/Documents/Code/nix-darwin/default.nix" ]; */
  nix.package = pkgs.nix;
  nix.settings.max-jobs = 2;
  nix.settings.trusted-users = [ "root" "cbarrett" ];
  nix.settings.experimental-features = "nix-command";

  nixpkgs.hostPlatform = "x86_64-darwin";

}
