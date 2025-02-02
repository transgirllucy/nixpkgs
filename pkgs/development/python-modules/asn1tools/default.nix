{
  lib,
  bitstruct,
  buildPythonPackage,
  diskcache,
  fetchFromGitHub,
  prompt-toolkit,
  pyparsing,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asn1tools";
  version = "0.167.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "eerimoq";
    repo = "asn1tools";
    tag = version;
    hash = "sha256-86bdBYlAVJfd3EY8s0t6ZDRA/qZVWuHD4Jxa1n1Ke5E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bitstruct
    pyparsing
  ];

  optional-dependencies = {
    shell = [ prompt-toolkit ];
    cache = [ diskcache ];
  };

  nativeCheckInputs = [
    pytest-xdist
    pytestCheckHook
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "asn1tools" ];

  disabledTests = [
    # assert exact error message of pyparsing which changed and no longer matches
    # https://github.com/eerimoq/asn1tools/issues/167
    "test_parse_error"
  ];

  meta = with lib; {
    description = "ASN.1 parsing, encoding and decoding";
    homepage = "https://github.com/eerimoq/asn1tools";
    changelog = "https://github.com/eerimoq/asn1tools/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "asn1tools";
  };
}
