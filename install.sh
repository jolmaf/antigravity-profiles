#!/usr/bin/env bash

set -e

REPO_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

TARGET_CONFIG_DIR="$HOME/.config/agy-profiles"
TARGET_BIN_DIR="$HOME/.local/bin"
ZSHRC="$HOME/.zshrc"

echo "=== Instalando entorno multi-cuenta agy-launch ==="

# 1. Crear directorios de destino
mkdir -p "$TARGET_CONFIG_DIR"
mkdir -p "$TARGET_BIN_DIR"

# 2. Copiar plantilla de configuración si no existe un profiles.json previo
if [ ! -f "$TARGET_CONFIG_DIR/profiles.json" ]; then
    echo "[+] Creando $TARGET_CONFIG_DIR/profiles.json desde la plantilla..."
    cp "$REPO_DIR/config/profiles.json.example" "$TARGET_CONFIG_DIR/profiles.json"
else
    echo "[i] $TARGET_CONFIG_DIR/profiles.json ya existe. Se mantendrá tu configuración actual."
fi

# 3. Asignar permisos y crear enlace simbólico del ejecutable
echo "[+] Asignando permisos de ejecución a agy-launch..."
chmod +x "$REPO_DIR/bin/agy-launch"

echo "[+] Creando enlace simbólico en $TARGET_BIN_DIR/agy-launch..."
ln -sf "$REPO_DIR/bin/agy-launch" "$TARGET_BIN_DIR/agy-launch"

# 4. Verificación de dependencia jq
echo "--------------------------------------------------"
if ! command -v jq &> /dev/null; then
    echo "[!] Advertencia: 'jq' no está instalado."
    echo "    Instálalo usando tu gestor de paquetes (ej: sudo apt install jq / brew install jq)."
else
    echo "[✔] Dependencia 'jq' detectada correctamente."
fi

# 5. Configurar PATH en ~/.zshrc si no está presente
if [[ ":$PATH:" != *":$TARGET_BIN_DIR:"* ]]; then
    echo "[!] $TARGET_BIN_DIR no está en el PATH de la sesión activa."

    if [ -f "$ZSHRC" ]; then
        if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$ZSHRC"; then
            echo "[+] Añadiendo $TARGET_BIN_DIR al PATH en $ZSHRC..."
            echo '' >> "$ZSHRC"
            echo '# Añadido por instalador agy-launch' >> "$ZSHRC"
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$ZSHRC"
            echo "[✔] PATH actualizado en $ZSHRC."
        else
            echo "[i] La entrada del PATH ya existe en $ZSHRC."
        fi
    else
        echo "[!] No se encontró el archivo $ZSHRC."
    fi
else
    echo "[✔] $TARGET_BIN_DIR ya se encuentra presente en tu PATH."
fi

echo ""
echo "✔ Instalación completada. Ejecuta 'source ~/.zshrc' o abre una nueva terminal para empezar a usar 'agy-launch'."