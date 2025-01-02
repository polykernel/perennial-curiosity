{
  lib,
  stdenv,
  fetchzip,
  forester,
}:

let
  forest-theme = fetchzip {
    url = "https://git.sr.ht/~polykernel/forest-theme/refs/download/v0.1.0/forest-theme.tar.gz";
    hash = "sha256-7d5lKerL0YPiGkTk39KMPwLngmyVpWv2hcHe7zJJ+H8=";
    stripRoot = false;
  };
in
stdenv.mkDerivation {
  pname = "website";
  version = "0.1.0";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./assets
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

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r output/* $out

    runHook postInstall
  '';
}
