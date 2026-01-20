{ lib, python3Packages }:

python3Packages.buildPythonApplication {
  pname = "configops";
  version = "0.1.0";
  format = "other";

  src = ./.;

  propagatedBuildInputs = with python3Packages; [
    ruamel-yaml
    tomlkit
    configupdater
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp config_ops.py $out/bin/configops
    chmod +x $out/bin/configops
  '';
}
