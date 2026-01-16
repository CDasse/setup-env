#!/bin/bash
set -euo pipefail

# --- Fonctions utilitaires ---
GREEN="\033[0;32m"
RED="\033[0;31m"
NC="\033[0m" # reset couleur

ok() {
    echo -e "${GREEN}[OK]${NC} $*";
}

err() {
    echo -e "${RED}[ERREUR]${NC} $*";
    exit 1
}

info() {
    echo "[INFO] $*";
}

# Vérifie la présence d’une commande
has() {
    command -v "$1" >/dev/null 2>&1;
}

# --- Mise à jour des paquets ---
info "Mise à jour des paquets système..."
sudo apt update && sudo apt upgrade -y || err "Échec de la mise à jour des paquets"
ok "Paquets système mis à jour."

# --- Git et GitHub Desktop ---
if ! has git; then
    info "Installation de Git..."
    sudo apt install git -y || err "Échec installation Git"
    ok "Git installé."
else
    ok "Git déjà présent."
fi

# GitHub Desktop n'est pas disponible nativement sur Linux, on propose une alternative
if ! has github-desktop; then
    info "GitHub Desktop n'est pas disponible nativement sur Linux. Vous pouvez utiliser l'interface web ou des alternatives comme 'GitKraken' ou 'GitFiend'."
    ok "Alternative suggérée pour GitHub Desktop."
else
    ok "GitHub Desktop déjà présent (alternative)."
fi

# --- VS Code ---
if ! has code; then
    info "Installation de VS Code..."
    sudo apt install wget gpg -y
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -D -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/packages.microsoft.gpg
    sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install code -y || err "Échec installation VS Code"
    ok "VS Code installé."
    code --install-extension ms-vscode.cpptools || err "Échec installation extension C/C++"
    ok "Extension C/C++ pour VS Code installée."
else
    ok "VS Code déjà présent."
fi

# --- GCC ---
if ! has gcc; then
    info "Installation de GCC..."
    sudo apt install build-essential -y || err "Échec installation GCC"
    ok "GCC installé."
else
    ok "GCC déjà présent ($(gcc --version | head -n1))."
fi

# --- Docker ---
if ! has docker; then
    info "Installation de Docker..."
    sudo apt install docker.io -y || err "Échec installation Docker"
    sudo systemctl enable --now docker
    ok "Docker installé."
    sudo usermod -aG docker $USER || err "Échec ajout de l'utilisateur au groupe Docker"
    ok "Utilisateur ajouté au groupe Docker."
    info "Redémarrez votre session pour appliquer les changements."
else
    ok "Docker déjà présent."
fi

# Test rapide avec une image PHP
if ! docker ps -a --format '{{.Names}}' | grep -q '^php-container$'; then
    info "Test lancement conteneur PHP..."
    docker run -d --name php-container -p 8080:80 php:latest || err "Échec lancement conteneur PHP"
    ok "Conteneur PHP démarré."
    docker stop php-container >/null
    docker rm php-container >/null
    ok "Conteneur PHP arrêté et supprimé."
else
    ok "Conteneur PHP déjà créé (test sauté)."
fi

# --- PhpStorm ---
if ! has phpstorm; then
    info "Installation de PhpStorm via Snap..."
    sudo snap install phpstorm --classic || err "Échec installation PhpStorm"
    ok "PhpStorm installé."
else
    ok "PhpStorm déjà présent."
fi

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

# --- IntelliJ IDEA ---
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
    sudo apt install scenebuilder -y || err "Échec installation SceneBuilder"
    ok "SceneBuilder installé."
else
    ok "SceneBuilder déjà présent."
fi

# --- Node.js ---
if ! has node; then
    info "Installation de Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install nodejs -y || err "Échec installation Node.js"
    ok "Node.js installé ($(node -v))."
else
    ok "Node.js déjà présent ($(node -v))."
fi

ok "✅ Installation terminée avec succès."
exit 0
