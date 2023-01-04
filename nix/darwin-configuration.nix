{ config, lib, options, pkgs, ... }:
{
  environment.darwinConfig = "/Users/cbarrett/.local/etc/nix/darwin-configuration.nix";
  environment.systemPackages =
    with pkgs;
    [
      ispell
      nodejs
      mercurial
      ripgrep
      terraform_0_13
      xz
      yarn
    ];
  environment.variables.NIX_REMOTE = "daemon";

  programs.bash.enable = true;
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    set fish_function_path /Users/cbarrett/.local/etc/fish/functions $fish_function_path
  '';

  services.activate-system.enable = true;
  services.nix-daemon.enable = true;
  /* services.mysql.enable = true; */
  /* services.mysql.package = pkgs.mysql80; */

  system.stateVersion = 4;

  /* nix.nixPath = [ { darwin = "/Users/cbarrett/Documents/Code/nix-darwin/default.nix"; } ]; */
  nix.package = pkgs.nix;
  nix.settings.max-jobs = 2;
  nix.settings.trusted-users = [ "root" "cbarrett" ];
}
