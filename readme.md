# What is this?

Its a wrapper that makes rust a bit easier to use with nix.


# How do I use it?

### How do I use it from the command line?

Make sure you have nix installed:

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Then install rust (includes rustc, cargo, rustfmt, rust-std, rust-docs, rust-clippy, etc):

```sh
nix-env -i -f https://github.com/jeff-hykin/rust_flake/archive/v1.89.0.tar.gz
# or, if you have flakes:
nix profile install 'https://github.com/jeff-hykin/rust_flake/archive/v1.89.0.tar.gz#nvs'
```

### How do I use it in a Flake?

`flake.nix`

```nix
{
    description = "Rust versions setup via fenix";

    inputs = {
        rustFlake.url = "github:jeff-hykin/rust_flake/v1.89.0";
    };

    outputs = { self, flake-utils, nixpkgs, rustFlake, ... }:
        flake-utils.lib.eachSystem flake-utils.lib.allSystems (system:
            let
                pkgs = import nixpkgs { inherit system; };
                rust = rustFlake.packages.${system};
                rustPkg = rust.default; 
            in
                {
                    packages.default = rust.lib.rustPlatform.buildRustPackage {
                        pname = "your-project";
                        version = "0.1.0";
                        src = ./.;

                        cargoLock = {
                            lockFile = ./Cargo.lock;
                        };

                        meta = {
                            description = "Your Rust project";
                        };
                    };
                    
                    devShells.default = pkgs.mkShell {
                        buildInputs = [ rustPkg ]; # rustc, cargo, rustfmt, rust-std, rust-docs, rust-clippy, etc
                    };
                }
```


## How do I pick nightly / beta / stable?

This repo is just stable. If you want nightly or beta, create an issue and I'll add it.