# Drop SpamAssassin and bogofilter from Evolution's build inputs and cmake
# flags. Evolution hardcodes both as spam-filter backends; removing them
# avoids pulling in perl5.x-SpamAssassin (which periodically fails to build
# upstream) at the cost of losing Evolution's built-in junk-mail filtering.
_final: prev: {
  evolution = prev.evolution.overrideAttrs (oldAttrs: {
    buildInputs =
      builtins.filter
      (p: p != prev.spamassassin && p != prev.bogofilter)
      oldAttrs.buildInputs;

    cmakeFlags =
      builtins.filter
      (
        f: let
          s = toString f;
        in
          !(prev.lib.hasPrefix "-DWITH_SPAMASSASSIN" s
            || prev.lib.hasPrefix "-DWITH_SA_LEARN" s
            || prev.lib.hasPrefix "-DWITH_BOGOFILTER" s)
      )
      oldAttrs.cmakeFlags;
  });
}
