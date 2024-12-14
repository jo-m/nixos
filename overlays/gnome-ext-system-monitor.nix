# Custom CSS file for system monitor (monospace font).
final: prev: {
  gnomeExtensions =
    prev.gnomeExtensions
    // {
      system-monitor = prev.gnomeExtensions.system-monitor.overrideAttrs (oldAttrs: rec {
        postInstall = ''
          cp ${./gnome-ext-system-monitor.css} $out/share/gnome-shell/extensions/system-monitor@gnome-shell-extensions.gcampax.github.com/stylesheet.css
        '';
      });
    };
}
