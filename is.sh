#!/bin/bash
echo "[+] Instalando ferramentas de Recon para Bug Bounty..."

sudo apt update && sudo apt install -y golang

# Criando pasta para ferramentas
mkdir -p ~/tools && cd ~/tools

# subfinder
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# assetfinder
go install github.com/tomnomnom/assetfinder@latest

# httprobe
go install github.com/tomnomnom/httprobe@latest

# waybackurls
go install github.com/tomnomnom/waybackurls@latest

# gau
go install github.com/lc/gau/v2/cmd/gau@latest

# qsreplace
go install github.com/tomnomnom/qsreplace@latest

# gowitness
go install github.com/sensepost/gowitness@latest

echo "[+] Ferramentas instaladas! Adicione o Go bin ao PATH:"
echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc
source ~/.bashrc
