{ config, lib, options, pkgs, ... }:
{
  environment.darwinConfig = "/Users/cbarrett/.local/etc/nix/darwin-configuration.nix";
  environment.systemPackages =
    with pkgs;
    [
      ispell
      glslviewer
      nodejs
      mercurial
      packer
      ripgrep
      terraform
      vagrant
      wp-cli
      xz
    ];

  environment.variables.NIX_REMOTE = "daemon";
  launchd.daemons.nix-daemon.environment.OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
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
  nix.maxJobs = 2;
  /* nix.nixPath = [ { darwin = "/Users/cbarrett/Documents/Code/nix-darwin/default.nix"; } ]; */
  nix.package = pkgs.nix;
  nix.trustedUsers = [ "root" "cbarrett" ];
}
