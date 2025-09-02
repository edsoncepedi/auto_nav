#!/bin/bash
set -e

echo "=== 🚀 Instalador do modo Kiosk ==="

# --- CONFIGURAÇÕES INTERATIVAS ---
read -p "Informe a URL que deve abrir no Chromium: " KIOSK_URL
read -p "Informe o tempo de espera (em segundos) antes de abrir o navegador [default: 15]: " WAIT_TIME
WAIT_TIME=${WAIT_TIME:-15}

echo ""
echo "=== Resumo das configurações ==="
echo "URL: $KIOSK_URL"
echo "Usuário: $SUDO_USER"
echo "Tempo de espera: $WAIT_TIME segundos"
echo ""

# --- GRAVANDO VARIÁVEL DE AMBIENTE ---
echo "" >> ~/.profile
echo "export URL=\"$URL\"" >> ~/.profile

read -p "Confirmar e continuar? (s/n): " CONFIRM
if [[ "$CONFIRM" != "s" && "$CONFIRM" != "S" ]]; then
    echo "❌ Instalação cancelada."
    exit 1
fi

# --- RECONFIGURA SISTEMA ---
echo "=== Reconfigurando pacotes quebrados ==="
dpkg --configure -a

echo "=== Atualizando sistema ==="
apt update && apt upgrade -y

echo "=== Instalando dependências ==="
apt install -y chromium-browser xdotool wmctrl

chmod +x /$PWD/start-browser.sh

# --- CRIA SERVIÇO SYSTEMD ---
echo "=== Criando serviço systemd ==="
cat << EOF > /usr/lib/systemd/system/auto_nav.service
[Unit]
Description=Inicia o navegador automaticamente em modo kiosk
After=network.target graphical.target
Requires=graphical.target

[Service]
User=$SUDO_USER
Environment=XDG_RUNTIME_DIR=/run/user/1000
Environment=DISPLAY=:0

ExecStartPre=/bin/sleep $WAIT_TIME
ExecStart=/$PWD/start-browser.sh

Restart=always

[Install]
WantedBy=graphical.target
EOF

# --- HABILITA SERVIÇO ---
echo "=== Recarregando systemd e habilitando serviço ==="
systemctl daemon-reload
systemctl enable auto_nav.service
systemctl restart auto_nav.service

echo "✅ Instalação concluída!"
echo "O navegador abrirá em modo kiosk com a URL: $KIOSK_URL"
