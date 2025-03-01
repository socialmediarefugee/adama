{
  description = "Home Manager configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };  
  };

  outputs = inputs@{ nixpkgs, home-manager, plasma-manager, ... }:
    let
      system = "x86_64-linux"; # Adjust for your system
    in {
      homeConfigurations."adama" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ 
          inputs.plasma-manager.homeManagerModules.plasma-manager
          ./home.nix 
          ./plasma.nix
        ];
      };

    };
}
