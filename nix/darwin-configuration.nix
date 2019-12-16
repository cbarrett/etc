{ config, lib, options, pkgs, ... }:
{
  environment.darwinConfig = "$HOME/.local/etc/nix/darwin-configuration.nix";
  environment.systemPackages =
    with pkgs;
    [
      cmake
      ispell
      glslviewer
      nodejs
      ninja
      nixops
      mercurial
      packer
      ripgrep
      terraform
      urweb
      vagrant
      xz
    ];

  environment.variables.NIX_REMOTE = "daemon";
  launchd.daemons.nix-daemon.environment.OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES";
  programs.bash.enable = true;
  programs.fish.enable = true;
  programs.fish.interactiveShellInit = ''
    set fish_function_path $HOME/.local/etc/fish/functions $fish_function_path
  '';

  services.activate-system.enable = true;
  services.nix-daemon.enable = true;
  /* services.mysql.enable = true; */

  /* system.activationScripts.postActivation.text = '' */
  /*   mkdir -m 775 -p ${config.services.mysql.dataDir} */
  /* ''; */
  system.stateVersion = 4;
  nix.maxJobs = 2;
  nix.nixPath = [ "darwin=/Users/cbarrett/Documents/Code/nix-darwin/default.nix" ] ++ options.nix.nixPath.default;
  nix.package = pkgs.nix;
  nix.trustedUsers = [ "root" "cbarrett" ];
}
