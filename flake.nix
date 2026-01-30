{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    claude-code-nix.url = "github:sadjow/claude-code-nix";
  };

  outputs = { nixpkgs, claude-code-nix, ... }: {
    nixosConfigurations = {
      hetzner-x86_64 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit claude-code-nix; };
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
