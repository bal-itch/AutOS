{
  nixpkgs,
  self,
  outputs,
  ...
}: let
  inputs = self.inputs;

  home-manager = inputs.home-manager.nixosModules.home-manager;
  home = ../homes;

in {

  typhoon = nixpkgs.lib.nixosSystem {
    specialArgs = {inherit inputs outputs;};
    modules = [
      # this list defines which files will be imported to be used as "modules" in the system config
      ./typhoon/configuration.nix
      # use the nixos-module for home-manager
      home-manager
      home
    ];
  };
}
