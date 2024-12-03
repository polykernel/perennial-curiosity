{
  description = "Basic flake for topiary";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    devenv.url = "github:cachix/devenv";
    devenv.inputs.nixpkgs.follows = "nixpkgs";

    forester.url = "sourcehut:~jonsterling/ocaml-forester";

    flake-utils.url = "github:numtide/flake-utils";
  };

  nixConfig = {
    extra-trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "perennial-curiosity:3NPFo27amY6UkSwdflZjpCiEE13ulY4gI5tB8MFlbiU="
    ];
    extra-substituters = [
      "https://devenv.cachix.org"
      "https://attic.polykernel.cc/perennial-curiosity"
    ];
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      perSystem =
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config = { };
            overlays = [ ];
          };

          website = pkgs.callPackage ./website.nix {
            forester = inputs.forester.packages.${system}.default;
          };
        in
        nixpkgs.lib.fix (_self: {
          packages = {
            inherit website;
            site-builder = inputs.forester.packages.${system}.default;
            devenv-up = _self.devShells.default.config.procfileScript;
            devenv-test = _self.devShells.default.config.test;
            default = _self.packages.website;
          };

          devShells = {
            default = inputs.devenv.lib.mkShell {
              inherit inputs pkgs;
              modules = [
                (
                  { lib, ... }:
                  {
                    devenv.root =
                      let
                        devenvRootFileContent = builtins.readFile ./devenv_root;
                      in
                      pkgs.lib.mkIf (devenvRootFileContent != "") devenvRootFileContent;
                  }
                )

                ./devenv.nix
              ];
            };
          };
        });
    in
    inputs.flake-utils.lib.eachSystem supportedSystems perSystem;
}
