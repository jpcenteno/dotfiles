{
  description = "Home Manager configuration of j";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    desktop-entry-launcher = {
      url = "github:jpcenteno/desktop-entry-launcher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, desktop-entry-launcher, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system} = {
        default = home-manager.defaultPackage.${system};
        homeConfigurations."j" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          # Specify your home configuration modules here, for example,
          # the path to your home.nix.
          modules = [ 
            {
              home.packages = [
                desktop-entry-launcher.packages.${system}.default
              ];
            }
            ./home.nix
          ];


          # Optionally use extraSpecialArgs
          # to pass through arguments to home.nix
        };
      };
    };
}
