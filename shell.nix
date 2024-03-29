{ pkgs ? import <nixpkgs> { } }:

# @see https://github.com/NixOS/nixpkgs/blob/22.05/pkgs/build-support/mkshell/default.nix
pkgs.mkShell {
  # a list of packages to add to the shell environment
  packages = with pkgs;
    [ruby_3_1];
  # propagate all the inputs from the given derivations
  inputsFrom = [];
  # support mkDerivation attrs
}
