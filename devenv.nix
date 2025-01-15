{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  languages.texlive = {
    enable = true;
    base = pkgs.texliveMedium;
  };

  packages = [
    inputs.forester.packages.${pkgs.stdenv.system}.default
    pkgs.just
    pkgs.python3
  ];

  pre-commit.hooks = {
    treefmt = {
      enable = true;
      settings.formatters = [
        pkgs.nixfmt-rfc-style
        pkgs.typos
        pkgs.toml-sort
      ];
    };
    reuse.enable = true;
  };

  difftastic.enable = true;
}
