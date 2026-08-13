# Antigravity CLI Multi-Account Launcher (`agy-launch`)

Gestor de sesiones en paralelo con cuentas de Google independientes para Antigravity CLI.

## Requisitos
- `jq` instalado (`sudo apt install jq` o `brew install jq`).

## Instalación rápida
```bash
chmod +x bin/agy-launch install.sh uninstall.sh
make install
source ~/.zshrc
```

## Uso
- Para ver los perfiles disponibles:
```bash
agy-launch
```

- Para iniciar una sesión con un perfil específico:
```bash
agy-launch jolmaf
# O en otra ventana:
agy-launch maxwell
```

- Desinstalación
```Bash
make uninstall
```