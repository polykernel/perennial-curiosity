# SPDX-FileCopyrightText: NONE
# SPDX-License-Identifier: CC0-1.0

{
  lib,
  stdenv,
  fetchzip,
  forester,
  forest-theme,
}:

stdenv.mkDerivation {
  pname = "perennialcuriosity.cc";
  version = "0.1.2";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./assets
      ./files
      ./trees
      ./justfile
      ./forest.toml
    ];
  };

  nativeBuildInputs = [
    forester
  ];

  buildPhase = ''
    runHook preBuild

    # Build the site
    cp -r ${forest-theme} theme
    forester build
    cp -r files/* output/

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r output/* $out

    runHook postInstall
  '';
}
