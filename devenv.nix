{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  packages = [
    inputs.forester.packages.${pkgs.stdenv.system}.default
    pkgs.texliveMedium
    pkgs.just
    pkgs.treefmt
  ];

  processes = {
    preview-server.exec = "${lib.getExe pkgs.python3} -m http.server -d output/";
  };

  pre-commit.hooks.treefmt = {
    enable = true;
    settings.formatters = [
      pkgs.nixfmt-rfc-style
      pkgs.typos
      pkgs.toml-sort
    ];
  };

  difftastic.enable = true;
}
