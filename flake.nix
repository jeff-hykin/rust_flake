{
    description = "Rust versions setup via fenix";

    inputs = {
        fenix.url = "github:nix-community/fenix";
        fenix.inputs.nixpkgs.follows = "nixpkgs";
        rust-manifest = {
            url = "https://static.rust-lang.org/dist/2025-03-18/channel-rust-1.85.1.toml";
            flake = false;
        };
    };

    outputs = { self, libSource, nixpkgs, flakeUtils, xome, ... }:
        flakeUtils.lib.eachSystem flakeUtils.lib.allSystems (system:
            let
                rustToolchain = (fenix.packages.${system}.fromManifestFile rust-manifest).complete;
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
                }
        );
}
