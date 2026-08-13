#!/usr/bin/env bash

set -e

TARGET_CONFIG_DIR="$HOME/.config/agy-profiles"
TARGET_BIN_LINK="$HOME/.local/bin/agy-launch"
PROFILES_DATA_DIR="$HOME/.gemini-profiles"
ZSHRC="$HOME/.zshrc"

echo "=== Desinstalador de agy-launch ==="
echo ""

# 1. Eliminar estrictamente el enlace simbólico del ejecutable
if [ -L "$TARGET_BIN_LINK" ] || [ -f "$TARGET_BIN_LINK" ]; then
    echo "[+] Removiendo el binario $TARGET_BIN_LINK..."
    rm -f "$TARGET_BIN_LINK"
    echo "[✔] Binario eliminado."
else
    echo "[i] No se encontró el binario en $TARGET_BIN_LINK."
fi

# 2. Confirmación para la configuración de perfiles
if [ -d "$TARGET_CONFIG_DIR" ]; then
    echo ""
    read -p "¿Deseas eliminar el archivo de perfiles (~/.config/agy-profiles)? [s/N]: " RESP_CFG
    if [[ "$RESP_CFG" =~ ^[sS]$ ]]; then
        rm -rf "$TARGET_CONFIG_DIR"
        echo "[✔] Configuración de perfiles eliminada."
    else
        echo "[i] Se conservó la carpeta $TARGET_CONFIG_DIR."
    fi
fi

# 3. Confirmación previa para las credenciales guardadas de Google
if [ -d "$PROFILES_DATA_DIR" ]; then
    echo ""
    echo "----------------------------------------------------------------------"
    echo "ATENCIÓN: Tus tokens de sesión de Google e historiales están en:"
    echo "          $PROFILES_DATA_DIR"
    echo "----------------------------------------------------------------------"
    read -p "¿Deseas ELIMINAR permanentemente las credenciales de las cuentas? [s/N]: " RESP_DATA
    if [[ "$RESP_DATA" =~ ^[sS]$ ]]; then
        rm -rf "$PROFILES_DATA_DIR"
        echo "[✔] Datos de sesión eliminados."
    else
        echo "[i] Se conservaron las credenciales en $PROFILES_DATA_DIR."
    fi
fi

# 4. Limpieza del PATH en ~/.zshrc
if [ -f "$ZSHRC" ] && grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$ZSHRC"; then
    echo ""
    read -p "¿Deseas remover la línea de export PATH agregada en ~/.zshrc? [s/N]: " RESP_ZSH
    if [[ "$RESP_ZSH" =~ ^[sS]$ ]]; then
        sed -i '/# Añadido por instalador agy-launch/d' "$ZSHRC"
        sed -i '\|export PATH="$HOME/.local/bin:$PATH"|d' "$ZSHRC"
        echo "[✔] PATH removido de $ZSHRC."
    fi
fi

echo ""
echo "✔ Desinstalación completada de forma segura."