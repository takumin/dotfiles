#!/usr/bin/env bash

set -euo pipefail

if [[ ! -x "$(command -v brew)" ]]; then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
