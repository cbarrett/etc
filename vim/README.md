# .vimrc and plugins

## Installation

In the `pack/` subdirectory run:

```shell
nix-build -E '(import <nixpkgs> {}).callPackage ./. {}'
```

This will create a `pack/result` symlink with `start` and `opt` subdirectories.

## Adding or updating a plugin:

To generate the sha256 hash run:

```shell
nix run nixpkgs.nix-prefetch-github -c nix-prefetch-github --nix <OWNER> <REPO> --rev <REVISION>
```

You will have to massage the output slightly, see `pack/vim-plugins.nix` for the format.
