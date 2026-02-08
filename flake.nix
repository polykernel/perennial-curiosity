{
  nixConfig = {
    extra-substituters = [ "https://forester.cachix.org" ];
    extra-trusted-public-keys = [
      "forester.cachix.org-1:pErGVVci7kZWxxcbQ/To8Lvqp6nVTeyPf0efJxbrQDM="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";

    forester.url = "sourcehut:~jonsterling/ocaml-forester?ref=main";

    git-hooks-nix.url = "github:cachix/git-hooks.nix?ref=master";
    git-hooks-nix.inputs.nixpkgs.follows = "nixpkgs";

    flake-parts.url = "github:hercules-ci/flake-parts?ref=main";
  };

  outputs =
    { flake-parts, ... }@inputs:

    flake-parts.lib.mkFlake { inherit inputs; } (
      top@{ config, ... }:

      {
        imports = [
          inputs.git-hooks-nix.flakeModule
        ];

        systems = [ "x86_64-linux" ];

        perSystem =
          {
            config,
            pkgs,
            system,
            ...
          }:
          {
            packages = {
              website = pkgs.callPackage ./website.nix {
                forester = config.packages.site-builder;
              };
              site-builder = inputs.forester.packages.${system}.default;
            };

            devShells.default = pkgs.mkShell {
              name = "devshell";
              shellHook = config.pre-commit.installationScript;
              buildInputs = config.pre-commit.settings.enabledPackages ++ [
                config.pre-commit.settings.package

                config.packages.site-builder
                pkgs.just
                pkgs.python3
                pkgs.texliveMedium
              ];
            };

            pre-commit.settings.hooks = {
              nixfmt.enable = true;
              typos.enable = true;
              actionlint.enable = true;
              reuse.enable = true;
            };
          };
      }
    );
}
