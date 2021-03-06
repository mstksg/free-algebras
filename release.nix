{ compiler }:

with builtins;
let default = import ./default.nix
      { haddock    = true;
        test       = true;
        benchmarks = true;
        dev        = true;
        inherit compiler;
      };
in
  { free-algebras = default.free-algebras;
    examples      = default.examples;
  }
