{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkgconfig
, bzip2
, zstd
}:

rustPlatform.buildRustPackage rec {
  pname = "gptcommit";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "thekorn";
    repo = "gptcommit";
    rev = "v${version}";
    hash = "sha256-XyKibEaDnA4UsGHz2Vq3Xvf6zi9MbXiHDjTkDAKCCjo=";
  };

  configurePhase = ''
    export BZIP2_SYS_USE_PKG_CONFIG=1 ZSTD_SYS_USE_PKG_CONFIG=1
  '';

  buildInputs = [ bzip2 zstd ];
  nativeBuildInputs = [ pkgconfig ];

  cargoLock = {
    lockFile = src + /Cargo.lock;
  };

  meta = let inherit (lib) licenses platforms; in {
    description = "A git prepare-commit-msg hook for authoring commit messages with GPT-3.";
    homepage = "https://github.com/zurawiki/gptcommit";
    license = licenses.gpl3Only;
    platforms = platforms.unix ++ platforms.windows;
  };
}
