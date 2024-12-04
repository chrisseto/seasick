{
  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , flake-parts
    , ...
    }: flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "aarch64-linux" "x86_64-linux" ];

      perSystem = { self', system, ... }:
        let
          pkgs = import nixpkgs { inherit system; };
          buildInputs = with pkgs; [
            boost175
            c-ares
            cmake
            git
            fmt
            gnutls
            hwloc
            liburing
            libxfs
            libyamlcpp
            lksctp-tools
            lz4
            numactl
            openssl
            pkg-config
            protobuf
            ragel
            doxygen
            valgrind
            zlib
            zstd
            python3
            dpdk
            libsystemtap
          ];
          seastar = pkgs.stdenv.mkDerivation {
            pname = "seastar";
            version = "v24.3.x";

            src = pkgs.fetchFromGitHub {
              owner = "redpanda-data";
              repo = "seastar";
              rev = "ef24a8bc3f7dca212dfe982911bb726e5d37cef5";
              hash = "sha256-KT6Yz+SWQw6jQTaIWhdOyJay9K50928/vpRXe/IGc4Y=";
            };

            inherit buildInputs;

            postPatch = ''
              patchShebangs ./scripts/seastar-json2code.py
              patchShebangs ./cooking.sh
            '';

            cmakeFlags = [
              "-D=Seastar_DEMOS=FAlSE"
              "-D=Seastar_APPS=FAlSE"
              "-D=Seastar_DOCS=FAlSE"
              "-D=Seastar_TESTING=FAlSE"
            ];

          };
        in
        rec {
          formatter = pkgs.nixpkgs-fmt;

          devShells.default = pkgs.mkShell {
            # Pulled from https://github.com/scylladb/scylladb/blob/master/default.nix
            buildInputs = buildInputs ++ [ seastar ];
          };

          packages.default = pkgs.stdenv.mkDerivation {
            pname = "seasick";
            version = "1.0";

            src = self;

            buildInputs = buildInputs ++ [ seastar ];
          };
        };
    };
}
