{
    description = "Rust versions setup via fenix";

    inputs = {
        flake-utils.url = "github:numtide/flake-utils";
        nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
        fenix.url = "github:nix-community/fenix";
        fenix.inputs.nixpkgs.follows = "nixpkgs";
        rust-manifest = {
            url = "https://static.rust-lang.org/dist/2025-03-18/channel-rust-1.85.1.toml";
            flake = false;
        };
    };

    outputs = { self, flake-utils, nixpkgs, fenix, rust-manifest, ... }:
        flake-utils.lib.eachSystem flake-utils.lib.allSystems (system:
            let
                pkgs = import nixpkgs { inherit system; };
                rustToolchain = (fenix.packages.${system}.fromManifestFile rust-manifest).toolchain;
                rustPlatform = pkgs.makeRustPlatform {
                    cargo = rustToolchain;
                    rustc = rustToolchain;
                };
            in
                {
                    lib = {
                        inherit rustPlatform;
                    };
                    packages = {
                        rust = rustToolchain;
                    };
                    devShells.default = pkgs.mkShell {
                        buildInputs = [ rustToolchain ];
                        shellHook = ''
                        '';
                    };
                }
        );
}
