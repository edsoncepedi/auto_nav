# 🚀 Raspberry Pi Kiosk Setup

Este repositório contém um script para configurar automaticamente o Raspberry Pi em **modo kiosk**, abrindo o navegador Chromium em tela cheia com a URL desejada. O script instala dependências, cria um **serviço systemd** e garante que o navegador seja iniciado automaticamente após o boot do sistema.

---

## ⚡ Dependências

O script instala automaticamente os pacotes necessários:

* `chromium-browser`
* `xdotool`

---

## 🖥️ Como usar

### 1. Clone o repositório no Raspberry Pi

```bash
git clone https://github.com/edsoncepedi/auto_nav.git
cd auto_nav
```

### 2. Torne o script executável

Antes de executar o script, é necessário torná-lo executável:

```bash
chmod +x setup_auto_nav.sh
```

### 3. Execute o instalador

É recomendado executar o script via terminal SSH (por exemplo, usando Putty), pois o acesso direto pela interface gráfica ou pelo RealVNC pode causar erros, já que o servidor VNC assume o controle da interface X11.

```bash
sudo ./setup_auto_nav.sh
```

### 4. Informe os parâmetros solicitados

Durante a execução, o script solicitará:

* **URL** a ser aberta (veja lista de possibilidades abaixo)
* **Usuário** que rodará o serviço (padrão: `cepedi`)
* **Tempo de espera** antes de iniciar o navegador (padrão: `15s`)

Após a instalação, o Raspberry Pi iniciará o navegador **automaticamente em modo kiosk** a cada boot.

---

## 🔗 Possíveis URLs

A estrutura de URL utilizada é:

```
http://172.16.10.175/{sistema}
```

Onde `{sistema}` pode ser um dos seguintes módulos:

* `associacao`
* `bios`
* `runin`
* `teste`
* `retrabalho`
* `embalagem`
* `controle`

### Exemplos

* `http://172.16.10.175/associacao`
* `http://172.16.10.175/bios`
* `http://172.16.10.175/runin`
* `http://172.16.10.175/teste`
* `http://172.16.10.175/retrabalho`
* `http://172.16.10.175/embalagem`
* `http://172.16.10.175/controle`

---

## 🛠️ Personalização

Após a instalação, você pode alterar manualmente as configurações do serviço:

```bash
sudo nano /etc/systemd/system/auto_nav.service
```

Para mudar a URL padrão, edite o script em:

```bash
sudo nano /usr/local/bin/start-browser.sh
```

Depois de qualquer modificação, recarregue o systemd:

```bash
sudo systemctl daemon-reload
sudo systemctl restart auto_nav.service
```

---

## 📌 Gerenciamento do serviço

* **Verificar status:**

```bash
systemctl status auto_nav.service
```

* **Reiniciar:**

```bash
sudo systemctl restart auto_nav.service
```

* **Parar:**

```bash
sudo systemctl stop auto_nav.service
```

* **Desabilitar no boot:**

```bash
sudo systemctl disable auto_nav.service
```

* **Reabilitar no boot:**

```bash
sudo systemctl enable auto_nav.service
```

---

## 🗑️ Desinstalação

Para remover tudo que foi instalado pelo script:

1. **Remover o serviço:**

```bash
sudo systemctl stop auto_nav.service
sudo systemctl disable auto_nav.service
sudo rm /etc/systemd/system/auto_nav.service
```

2. **Remover o script de inicialização:**

```bash
sudo rm /usr/local/bin/start-browser.sh
```

3. **Opcional: remover dependências instaladas:**

```bash
sudo apt remove --purge -y chromium-browser xdotool wmctrl
sudo apt autoremove -y
```

4. **Recarregar systemd:**

```bash
sudo systemctl daemon-reload
```

---

## 📜 Licença

Este projeto é de uso interno. Sinta-se livre para adaptar conforme a necessidade do seu ambiente.
