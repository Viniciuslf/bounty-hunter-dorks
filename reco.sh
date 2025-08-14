#!/bin/bash

# ===== CONFIGURAÇÕES =====
DOMAIN=$1
if [ -z "$DOMAIN" ]; then
    echo "Uso: $0 dominio.com"
    exit 1
fi

DATE=$(date +"%Y-%m-%d")
OUTPUT_DIR="recon-${DOMAIN}-${DATE}"
mkdir -p $OUTPUT_DIR/{subs,urls,screenshots,js,params,logs}

echo "[+] Iniciando Recon para $DOMAIN"
echo "[+] Resultados em: $OUTPUT_DIR"

# ===== 1. ENUMERAÇÃO DE SUBDOMÍNIOS =====
echo "[+] Enumerando subdomínios..."
subfinder -d $DOMAIN -silent | tee $OUTPUT_DIR/subs/subfinder.txt
assetfinder --subs-only $DOMAIN | tee -a $OUTPUT_DIR/subs/assetfinder.txt
cat $OUTPUT_DIR/subs/*.txt | sort -u > $OUTPUT_DIR/subs/all_subs.txt

# ===== 2. CHECANDO SUBDOMÍNIOS ATIVOS =====
echo "[+] Verificando subdomínios ativos..."
httprobe -c 50 < $OUTPUT_DIR/subs/all_subs.txt | sort -u > $OUTPUT_DIR/subs/alive.txt

# ===== 3. COLETANDO URLs =====
echo "[+] Coletando URLs..."
waybackurls $DOMAIN > $OUTPUT_DIR/urls/wayback.txt
gau $DOMAIN > $OUTPUT_DIR/urls/gau.txt
cat $OUTPUT_DIR/urls/*.txt | sort -u > $OUTPUT_DIR/urls/all_urls.txt

# ===== 4. FILTRANDO PARÂMETROS =====
echo "[+] Filtrando URLs com parâmetros..."
grep "=" $OUTPUT_DIR/urls/all_urls.txt | qsreplace -a > $OUTPUT_DIR/params/params.txt

# ===== 5. EXTRAINDO JS =====
echo "[+] Extraindo arquivos JS..."
grep "\.js" $OUTPUT_DIR/urls/all_urls.txt | sort -u > $OUTPUT_DIR/js/jsfiles.txt

# ===== 6. SCREENSHOT =====
echo "[+] Tirando screenshots..."
gowitness file -f $OUTPUT_DIR/subs/alive.txt -P $OUTPUT_DIR/screenshots/ --no-http

# ===== 7. LOG FINAL =====
echo "[+] Recon finalizado!"
echo "[+] Subdomínios encontrados: $(wc -l < $OUTPUT_DIR/subs/all_subs.txt)"
echo "[+] Subdomínios ativos: $(wc -l < $OUTPUT_DIR/subs/alive.txt)"
echo "[+] URLs coletadas: $(wc -l < $OUTPUT_DIR/urls/all_urls.txt)"
echo "[+] URLs com parâmetros: $(wc -l < $OUTPUT_DIR/params/params.txt)"
echo "[+] Arquivos JS: $(wc -l < $OUTPUT_DIR/js/jsfiles.txt)"
