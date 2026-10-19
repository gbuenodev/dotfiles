{
  description = "My dotfiles";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      user = "gbueno";

      # home-manager settings shared by every host; extra = host-only home modules
      homeManager = extra: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.extraSpecialArgs = { inherit user; };
        home-manager.users.${user}.imports = [ ./home ] ++ extra;
      };
    in
    {
      darwinConfigurations.kokiri = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit user; };
        modules = [
          ./hosts/kokiri
          home-manager.darwinModules.home-manager
          (homeManager [ ./hosts/kokiri/home.nix ])
          # Optional work account; remove this line (and the file) to drop it
          ./hosts/kokiri/suaquadra.nix
        ];
      };

      nixosConfigurations.hyrule = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit user; };
        modules = [
          ./hosts/hyrule
          home-manager.nixosModules.home-manager
          (homeManager [ ])
        ];
      };

      formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.nixfmt-tree;
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
