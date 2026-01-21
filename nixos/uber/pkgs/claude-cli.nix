{ pkgs ? import <nixpkgs> {} }:

let
  sanitize = text: builtins.replaceStrings ["\r"] [""] text;

  # Create a wrapper script that ensures user-local installation
  claudeCodeWrapper = pkgs.writeShellScriptBin "claude" (sanitize ''
    claude_code_home="''${XDG_DATA_HOME:-$HOME/.local/share}/claude-code"
    claude_code_bin="$HOME/.local/bin"

    # Ensure directories exist
    mkdir -p "$claude_code_home"
    mkdir -p "$claude_code_bin"

    # Set npm prefix to user directory to avoid permission issues
    export NPM_CONFIG_PREFIX="$claude_code_home/npm"
    export PATH="$claude_code_home/npm/bin:$PATH"

    # Check if claude-code is installed in user directory
    if [ ! -x "$claude_code_home/npm/bin/claude" ]; then
      echo "Installing claude-code to user directory..."
      ${pkgs.nodejs_20}/bin/npm install -g @anthropic-ai/claude-code
    fi

    # Execute claude-code with all arguments
    exec "$claude_code_home/npm/bin/claude" "$@"
  '');

in pkgs.stdenv.mkDerivation {
  pname = "claude-code-user";
  version = "latest";
  
  # No source needed, we're creating a wrapper
  dontUnpack = true;
  
  buildInputs = with pkgs; [
    nodejs_20
    git
    ripgrep
  ];
  
  installPhase = sanitize ''
    mkdir -p $out/bin
    cp ${claudeCodeWrapper}/bin/claude $out/bin/claude

    # Create update script
    cat > $out/bin/claude-update << 'EOF'
    #!/usr/bin/env bash
    claude_code_home="''${XDG_DATA_HOME:-$HOME/.local/share}/claude-code"
    export NPM_CONFIG_PREFIX="$claude_code_home/npm"
    echo "Updating claude-code..."
    ${pkgs.nodejs_20}/bin/npm update -g @anthropic-ai/claude-code
    echo "Update complete!"
    EOF
    chmod +x $out/bin/claude-update
  '';
  
  meta = with pkgs.lib; {
    description = "Claude Code - User-local installation wrapper";
    homepage = "https://www.anthropic.com/claude-code";
    license = licenses.unfree;
    platforms = platforms.unix;
    maintainers = [];
  };
}
