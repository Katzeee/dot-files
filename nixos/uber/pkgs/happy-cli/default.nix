{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "happy-cli";
  version = "0.14.0-0";

  src = fetchFromGitHub {
    owner = "slopus";
    repo = "happy-cli";
    rev = "v${version}";
    hash = "sha256-kEYgo+n1qv+jJ9GvqiwJtf6JSA2xSkLMEbvuY/b7Gdk=";
  };

  npmDepsHash = "sha256-KkjWeG6HDGqNzruDMuMc3T3zfUNLdicsnH3NFLkd95Y=";
  npmBuildScript = "build";

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  meta = with lib; {
    description = "Mobile and Web client for Claude Code and Codex";
    homepage = "https://github.com/slopus/happy-cli";
    license = licenses.mit;
    mainProgram = "happy";
    platforms = platforms.unix;
  };
}
