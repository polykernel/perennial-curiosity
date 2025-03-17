{
  description = "Basic flake for topiary";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    forester.url = "sourcehut:~jonsterling/ocaml-forester";

    pre-commit-hooks.url = "github:cachix/git-hooks.nix";

    flake-utils.url = "github:numtide/flake-utils";
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
            default = _self.packages.website;
          };

          checks = {
            pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                treefmt.enable = true;
                treefmt.settings = {
                  formatters = [
                    pkgs.nixfmt-rfc-style
                    pkgs.typos
                    pkgs.toml-sort
                    pkgs.actionlint
                  ];
                };
                reuse.enable = true;
              };
            };
          };

          devShells = {
            default = pkgs.mkShell {
              inherit (_self.checks.pre-commit-check) shellHook;

              nativeBuildInputs = [
                inputs.forester.packages.${pkgs.stdenv.system}.default
                pkgs.just
                pkgs.python3
                pkgs.texliveMedium
              ] ++ _self.checks.pre-commit-check.enabledPackages;
            };
          };
        });
    in
    inputs.flake-utils.lib.eachSystem supportedSystems perSystem;
}
