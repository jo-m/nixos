# Overlay for jai - ultra lightweight jail for AI CLIs.
# https://github.com/stanford-scs/jai
final: prev: {
  jai = final.gcc15Stdenv.mkDerivation {
    pname = "jai";
    version = "0.3-dev";

    src = final.fetchFromGitHub {
      owner = "stanford-scs";
      repo = "jai";
      rev = "v0.3";
      hash = "sha256-AByC7Xh1FYbQ/4Au396m2zYUxsLqcF1PEbpdz7x6LaQ=";
    };

    nativeBuildInputs = with final; [
      autoconf
      automake
      pkg-config
      pandoc
    ];

    buildInputs = with final; [
      acl
      util-linux
    ];

    preConfigure = ''
      ./autogen.sh
    '';

    # Skip setuid install hooks (NixOS handles setuid via security.wrappers).
    postInstall = ''
      rm -rf $out/lib/sysusers.d
    '';

    meta = with final.lib; {
      description = "Ultra lightweight jail for AI CLIs on modern Linux";
      homepage = "https://github.com/stanford-scs/jai";
      license = licenses.isc;
      platforms = platforms.linux;
      mainProgram = "jai";
    };
  };
}
