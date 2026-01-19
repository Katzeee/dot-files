{ config, lib, pkgs, ... }:

let
  cfg = config.claude;
  json = pkgs.formats.json { };
  jsonMerge = import ../../../lib/mkJsonMerge.nix { inherit lib pkgs; };
  templateReplace = import ../../../lib/mkTemplateReplace.nix { inherit lib pkgs; };
  claudePkg = (import (builtins.fetchTarball {
    url = "https://github.com/kumulustech/claude-nix/archive/refs/heads/main.tar.gz";
  }) { inherit pkgs; }).claude-code;

  tokenPath =
    if config ? age && config.age.secrets ? claude
    then config.age.secrets.claude.path
    else null;

  claudeDir = "${config.home.homeDirectory}/.claude";
  settingsPath = "${claudeDir}/settings.json";
  rootPath = "${config.home.homeDirectory}/.claude.json";

  glmSettingsTemplate = {
    env = {
      ANTHROPIC_AUTH_TOKEN = "__TOKEN__";
      ANTHROPIC_BASE_URL = "https://open.bigmodel.cn/api/anthropic";
      API_TIMEOUT_MS = "3000000";
      CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC = 1;
    };
  };

  glmSettingsPatch = templateReplace.mkTemplateReplace {
    templatePath = json.generate "claude-settings-template.json" glmSettingsTemplate;
    replacements = [
      {
        placeholder = "__TOKEN__";
        path = tokenPath;
        escape = "json";
      }
    ];
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
        assertion = cfg.provider != "glm" || tokenPath != null;
        message =
          "claude.provider is set to \"glm\" but age.secrets.claude is not configured.";
      }
    ];

    home.packages = [ claudePkg ];

    home.activation.claudeSettings = lib.mkIf (cfg.provider == "glm")
      (jsonMerge.mkActivation {
        entries = [
          {
            path = settingsPath;
            patch = {
              kind = "cmd";
              value = glmSettingsPatch.renderCmd;
            };
          }
          {
            path = rootPath;
            patch = {
              kind = "path";
              value = glmRoot;
            };
          }
        ];
      });
  };
}
