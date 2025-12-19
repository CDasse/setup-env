#!/bin/bash
set -euo pipefail

# --- Fonctions utilitaires ---
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m" # reset couleur

ok()   { echo -e "${GREEN}[OK]${NC} $*"; }
err()  { echo -e "${RED}[ERREUR]${NC} $*"; exit 1; }
info() { echo "[INFO] $*"; }

# Vérifie la présence d’une commande
has() { command -v "$1" >/dev/null 2>&1; }

# --- SDKMan ---
if ! has sdk; then
    curl -s "https://get.sdkman.io" | bash
    ok "SDKMan installé"
else
    "SDKman déjà présent."
fi

# --- JDK ---
if ! has java -version >/dev/null 2>&1; then
    sdk install java 25.0.1-tem
    ok "JDK 25 Temurin installé."
else
    ok "JDK déjà présent ($(java -version 2>&1 | head -n1))."
fi

# --- IntelliJ IDEA ---
if ! has intellij-idea-ultimate; then
    brew install --cask intellij-idea || err "Échec installation IntelliJ IDEA"
    ok "Intellij Ultimate installé."
else
    ok "Intellij Ultimate déjà présent."
fi

# --- SceneBuilder for JavaFX ---
if ! has scenebuilder; then
    brew install scenebuilder
    ok "Scenebuilder installé"
else
    ok "Scenebuilder déjà présent."
fi

ok "✅ Installation terminée avec succès."
exit 0