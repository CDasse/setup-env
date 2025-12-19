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
    info "Installation de SDKMan..."
    curl -s "https://get.sdkman.io" | bash || err "Échec installation SDKMan"
    source "$HOME/.sdkman/bin/sdkman-init.sh"
    ok "SDKMan installé."
else
    ok "SDKMan déjà présent."
fi

# --- JDK ---
if ! has java; then
    info "Installation du JDK 25 Temurin..."
    sdk install java 25.0.1-tem || err "Échec installation JDK"
    ok "JDK 25 Temurin installé."
else
    ok "JDK déjà présent ($(java -version 2>&1 | head -n1))."
fi

# --- IntelliJ IDEA Ultimate ---
if ! has idea; then
    info "Installation d'IntelliJ IDEA Ultimate via Snap..."
    sudo snap install intellij-idea-ultimate --classic || err "Échec installation IntelliJ IDEA"
    ok "IntelliJ IDEA Ultimate installé."
else
    ok "IntelliJ IDEA Ultimate déjà présent."
fi

# --- SceneBuilder pour JavaFX ---
if ! has scenebuilder; then
    info "Installation de SceneBuilder..."
    sudo apt update
    sudo apt install scenebuilder -y || err "Échec installation SceneBuilder"
    ok "SceneBuilder installé."
else
    ok "SceneBuilder déjà présent."
fi

ok "✅ Installation terminée avec succès."
exit 0
