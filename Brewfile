# vim: set ft=ruby :

# Tap
tap "bufbuild/buf"
tap "fujiwara/tap"
tap "hashicorp/tap"
tap "k1low/tap"
tap "kayac/tap"
tap "lintnet/lintnet"
tap "oven-sh/bun"
tap "reviewdog/tap"
tap "suzuki-shunsuke/ci-info"
tap "suzuki-shunsuke/cmdx"
tap "suzuki-shunsuke/ghalint"
tap "suzuki-shunsuke/pinact"

# Shell & Terminal
brew "bash"
brew "bash-completion@2"
brew "mosh"
brew "sheldon"
brew "starship"
brew "tmux"
brew "tpm"
brew "zellij"
brew "zsh"
brew "zsh-completions"

# Core Utilities
brew "coreutils"
brew "curl"
brew "diffutils"
brew "findutils"
brew "gawk"
brew "gnu-sed"
brew "jq"
brew "less"
brew "lesspipe"
brew "make"
brew "openssh"

# File & Search
brew "aria2"
brew "bat"
brew "eza"
brew "fd"
brew "fzf"
brew "rclone"
brew "ripgrep"
brew "zoxide"

# System Tools
brew "bottom"
brew "fastfetch"
brew "hyperfine"
brew "killport"
brew "lnav"
brew "procs"
brew "pueue"
brew "vivid"

# Git & VCS
brew "aicommits"
brew "cocogitto"
brew "gh"
brew "ghq"
brew "git"
brew "git-cliff"
brew "git-delta"
brew "gitleaks"
brew "glab"
brew "lazygit"
brew "lefthook"
brew "pre-commit"

# Editor
brew "editorconfig-checker"
brew "neovim"
brew "tree-sitter-cli"

# Go
brew "go"
brew "gofumpt"
brew "goimports"
brew "golangci-lint"
brew "gopls"
brew "goreleaser"
brew "gosec"
brew "govulncheck"
brew "staticcheck"

# Rust
brew "cargo-llvm-cov"
brew "cargo-zigbuild"
brew "rust-analyzer"
brew "rustup-init"

# JavaScript / TypeScript
brew "biome"
brew "deno"
brew "marp-cli"
brew "oxlint"
brew "pnpm"
brew "prettier"
brew "prettierd"
brew "typescript-language-server"
brew "yarn"
brew "yarn-completion"
brew "oven-sh/bun/bun"

# Python
brew "ruff"
brew "uv"

# Ruby
brew "bundler-completion"
brew "ruby"
brew "ruby-completion"
brew "ruby-lsp"

# Lua
brew "lua"
brew "lua-language-server"
brew "luarocks"
brew "stylua"

# Zig
brew "zig"

# C / C++ Build Tools
brew "bear"
brew "ccache"
brew "cmake"
brew "lld"
brew "llvm"
brew "meson"
brew "mold"
brew "ninja"
brew "sccache"

# Protocol Buffers
brew "protobuf"
brew "protoc-gen-go"
brew "protoc-gen-go-grpc"
brew "protoc-gen-grpc-web"
brew "protoc-gen-js"
brew "bufbuild/buf/buf"

# Linters & Formatters (General)
brew "bash-language-server"
brew "dockerfmt"
brew "hadolint"
brew "shellcheck"
brew "shfmt"
brew "taplo"
brew "vscode-langservers-extracted"
brew "yamlfmt"
brew "yamllint"
brew "yaml-language-server"

# Container & Virtualization
brew "docker"
brew "docker-buildx"
brew "docker-compose"
brew "docker-credential-helper"
brew "oras"

# Cloud & Infrastructure
brew "aws-nuke"
brew "aws-vault"
brew "awscli"
brew "cloudflare-wrangler"
brew "cntb"
brew "hcl2json"
brew "helm"
brew "kubernetes-cli"
brew "tenv"
brew "fujiwara/tap/lambroll"
brew "hashicorp/tap/packer"
brew "hashicorp/tap/terraform-ls"
brew "kayac/tap/ecspresso"

# CI/CD & Automation
brew "aqua"
brew "act"
brew "actionlint"
brew "dagger"
brew "go-task"
brew "melange"
brew "nfpm"
brew "wrkflw"
brew "zizmor"
brew "k1low/tap/octocov"
brew "k1low/tap/runn"
brew "lintnet/lintnet/lintnet"
brew "reviewdog/tap/reviewdog"
brew "suzuki-shunsuke/ci-info/ci-info"
brew "suzuki-shunsuke/cmdx/cmdx"
brew "suzuki-shunsuke/ghalint/ghalint"
brew "suzuki-shunsuke/pinact/pinact"

# Security & Signing
brew "age"
brew "cosign"
brew "rekor-cli"
brew "slsa-verifier"
brew "sops"
brew "step"
brew "trivy"

# Misc
brew "aptly"
brew "caddy"
brew "devcontainer"
brew "direnv"
brew "glider"
brew "hugo"
brew "mise"
brew "renovate"

# Cask (cross-platform)
cask "claude-code"
cask "codex"

if OS.linux?
  # Linux
  brew "nerdctl"
end

if OS.mac?
  # macOS Formulae
  brew "lima"
  brew "mas"
  brew "mactop" if Hardware::CPU.arm?
  brew "pam-reattach"

  # macOS Cask
  cask "1password"
  cask "1password-cli"
  cask "alacritty"
  cask "chatgpt"
  cask "claude"
  cask "codex-app"
  cask "discord"
  cask "firefox"
  cask "font-symbols-only-nerd-font"
  cask "google-chrome"
  cask "google-japanese-ime"
  cask "jetbrains-toolbox"
  cask "obsidian"
  cask "session-manager-plugin"
  cask "slack"
  cask "utm"
  cask "visual-studio-code"
  cask "zoom"

  # macOS App Store
  mas "Tailscale", id: 1475387142
  mas "1Password for Safari", id: 1569813296
  mas "Windows App", id: 1295203466
  mas "Xcode", id: 497799835
end
