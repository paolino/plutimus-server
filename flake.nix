 {
   inputs = {
     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
   };

   outputs = { nixpkgs, ... }: {
     nixosConfigurations = {
       hetzner-x86_64 = nixpkgs.lib.nixosSystem {
         system = "x86_64-linux";
         modules = [
           ./configuration.nix
         ];
       };
     };
   };
 }
