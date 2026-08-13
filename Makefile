.PHONY: install uninstall check-deps help

.DEFAULT_GOAL := help

help: ## Muestra este mensaje de ayuda
	@echo "Uso: make [target]"
	@echo ""
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

check-deps: ## Verifica las dependencias requeridas (jq)
	@command -v jq >/dev/null 2>&1 || (echo "[!] Error: 'jq' no está instalado. Instálalo con tu gestor de paquetes." && exit 1)
	@echo "[✔] Dependencia 'jq' detectada."

install: check-deps ## Asigna permisos y ejecuta la instalación
	@chmod +x install.sh uninstall.sh bin/agy-launch
	@./install.sh

uninstall: ## Ejecuta el desinstalador seguro
	@chmod +x uninstall.sh
	@./uninstall.sh