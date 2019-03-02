{ config, lib, pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [ 
      bundix
      haskellPackages.Agda
      jbuilder
      nix-repl
      nodePackages.node2nix
      nodejs-8_x
      ripgrep
      sbt
      scala
      terraform
    ];

  environment.variables.NIX_REMOTE = "daemon";

  programs.bash.enable = true;
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    set fish_function_path /Users/cbarrett/.local/etc/fish/functions $fish_function_path
  '';

  services.activate-system.enable = true;
  services.nix-daemon.enable = true;

  system.stateVersion = 3;

  nix.maxJobs = 2;
  nix.package = pkgs.nix;
  nix.trustedUsers = [ "root" "cbarrett" ];
}
