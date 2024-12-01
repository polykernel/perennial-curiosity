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
  ];

  processes = {
    preview-server.exec = "${lib.getExe pkgs.python3} -m http.server -d output/";
  };

  difftastic.enable = true;
}
