{ pkgs, fresh, ... }: {
  home.packages = [
    (pkgs.rustPlatform.buildRustPackage {
      pname = "fresh";
      version = "git";
      src = fresh;
      
      cargoLock = {
        lockFile = "${fresh}/Cargo.lock";
      };
      
      nativeBuildInputs = [ 
        pkgs.pkg-config 
        pkgs.rustPlatform.bindgenHook
      ];
      buildInputs = [ 
        pkgs.llvmPackages.libclang 
      ];
      LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
      
      doCheck = false;
    })
  ];
}
