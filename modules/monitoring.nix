# Grafana and Prometheus.
# Default login is admin:admin.
{
  config,
  pkgs,
  unstablePkgs,
  ...
}: let
  grafana-domain = "monitor";
  grafana-port = 20000;
  prom-port = 20001;
  prom-node-port = 20002;
in {
  services.grafana = {
    enable = true;
    settings.server = {
      domain = "localhost:${toString grafana-port}";
      http_port = grafana-port;
      http_addr = "127.0.0.1";
    };
    openFirewall = false;

    provision = {
      enable = true;

      datasources.settings.datasources = [
        {
          name = "Prometheus";
          type = "prometheus";
          url = "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
          isDefault = true;
          editable = false;
        }
      ];
    };
  };

  # https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters
  services.prometheus.exporters.node = {
    enable = true;
    port = prom-node-port;
    openFirewall = false;
    # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/exporters.nix
    enabledCollectors = ["systemd"];
    # nix-shell -p prometheus-node-exporter --command 'node_exporter --help'
    extraFlags = [];
  };

  # https://wiki.nixos.org/wiki/Prometheus
  # https://nixos.org/manual/nixos/stable/#module-services-prometheus-exporters-configuration
  # https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/monitoring/prometheus/default.nix
  services.prometheus = {
    enable = true;
    globalConfig.scrape_interval = "10s";
    listenAddress = "localhost";
    port = prom-port;
    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [
          {
            targets = ["localhost:${toString config.services.prometheus.exporters.node.port}"];
          }
        ];
      }
    ];
  };
}
