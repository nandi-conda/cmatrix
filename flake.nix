{
  description = "cmatrix - A terminal based 'The Matrix' like screen saver";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.cmatrix = pkgs.stdenv.mkDerivation {
          pname = "cmatrix";
          version = "2.0";

          src = ./.;

          nativeBuildInputs = [ pkgs.cmake pkgs.binutils ];
          buildInputs = [ pkgs.ncurses ];

          cmakeFlags = [
            "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
          ];

          postInstall = ''
            ${pkgs.stdenv.cc.targetPrefix}objcopy --remove-section .note.gnu.property "$out/bin/cmatrix"
          '';

          meta = with pkgs.lib; {
            description = "Terminal based 'The Matrix' like screen saver";
            homepage = "https://github.com/abishekvashok/cmatrix";
            license = licenses.gpl3Plus;
            platforms = platforms.unix;
          };
        };

        defaultPackage = self.packages.${system}.cmatrix;

        devShell = pkgs.mkShell {
          buildInputs = [ pkgs.cmake pkgs.ncurses ];
        };
      }
    );
}
