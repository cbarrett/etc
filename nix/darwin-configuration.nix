{ config, lib, pkgs, ... }:
{
  environment.systemPackages =
    with pkgs;
    [
      cmake
      ispell
      glslviewer
      nodejs-8_x
      ninja
      nixops
      mercurial
      ripgrep
      terraform
      urweb
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

  system.stateVersion = 4;

  nix.maxJobs = 2;
  nix.package = pkgs.nix;
  nix.trustedUsers = [ "root" "cbarrett" ];
}
