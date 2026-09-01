{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        gems = pkgs.bundlerEnv {
          name = "portfolio";
          gemdir = ./.;
        };
      in
      {
        devShells = {
          default = pkgs.mkShell {
            packages = [
              gems
              gems.wrappedRuby
            ];
          };

          bootstrap = pkgs.mkShell {
            packages = with pkgs; [
              ruby
              bundix
            ];
          };
        };
      }
    );
}
