#!/usr/bin/env bash

set -euxo pipefail

git pull origin main
git push gh main
