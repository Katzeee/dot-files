{ config, lib, pkgs, ... }:

let
  cfg = config.claude;
  json = pkgs.formats.json { };
  mergeJson = import ../../../lib/mergeJson.nix { inherit lib pkgs; };

  token =
    lib.attrByPath [ "home" "sessionVariables" "ANTHROPIC_AUTH_TOKEN" ]
      null
      config;

  glmSettings = json.generate "claude-settings.json" {
    env = {
      ANTHROPIC_AUTH_TOKEN = token;
      ANTHROPIC_BASE_URL = "https://open.bigmodel.cn/api/anthropic";
      API_TIMEOUT_MS = "3000000";
      CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = 1;
    };
  };

  glmRoot = json.generate "claude-root.json" {
    hasCompletedOnboarding = true;
  };
in
{
  options.claude = {
    enable = lib.mkEnableOption "Claude CLI";

    provider = lib.mkOption {
      type = lib.types.enum [ "anthropic" "glm" ];
      default = "anthropic";
      description = "Claude provider configuration to apply.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.provider != "glm" || (token != null && token != "");
        message =
          "claude.provider is set to \"glm\" but ANTHROPIC_AUTH_TOKEN is not set.";
      }
    ];

    home.packages = with pkgs; [
      (import (builtins.fetchTarball {
        url = "https://github.com/kumulustech/claude-nix/archive/refs/heads/main.tar.gz";
      }) { inherit pkgs; }).claude-code
    ];

    home.activation.claudeSettings = mergeJson.mkActivation {
      name = "claudeSettings";
      when = cfg.provider == "glm";
      entries = [
        {
          path = "${config.home.homeDirectory}/.claude/settings.json";
          patch = glmSettings;
        }
        {
          path = "${config.home.homeDirectory}/.claude.json";
          patch = glmRoot;
        }
      ];
    };
  };
}
