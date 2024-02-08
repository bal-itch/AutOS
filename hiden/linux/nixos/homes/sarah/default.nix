{
  pkgs,
  outputs,
  lib,
  ...
}: {
  imports = [
    ./arrpc.nix
    ./packages.nix # home.packages and similar stuff
    ./programs.nix # programs.<programName>.enable
    ./git.nix
  ];

  home = {
    username = "sarah";
    homeDirectory = "/home/sarah";
  };

  gtk = {
    enable = true;
    theme = {
      name = "Breeze";
      package = pkgs.libsForQt5.breeze-gtk;
    };
  };

  # let HM manage itself when in standalone mode
  programs.home-manager.enable = true;

  # Nicely reload system(d) units when changing configs
  systemd.user.startServices = lib.mkDefault "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
