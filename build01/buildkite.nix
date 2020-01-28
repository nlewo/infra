{ pkgs, ... }:

{
  services.buildkite-agent = {
    enable = true;
    tokenPath = "/run/keys/buildkite-token";
    openssh.privateKeyPath = builtins.toPath "/run/keys/buildkite-agent-key";
    openssh.publicKeyPath = builtins.toPath "/run/keys/buildkite-agent-key.pub";

    runtimePackages = [
      pkgs.gnutar
      pkgs.bash
      pkgs.nix
      pkgs.gzip
    ];

    hooks.environment = ''
      #!/usr/bin/env bash
      set -euo pipefail

      if [[ "$BUILDKITE_PIPELINE_SLUG" == "nixpkgs-swh" ]]; then
        export GITHUB_LEWO_CI_TOKEN=$(cat /run/keys/github-lewo-ci-token)
      fi
    '';
  };
}
