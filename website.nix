{
  lib,
  stdenv,
  forester,
  just,
  glibcLocalesUtf8,
}:

stdenv.mkDerivation {
  name = "website";

  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.unions [
      ./assets
      ./theme
      ./trees
      ./justfile
      ./forest.toml
      ./index.html
      ./CNAME
    ];
  };

  phases = [
    "unpackPhase"
    "buildPhase"
    "installPhase"
  ];

  nativeBuildInputs = [
    just
    forester
  ];

  buildPhase = ''
    runHook preBuild

    # Build the site
    just build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -r output/* $out

    runHook postInstall
  '';
}
