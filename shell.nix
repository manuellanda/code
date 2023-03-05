# save this as shell.nix
{ pkgs ? import <nixpkgs> {}}:

pkgs.mkShell {
  packages = with pkgs; 
             [ 
               python310
               python310Packages.pandas
               python310Packages.scipy
               python310Packages.numpy
               python310Packages.scikit-learn
               python310Packages.sympy
               python310Packages.pymoo
             ];
}