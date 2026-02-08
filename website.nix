# SPDX-FileCopyrightText: NONE
# SPDX-License-Identifier: CC0-1.0

{
  lib,
  stdenv,
  fetchzip,
  forester,
}:

let
  theme-version = "0.1.2";

  forest-theme = fetchzip {
    url = "https://git.sr.ht/~polykernel/forest-theme/refs/download/v${theme-version}/forest-theme-v${theme-version}.tar.gz";
    hash = "sha256-4EiKJ6+ByodxxdEWDd9UBndooy+sBpKbwc95bOOdjLY=";
    stripRoot = false;
  };
in
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
