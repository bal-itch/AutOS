{
  inputs,
  pkgs,
  home,
  ...
}: {
  imports = [
    inputs.arrpc.homeManagerModules.default
  ];
  
  home.packages = [ pkgs.webcord-vencord ];

  # provided by the arrpc-flake home-manager module
  services.arrpc.enable = true;
}
