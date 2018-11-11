{}:
with builtins;
let
  rev = "722fcbbb80b2142583e9266efe77992f8e32ac4c";
  url = "https://github.com/NixOS/nixpkgs/archive/${rev}.tar.gz";
  config =
    { packageOverrides = super:
      let self = super.pkgs;
          lib = super.haskell.lib;
          overrides = self: super: {
            ansi-terminal = super.callPackage ./ansi-terminal-0.6.3.1.nix {};
            async = super.callPackage ./async-2.1.1.1.nix {};
            lifted-async = super.callPackage ./lifted-async-0.9.3.3.nix {};
            exceptions = super.callPackage ./exceptions-0.8.3.nix {};
            stm = super.callPackage ./stm-2.4.5.1.nix {};
            concurrent-output = super.callPackage ./concurrent-output-1.9.2.nix {};
          };
      in {
        haskell = super.haskell // {
          packages = super.haskell.packages // {
            ghc861 = super.haskell.packages.ghc861.override {
              overrides = self: super: {
                hoopl_3_10_2_2 = self.callPackage ./hoopl-3.10.2.2.nix {};
              };
            };
            ghc802 = super.haskell.packages.ghc802.override { inherit overrides; };
            ghc7103 = super.haskell.packages.ghc7103.override {
              overrides =
                self: super: overrides self super // {
                  transformers-compat = lib.appendConfigureFlag super.transformers-compat "-f-generic-deriving";
                  utf8-string = super.callPackages ./utf8-string-1.0.1.1.nix {};
                  haskell-src-exts = super.callPackage ./haskell-src-exts-1.20.3.nix {};
              };
            };
          };
        };
      };
    };
  nixpkgs = import (fetchTarball { inherit url; }) { inherit config; };
in nixpkgs
