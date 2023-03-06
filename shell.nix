# save this as shell.nix
{ pkgs ? import <nixpkgs> {}}:

let
  python-packages = p: with p; [
    # Enter python library names here:
    pandas
    scipy
    numpy
    scikit-learn
    sympy
    pymoo
  ];
  # Python interpreter with python-packages.
  python-with-packages = pkgs.python3.withPackages python-packages;
  # Common tools and dependencies.
  common-utils = with pkgs; [ curl wget gcc ];
  # Make shell with common tools/dependencies and python environment.
in pkgs.mkShell {
  packages = common-utils ++ 
             [ python-with-packages ] ++
             # Put other packages here: e.g:
             (with pkgs; [ 
             # pandoc
             # jq 
             # jp
             # yq
             ]);
}