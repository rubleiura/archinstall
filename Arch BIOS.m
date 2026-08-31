#################################################################
# 🐧 МАКЕТ БЛОЧНОЙ УСТАНОВКИ ARCH LINUX (BIOS + GPT + BTRFS)
#################################################################
# ℹ️ Назначение: Пошаговая установка Arch Linux с BTRFS.
# 💡 Метод: Копируйте и вставляйте блоки команд по одному.
# ❗ Важно: Не запускайте как скрипт! Выполняйте вручную.
# 🌐 Требуется: Интернет, загрузочная среда Arch Linux (свежий ISO).
# 💡 Примечание: Данная установка предназначена для компьютеров
# с прошивкой BIOS (Legacy Boot), но с использованием таблицы разделов GPT.
# Требуется специальный BIOS Boot Partition (тип EF02).
#################################################################






#################################################################
# 🔍  [LIVE] БЛОК 0: ДИАГНОСТИКА ЛОКАЦИИ ЗЕРКАЛ (Mirrors)
#################################################################

clear
cat > light_countries.py << "EOF"
#!/usr/bin/env python3
import json, urllib.request, math, sys

CAPITALS = {
    "Afghanistan": (34.5553, 69.2075), "Albania": (41.3275, 19.8187), "Algeria": (36.7538, 3.0588),
    "Andorra": (42.5063, 1.5218), "Angola": (-8.8390, 13.2894), "Argentina": (-34.6037, -58.3816),
    "Armenia": (40.1792, 44.4991), "Australia": (-35.2809, 149.1300), "Austria": (48.2082, 16.3738),
    "Azerbaijan": (40.4093, 49.8671), "Bahamas": (25.0585, -77.3512), "Bahrain": (26.2285, 50.5860),
    "Bangladesh": (23.8103, 90.4125), "Barbados": (13.0969, -59.6145), "Belarus": (53.9006, 27.5590),
    "Belgium": (50.8503, 4.3517), "Belize": (17.2510, -88.7590), "Benin": (6.4969, 2.6283),
    "Bhutan": (27.4728, 89.6390), "Bolivia": (-16.5000, -68.1500), "Bosnia and Herzegovina": (43.8563, 18.4131),
    "Botswana": (-24.6282, 25.9231), "Brazil": (-15.8267, -47.9218), "Brunei": (4.9031, 114.9398),
    "Bulgaria": (42.6977, 23.3219), "Burkina Faso": (12.3686, -1.5271), "Burundi": (-3.3761, 29.3600),
    "Cambodia": (11.5621, 104.8880), "Cameroon": (3.8480, 11.5021), "Canada": (45.4215, -75.6972),
    "Cape Verde": (14.9177, -23.5092), "Central African Republic": (4.3612, 18.5550), "Chad": (12.1348, 15.0557),
    "Chile": (-33.4489, -70.6693), "China": (39.9042, 116.4074), "Colombia": (4.7110, -74.0721),
    "Comoros": (-11.7172, 43.3470), "Congo": (-4.2634, 15.2429), "Costa Rica": (9.9281, -84.0907),
    "Croatia": (45.8150, 15.9819), "Cuba": (23.1136, -82.3666), "Cyprus": (35.1856, 33.3823),
    "Czech Republic": (50.0755, 14.4378), "Denmark": (55.6761, 12.5683), "Djibouti": (11.5721, 43.1456),
    "Dominica": (15.3010, -61.3870), "Dominican Republic": (18.4861, -69.9312), "Ecuador": (-0.1807, -78.4678),
    "Egypt": (30.0444, 31.2357), "El Salvador": (13.6929, -89.2182), "Equatorial Guinea": (3.7523, 8.7371),
    "Eritrea": (15.3229, 38.9251), "Estonia": (59.4370, 24.7536), "Ethiopia": (9.0320, 38.7469),
    "Fiji": (-18.1416, 178.4419), "Finland": (60.1699, 24.9384), "France": (48.8566, 2.3522),
    "Gabon": (0.4162, 9.4673), "Gambia": (13.4549, -16.5790), "Georgia": (41.7151, 44.8271),
    "Germany": (52.5200, 13.4050), "Ghana": (5.6037, -0.1870), "Greece": (37.9838, 23.7275),
    "Grenada": (12.0561, -61.7488), "Guatemala": (14.6248, -90.5328), "Guinea": (9.5092, -13.7122),
    "Guinea-Bissau": (11.8636, -15.5989), "Guyana": (6.8013, -58.1551), "Haiti": (18.5392, -72.3350),
    "Honduras": (14.0723, -87.1921), "Hungary": (47.4979, 19.0402), "Iceland": (64.1466, -21.9426),
    "India": (28.6139, 77.2090), "Indonesia": (-6.2088, 106.8456), "Iran": (35.6892, 51.3890),
    "Iraq": (33.3128, 44.3615), "Ireland": (53.3498, -6.2603), "Israel": (31.7683, 35.2137),
    "Italy": (41.9028, 12.4964), "Jamaica": (18.0179, -76.8099), "Japan": (35.6762, 139.6503),
    "Jordan": (31.9454, 35.9284), "Kazakhstan": (51.1605, 71.4704), "Kenya": (-1.2921, 36.8219),
    "Kiribati": (1.3292, 172.9823), "Kuwait": (29.3759, 47.9774), "Kyrgyzstan": (42.8746, 74.5698),
    "Laos": (17.9689, 102.6137), "Latvia": (56.9496, 24.1052), "Lebanon": (33.8938, 35.5018),
    "Lesotho": (-29.3151, 27.4869), "Liberia": (6.3156, -10.8074), "Libya": (32.8872, 13.1913),
    "Liechtenstein": (47.1410, 9.5209), "Lithuania": (54.6872, 25.2797), "Luxembourg": (49.6116, 6.1319),
    "Madagascar": (-18.8792, 47.5079), "Malawi": (-13.9833, 33.7703), "Malaysia": (3.1390, 101.6869),
    "Maldives": (4.1755, 73.5093), "Mali": (12.6392, -8.0029), "Malta": (35.8989, 14.5146),
    "Marshall Islands": (7.1164, 171.1845), "Mauritania": (18.0735, -15.9582), "Mauritius": (-20.1609, 57.5012),
    "Mexico": (19.4326, -99.1332), "Micronesia": (6.9177, 158.1850), "Moldova": (47.0105, 28.8638),
    "Monaco": (43.7384, 7.4246), "Mongolia": (47.9077, 106.8832), "Montenegro": (42.4304, 19.2594),
    "Morocco": (34.0209, -6.8416), "Mozambique": (-25.9653, 32.5892), "Myanmar": (16.8661, 96.1951),
    "Namibia": (-22.5609, 17.0658), "Nauru": (-0.5228, 166.9315), "Nepal": (27.7172, 85.3240),
    "Netherlands": (52.3702, 4.8952), "New Zealand": (-41.2865, 174.7762), "Nicaragua": (12.1150, -86.2362),
    "Niger": (13.5127, 2.1128), "Nigeria": (9.0765, 7.3986), "North Korea": (39.0392, 125.7625),
    "North Macedonia": (41.9973, 21.4280), "Norway": (59.9139, 10.7522), "Oman": (23.5880, 58.3829),
    "Pakistan": (33.6844, 73.0479), "Palau": (7.3419, 134.4789), "Panama": (8.9824, -79.5199),
    "Papua New Guinea": (-9.4431, 147.1803), "Paraguay": (-25.2637, -57.5759), "Peru": (-12.0464, -77.0428),
    "Philippines": (14.5995, 120.9842), "Poland": (52.2297, 21.0122), "Portugal": (38.7223, -9.1393),
    "Qatar": (25.2854, 51.5310), "Romania": (44.4268, 26.1025), "Russia": (55.7558, 37.6173),
    "Rwanda": (-1.9403, 29.8739), "Saint Kitts and Nevis": (17.3578, -62.7830), "Saint Lucia": (14.0101, -60.9875),
    "Saint Vincent and the Grenadines": (13.1579, -61.2248), "Samoa": (-13.8333, -171.7667),
    "San Marino": (43.9424, 12.4578), "Sao Tome and Principe": (0.3302, 6.7333), "Saudi Arabia": (24.7136, 46.6753),
    "Senegal": (14.7167, -17.4677), "Serbia": (44.7866, 20.4489), "Seychelles": (-4.6796, 55.4920),
    "Sierra Leone": (8.4606, -13.2317), "Singapore": (1.3521, 103.8198), "Slovakia": (48.1486, 17.1077),
    "Slovenia": (46.0569, 14.5058), "Solomon Islands": (-9.4456, 159.9729), "Somalia": (2.0469, 45.3182),
    "South Africa": (-25.7479, 28.2293), "South Korea": (37.5665, 126.9780), "South Sudan": (4.8594, 31.5713),
    "Spain": (40.4168, -3.7038), "Sri Lanka": (6.9271, 79.8612), "Sudan": (15.5007, 32.5599),
    "Suriname": (5.8520, -55.2038), "Sweden": (59.3293, 18.0686), "Switzerland": (46.9480, 7.4474),
    "Syria": (33.5138, 36.2765), "Taiwan": (25.0330, 121.5654), "Tajikistan": (38.5598, 68.7870),
    "Tanzania": (-6.7924, 39.2083), "Thailand": (13.7563, 100.5018), "Timor-Leste": (-8.5569, 125.5603),
    "Togo": (6.1256, 1.2246), "Tonga": (-21.1789, -175.1982), "Trinidad and Tobago": (10.6596, -61.5089),
    "Tunisia": (36.8065, 10.1815), "Turkey": (39.9334, 32.8597), "Turkmenistan": (37.9601, 58.3261),
    "Tuvalu": (-8.5167, 179.2167), "Uganda": (0.3476, 32.5825), "Ukraine": (50.4501, 30.5234),
    "United Arab Emirates": (24.4539, 54.3773), "United Kingdom": (51.5074, -0.1278),
    "United States": (38.9072, -77.0369), "Uruguay": (-34.9011, -56.1645), "Uzbekistan": (41.2995, 69.2401),
    "Vanuatu": (-17.7333, 168.3273), "Vatican City": (41.9029, 12.4534), "Venezuela": (10.4806, -66.9036),
    "Vietnam": (21.0285, 105.8542), "Yemen": (15.3694, 44.1910), "Zambia": (-15.3875, 28.3228),
    "Zimbabwe": (-17.8252, 31.0335)
}

def haversine(lat1, lon1, lat2, lon2):
    R = 6371.0
    dlat = math.radians(lat2 - lat1)
    dlon = math.radians(lon2 - lon1)
    a = math.sin(dlat/2)**2 + math.cos(math.radians(lat1)) * math.cos(math.radians(lat2)) * math.sin(dlon/2)**2
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1-a))

def get_ip_location():
    apis = [
        ("https://ipapi.co/json/", "ipapi.co"),
        ("https://ipinfo.io/json", "ipinfo.io"),
    ]
    for api_url, api_name in apis:
        try:
            print(f"  🔄 Пробуем {api_name}...")
            with urllib.request.urlopen(api_url, timeout=5) as resp:
                data = json.loads(resp.read().decode())

                # ✅ ИСПРАВЛЕНО: Добавлена переменная data в условия
                if api_name == "ipapi.co":
                    if "error" in data:
                        continue
                    if "latitude" not in data or "longitude" not in data:
                        continue
                    lat = float(data.get("latitude", 0))
                    lon = float(data.get("longitude", 0))
                    country = data.get("country_name", "Unknown")

                elif api_name == "ipinfo.io":
                    if "bogon" in data:
                        continue
                    if "loc" not in data:
                        continue
                    loc = data.get("loc", "0,0").split(",")
                    lat = float(loc[0])
                    lon = float(loc[1])
                    country = data.get("country", "Unknown")
                else:
                    continue

                if lat != 0 and lon != 0:
                    print(f"  ✅ Использован API: {api_name}")
                    return lat, lon, country

        except Exception as e:
            print(f"  ⚠️ {api_name} недоступен: {e}")
            continue

    print("❌ Все API недоступны. Проверьте подключение к интернету.")
    sys.exit(1)

def main():
    print("🌐 Определение местоположения по IP...")
    my_lat, my_lon, my_country = get_ip_location()
    print(f"✅ Вы находитесь: {my_country} ({my_lat:.4f}, {my_lon:.4f})\n")

    distances = []
    for country, (cap_lat, cap_lon) in CAPITALS.items():
        if country == my_country:
            continue
        dist = haversine(my_lat, my_lon, cap_lat, cap_lon)
        distances.append((country, dist))

    distances.sort(key=lambda x: x[1])

    print(f"{"#":<3} {"Страна":<25} {"Расстояние (км)":<10}")
    print("-" * 45)
    for i, (country, dist) in enumerate(distances[:10], 1):
        print(f"{i:<3} {country:<25} {dist:.0f}")
    print("-" * 45)
    print("✅ Готово! Используйте список выше для настройки.")

if __name__ == "__main__":
    main()
EOF
clear
echo "  "
echo "  "
python light_countries.py
rm -f ~/light_countries.py
echo "  "
echo "################################################################# "
echo "## 🧭 10 БЛИЖАЙШИХ СТРАН ОПРЕДЕЛЕНЫ                             ## "
echo "################################################################# "
echo "  "
#################################################################






#################################################################
# 🔧  [EDIT] БЛОК 1: НАСТРОЙКА ЛОКАЦИИ ЗЕРКАЛ (Mirrors)
#################################################################

# • ПРИМЕР: Russia  > Russia,Estonia,Finland,Latvia,Lithuania,Belarus,Sweden "

#################################################################################
#
#############################################################
# Назначение                  # Значение для замены (шаблон)
#############################################################
# Местоположение пользователя # Russia
#############################################################
#
#################################################################
# ✅ ПЕРЕХОДИТЕ К БЛОКУ 2
#################################################################







#################################################################
# ⚙️ [LIVE] БЛОК 2: ПОДГОТОВКА LIVE-СРЕДЫ
#################################################################

clear
loadkeys ru
setfont cyr-sun16
timedatectl set-ntp true
sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
sed -i "s/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/" /etc/locale.gen
locale-gen
export LANG=ru_RU.UTF-8
sed -i s/"ParallelDownloads = 5"/"ParallelDownloads = 15"/g /etc/pacman.conf
sed -i s/"#Color"/"Color"/g /etc/pacman.conf
sed -i "/^Color$/a VerbosePkgLists" /etc/pacman.conf
sed -i "/^Color$/a DisableDownloadTimeout" /etc/pacman.conf
sed -i "/^Color$/a ILoveCandy" /etc/pacman.conf
timedatectl set-ntp true
echo "--country Russia" > /etc/xdg/reflector/reflector.conf
echo "--protocol https" >> /etc/xdg/reflector/reflector.conf
echo "--age 24" >> /etc/xdg/reflector/reflector.conf
echo "--sort rate" >> /etc/xdg/reflector/reflector.conf
echo "--latest 20" >> /etc/xdg/reflector/reflector.conf
echo "--connection-timeout 10" >> /etc/xdg/reflector/reflector.conf
echo "--download-timeout 10" >> /etc/xdg/reflector/reflector.conf
echo "--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf
systemctl restart reflector.service
clear
echo " "
pacman -Syy
pacman -S --noconfirm inxi
pacman -S --noconfirm lshw
clear
echo " "
echo "#####################################################"
echo "## ✅ ПОДГОТОВКА LIVE-СРЕДЫ ЗАВЕРШЕНА              ##"
echo "#####################################################"
echo " "
################################################################







#################################################################
# 🔍  [LIVE] БЛОК 3: ДИАГНОСТИКА ОБОРУДОВАНИЯ
#################################################################

clear
echo " "
echo "=== ДИАГНОСТИКА ОБОРУДОВАНИЯ ==="
echo " "
echo "Замените переменную sdx на ваш жесткий диск для разметки диска"
echo "Пример: если ваш диск /dev/sda, замените ВСЕ "sdx" на "sda" в макете."
echo " "
lsblk
echo " "
echo " "
echo "Замените или оставьте переменную amd-ucode в зависимости от типа вашего процессора"
echo "Для Intel: замените "amd-ucode" на "intel-ucode""
echo " "
echo "Производитель процессора:"
lshw -C cpu 2>/dev/null | grep "vendor:" | uniq
echo " "
echo " "
echo "Замените переменную Sony на имя вашего компьютера"
echo " "
echo "Материнская плата:"
inxi -M
echo " "
echo " "
echo "Замените переменную 4G на необходимый размер SWAP"
echo "Пример: для 8GB swap, замените "4G" на "8G""
echo " "
echo "Общая информация о системе:"
inxi -I
echo " "
echo " "
echo "=== РЕКОМЕНДУЕМЫЕ ПАРАМЕТРЫ МОНТИРОВАНИЯ FSTAB ==="
echo "Определение типа дисков (HDD/SSD) для параметров монтирования:"
{
echo;
for DEVICE in $(lsblk -dno NAME 2>/dev/null | grep -v -e "^loop" -e "^sr"); do
DEVICE_PATH="/dev/$DEVICE";
[[ ! -b "$DEVICE_PATH" ]] && continue;
ROTA=$(lsblk -d -o ROTA --noheadings "$DEVICE_PATH" 2>/dev/null | awk "{print $1}");
if [[ "$ROTA" == "1" ]]; then
DISK_TYPE="HDD (Замените "defaults" в БЛОКЕ 4 на):";
MOUNT_OPTIONS="noatime,space_cache=v2,compress=zstd:3,autodefrag";
else
DISK_TYPE="SSD (Замените "defaults" в БЛОКЕ 4 на):";
MOUNT_OPTIONS="ssd,noatime,space_cache=v2,compress=zstd:3,discard=async";
fi;
echo   "╔══════════════════════════════════════════════════════════════════════════════════╗";
printf "║  Диск: %-50s\n" "/dev/$DEVICE";
echo   "╠══════════════════════════════════════════════════════════════════════════════════╣";
printf "║  Тип: %-50s\n" "$DISK_TYPE";
printf "║  Параметры монтирования BTRFS: %-50s\n" "$MOUNT_OPTIONS";
echo   "╚══════════════════════════════════════════════════════════════════════════════════╝";
echo;
done;
}
echo " "
echo "#####################################################"
echo "## ✅ ДИАГНОСТИКА ОБОРУДОВАНИЯ ЗАВЕРШЕНА           ##"
echo "#####################################################"
echo " "
#################################################################






#################################################################
# 🔧  [EDIT] БЛОК 4: НАСТРОЙКА ПЕРЕМЕННЫХ (ОБЯЗАТЕЛЬНО!)
#################################################################

############################################################
# Назначение                 # Значение для замены (шаблон)
############################################################
# Имя диска                  # sdx
# Размер SWAP                # 4G
# Имя компьютера (HOSTNAME)  # Sony
# Имя пользователя           # forename
# Полное имя пользователя    # User Name
# Microcode                  # amd-ucode
# Ядро                       # linux-lts
# Параметры монтирования     # defaults
#############################################################
#
#################################################################
# ✅ ПЕРЕМЕННЫЕ НАСТРОЕНЫ. ПЕРЕХОДИТЕ К БЛОКУ 5
#################################################################






#################################################################
# 💾  [LIVE] БЛОК 5: РАЗМЕТКА ДИСКА (GPT + BIOS Boot)
#################################################################

clear
wipefs --all --force /dev/sdx
sgdisk -Z /dev/sdx
sgdisk -a 2048 -o /dev/sdx
sgdisk -n 1::+4M --typecode=1:ef02 --change-name=1:"BIOS Boot" /dev/sdx
sgdisk -n 2::-4G --typecode=2:8300 --change-name=2:"Root Arch Linux" /dev/sdx
sgdisk -n 3::-0 --typecode=3:8200 --change-name=3:"Swap Arch Linux" /dev/sdx
clear
echo " "
echo " 🔍 Проверка созданной разметки."
echo " "
echo " "
fdisk -l /dev/sdx
echo " "
echo " "
lsblk -a /dev/sdx
echo " "
echo "#####################################################"
echo "## ✅ РАЗМЕТКА ДИСКА (GPT + BIOS) ЗАВЕРШЕНА        ##"
echo "#####################################################"
echo " "
#################################################################







#################################################################
# 🔧  [EDIT] БЛОК 6: НАСТРОЙКА РАЗДЕЛОВ ДИСКА (ОБЯЗАТЕЛЬНО!)
#################################################################

############################################################
# Назначение                 # Значение для замены (шаблон)
############################################################
# BIOS Boot Partition        # sda1
# Root раздел                # sda2
# Swap раздел                # sda3
#############################################################
#
#################################################################
# ✅ ПЕРЕМЕННЫЕ НАСТРОЕНЫ. ПЕРЕХОДИТЕ К БЛОКУ 7
#################################################################






#################################################################
# 💾  [LIVE] БЛОК 7: ФОРМАТИРОВАНИЕ И МОНТИРОВАНИЕ
#################################################################

clear
mkswap /dev/sda3
swapon /dev/sda3
mkfs.btrfs -f /dev/sda2
mount /dev/sda2 /mnt
btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@log
btrfs subvolume create /mnt/@pkg
umount /mnt
mount -o defaults,subvol=@ /dev/sda2 /mnt
mkdir -p /mnt/{home,var/log,var/cache/pacman/pkg,var/lib/machines,var/lib/portables}
mount -o defaults,subvol=@home /dev/sda2 /mnt/home
mount -o defaults,subvol=@log /dev/sda2 /mnt/var/log
mount -o defaults,subvol=@pkg /dev/sda2 /mnt/var/cache/pacman/pkg
clear
echo " "
echo " 🔍 Проверка структуры разделов."
echo " "
lsblk -o PATH,PTTYPE,PARTTYPE,FSTYPE,PARTTYPENAME /dev/sdx
echo " "
echo " "
lsblk /dev/sdx
echo " "
echo " 📋 Список всех подтомов BTRFS."
echo " "
btrfs subvolume list /mnt
echo " "
echo "#####################################################"
echo "## ✅ ФОРМАТИРОВАНИЕ И МОНТИРОВАНИЕ ЗАВЕРШЕНО      ##"
echo "#####################################################"
echo " "
#################################################################






#################################################################
# 🧱  [LIVE] БЛОК 8: УСТАНОВКА БАЗОВЫХ ПАКЕТОВ
#################################################################

clear
pacstrap /mnt base base-devel
pacstrap /mnt amd-ucode
pacstrap /mnt memtest86+
pacstrap /mnt nano reflector
pacstrap /mnt pacman-contrib curl
pacstrap /mnt btrfs-progs
pacstrap /mnt busybox
genfstab -U /mnt >> /mnt/etc/fstab
clear
echo " "
echo "#####################################################"
echo "## ✅ УСТАНОВКА БАЗОВЫХ ПАКЕТОВ ЗАВЕРШЕНА          ##"
echo "#####################################################"
echo " "
# 🚪 Вход в chroot — переход в установленную систему
arch-chroot /mnt /bin/bash
echo " "
#################################################################






#################################################################
# 🛠️  [CHROOT] БЛОК 9: НАСТРОЙКИ ВНУТРИ СИСТЕМЫ
#################################################################

clear
sed -i "s/\S*subvol=\(\S*\)/subvol=\1,defaults/g"  /etc/fstab
sed -i "/\[multilib\]/,/Include/""s/^#//" /etc/pacman.conf
sed -i s/"ParallelDownloads = 5"/"ParallelDownloads = 15"/g /etc/pacman.conf
sed -i s/"#Color"/"Color"/g /etc/pacman.conf
sed -i "/^Color$/a VerbosePkgLists" /etc/pacman.conf
sed -i "/^Color$/a DisableDownloadTimeout" /etc/pacman.conf
sed -i "/^Color$/a ILoveCandy" /etc/pacman.conf
echo "KEYMAP=ru" > /etc/vconsole.conf
echo "FONT=cyr-sun16" >> /etc/vconsole.conf
sed -i "s/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
sed -i "s/^#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/" /etc/locale.gen
locale-gen
echo "LANG=ru_RU.UTF-8" > /etc/locale.conf
export LANG=ru_RU.UTF-8
time_zone=$(curl -s https://ipinfo.io/timezone)
ln -sf /usr/share/zoneinfo/$time_zone /etc/localtime
hwclock --systohc
echo "--country Russia" > /etc/xdg/reflector/reflector.conf
echo "--protocol https" >> /etc/xdg/reflector/reflector.conf
echo "--age 24" >> /etc/xdg/reflector/reflector.conf
echo "--sort rate" >> /etc/xdg/reflector/reflector.conf
echo "--latest 20" >> /etc/xdg/reflector/reflector.conf
echo "--connection-timeout 10" >> /etc/xdg/reflector/reflector.conf
echo "--download-timeout 10" >> /etc/xdg/reflector/reflector.conf
echo "--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf
systemctl enable reflector.timer
clear
echo " "
echo " "
echo " 🔍 Проверка fstab."
echo " "
cat /etc/fstab
echo " "
echo " "
echo " 🔍 Проверка локали."
echo " "
locale
echo " "
echo " "
echo " 🔍 Проверка времени."
echo " "
timedatectl
echo " "
date
echo " "
echo "#####################################################"
echo "## ✅ БАЗОВАЯ КОНФИГУРАЦИЯ СИСТЕМЫ ЗАВЕРШЕНА       ##"
echo "#####################################################"
echo " "
#################################################################






#################################################################
# 🔐  [CHROOT] БЛОК 10: НАСТРОЙКА HOSTNAME И ROOT
#################################################################

clear
echo "Sony" > /etc/hostname
cat > /etc/hosts << "EOF"
127.0.0.1   localhost
::1         localhost
127.0.1.1   Sony.localdomain   Sony
EOF
clear
echo " "
echo "###################################"
echo "## 🔑 СОЗДАЙТЕ ПАРОЛЬ ДЛЯ ROOT   ##"
echo "###################################"
echo " "
passwd
clear
echo " "
echo " 🔍 Проверка имени компьютера."
echo " "
cat /etc/hostname
echo " "
echo " "
echo " 🔍 Проверка файла hosts."
echo " "
cat /etc/hosts
echo " "
echo "#####################################################"
echo "## ✅ НАСТРОЙКА ROOT И HOST ЗАВЕРШЕНА              ##"
echo "#####################################################"
echo " "
#################################################################






#################################################################
# 👤  [CHROOT] БЛОК 11: ПОЛЬЗОВАТЕЛЬ И SUDO
#################################################################

clear
useradd -m -c "User Name" -s /bin/bash forename
usermod -aG wheel,users forename
sed -i "s/^# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/" /etc/sudoers
clear
echo " "
echo "###########################################"
echo "## 👤 СОЗДАЙТЕ ПАРОЛЬ ДЛЯ ПОЛЬЗОВАТЕЛЯ   ##"
echo "###########################################"
echo " "
passwd forename
clear
echo " "
echo " "
echo " 🔍 Проверка пользователя и групп."
echo " "
id forename
echo " "
echo " "
echo " 🔍 Проверка настройки sudo."
echo " "
grep "^%wheel" /etc/sudoers
echo " "
echo "#####################################################"
echo "## ✅ НАСТРОЙКА ПОЛЬЗОВАТЕЛЯ И SUDO ЗАВЕРШЕНА      ##"
echo "#####################################################"
echo " "
#################################################################






#################################################################
# 🔧  [CHROOT] БЛОК 12: УСТАНОВКА ЯДРА, GRUB, MKINITCPIO
#################################################################

clear
pacman -Syy
pacman -S --noconfirm linux-lts linux-lts-headers linux-firmware
pacman -S --noconfirm grub grub-btrfs os-prober
pacman -S --noconfirm networkmanager wpa_supplicant wireless_tools
pacman -S --noconfirm openssh
pacman -S --noconfirm plymouth
systemctl enable NetworkManager.service
systemctl enable grub-btrfsd.service
systemctl enable sshd.service
grub-install --target=i386-pc --recheck /dev/sdx
sed -i "s|^HOOKS=(.*)|HOOKS=(base systemd autodetect microcode modconf kms keyboard sd-vconsole block filesystems fsck)|" /etc/mkinitcpio.conf
sed -i "s/MODULES=()/MODULES=(btrfs)/" /etc/mkinitcpio.conf
SWAP_UUID=$(blkid -s UUID -o value /dev/sda3)
sed -i "s|^GRUB_CMDLINE_LINUX_DEFAULT=.*|GRUB_CMDLINE_LINUX_DEFAULT=\"loglevel=3 quiet splash resume=UUID=${SWAP_UUID}\"|" /etc/default/grub
sed -i "s/#GRUB_BTRFS_SUBMENUNAME=.*/GRUB_BTRFS_SUBMENUNAME="Arch Linux snapshots"/" /etc/default/grub-btrfs/config
sed -i "s/#GRUB_BTRFS_TITLE_FORMAT=.*/GRUB_BTRFS_TITLE_FORMAT=("description" "date")/" /etc/default/grub-btrfs/config
tee -a /etc/grub.d/40_custom << "EOF"

menuentry "Выключение системы" {
    halt
}

menuentry "Перезагрузка системы" {
    reboot
}
EOF
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
clear
echo " "
echo " "
echo " 🔍 Проверка параметров ядра в grub.cfg"
echo " "
grep "rootflags" /boot/grub/grub.cfg | head -1
echo " "
echo " "
echo " 🔍 Проверка HOOKS в mkinitcpio.conf"
echo " "
grep "^HOOKS=" /etc/mkinitcpio.conf
echo " "
echo " "
echo " 🔍 Проверка MODULES в mkinitcpio.conf"
echo " "
grep "^MODULES=" /etc/mkinitcpio.conf
# #------------------------------------------------------------------------------
echo " "
echo "#####################################################"
echo "## ✅ ЗАГРУЗЧИК И ЯДРО НАСТРОЕНЫ (BIOS+Btrfs)     ##"
echo "#####################################################"
echo " "
#################################################################






#################################################################
# 🛠️  [CHROOT] БЛОК 13: СИСТЕМНЫЕ УТИЛИТЫ И НАСТРОЙКИ
#################################################################

clear
pacman -S --noconfirm mesa lib32-mesa
pacman -S --noconfirm haveged wget usbutils lsof dmidecode dialog zip unzip unrar p7zip lzop lrzip sudo mlocate less bash-completion
pacman -S --noconfirm neovim ripgrep bat zstd lz4 smartmontools lm_sensors rsync git fwupd
pacman -S --noconfirm dosfstools ntfs-3g exfatprogs gptfdisk fuse2 fuse3 fuseiso nfs-utils cifs-utils
pacman -S --noconfirm power-profiles-daemon
systemctl enable power-profiles-daemon.service
pacman -S --noconfirm dbus-broker
systemctl enable dbus-broker.service
pacman -S --noconfirm cronie
systemctl enable cronie.service systemd-timesyncd.service
systemctl enable haveged.service
echo "vm.swappiness=10" > /etc/sysctl.d/99-swappiness.conf
pacman -S --noconfirm bluez bluez-utils
systemctl enable bluetooth.service
sed -i "s/#AutoEnable=true/AutoEnable=true/g" /etc/bluetooth/main.conf
pacman -S --noconfirm cups cups-pdf ghostscript gsfonts avahi system-config-printer
systemctl enable cups.service avahi-daemon.service
pacman -S --noconfirm xdg-utils xdg-user-dirs
xdg-user-dirs-update
pacman -S --noconfirm udisks2 udiskie polkit
pacman -S --noconfirm pipewire-alsa pipewire-pulse pipewire-jack pipewire-v4l2 pipewire-zeroconf alsa-utils sof-firmware
pacman -S --noconfirm wireplumber
systemctl --global enable pipewire pipewire-pulse wireplumber
pacman -S --noconfirm gstreamer gst-plugins-{base,good,bad,ugly} gst-libav ffmpeg a52dec faac faad2 flac lame libdca libdv libmad libmpeg2 libtheora libvorbis wavpack x264 x265 xvidcore libdvdcss taglib
pacman -S --noconfirm man-db man-pages man-pages-ru
pacman -S --noconfirm iproute2 inetutils dnsutils
pacman -S --noconfirm noto-fonts noto-fonts-emoji ttf-dejavu ttf-liberation terminus-font wqy-zenhei wqy-bitmapfont fontconfig freetype2 harfbuzz libxft
fc-cache -fv
clear
echo " "
echo " "
echo " 🔍 Проверка включенных служб."
echo " "
systemctl list-unit-files --state=enabled | grep -E "haveged|cronie|bluetooth|cups|avahi|dbus|fwupd"
echo " "
echo " "
echo " 🔍 Проверка swappiness."
echo " "
cat /etc/sysctl.d/99-swappiness.conf
echo " "
echo " "
echo " 🔍 Проверка кэша шрифтов."
echo " "
fc-list | wc -l
echo " "
echo " "
echo "##############################################"
echo "## 🎮 ОПРЕДЕЛЕНИЕ ВИДЕОКАРТЫ ДЛЯ ДРАЙВЕРОВ  ##"
echo "##############################################"
echo " "
echo " "
echo "# Проверка видеокарты"
echo " "
lspci -nn | grep -E "VGA|3D|Display"
echo " "
echo " "
echo "# Проверка загруженных драйверов"
echo " "
lsmod | grep -E "nvidia|amdgpu|i915|nouveau|vbox"
echo " "
echo " "
echo "#####################################################"
echo "## ✅ СИСТЕМНЫЕ УТИЛИТЫ И НАСТРОЙКИ ЗАВЕРШЕНЫ      ##"
echo "#####################################################"
echo " "
#################################################################







#################################################################
# 🎨 [CHROOT] БЛОК 14: УСТАНОВКА ВИДЕОДРАЙВЕРОВ И НАСТРОЙКА WAYLAND
#################################################################

clear
pacman -S --noconfirm vulkan-tools libva-utils mesa-utils mesa-demos glmark2 nvtop vkd3d lib32-vkd3d

#------------------------------------------------------------------------------
# ШАГ 2: ВЫБОР СЦЕНАРИЯ ВИДЕО (ВЫПОЛНИТЬ ТОЛЬКО ОДИН ВАРИАНТ)
#------------------------------------------------------------------------------
# 💡 ИНСТРУКЦИЯ:
# • Для одной видеокарты: выполните ТОЛЬКО один сценарий (А, Б или В).
# • Для гибридной (AMD iGPU + NVIDIA dGPU): выполните ШАГ 1 + Сценарий Г.
# • Удалите символ # только перед командами выбранного сценария.

# ==============================================================================
# >>> [СЦЕНАРИЙ А] INTEL (Встроенная графика) <<<
# ==============================================================================

# pacman -S --noconfirm intel-media-driver vulkan-intel lib32-vulkan-intel


# ==============================================================================
# >>> [СЦЕНАРИЙ Б] AMD (Radeon / APU) <<<
# ==============================================================================

# pacman -S --noconfirm vulkan-radeon lib32-vulkan-radeon corectrl


# ==============================================================================
# >>> [СЦЕНАРИЙ В] NVIDIA (ОДИНОЧНАЯ, ДЕСКТОП / ПК) <<<
# ==============================================================================

# pacman -S --noconfirm nvidia-open-dkms nvidia-utils lib32-nvidia-utils egl-wayland egl-wayland2 nvidia-settings
# sed -i -E 's/^(GRUB_CMDLINE_LINUX_DEFAULT="[^"]*)"/\1 nvidia-drm.modeset=1"/' /etc/default/grub
# echo "options nvidia-drm modeset=1" > /etc/modprobe.d/nvidia.conf
# echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1" >> /etc/modprobe.d/nvidia.conf
# echo "options nvidia NVreg_TemporaryFilePath=/var/tmp" >> /etc/modprobe.d/nvidia.conf
# systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service
# mkinitcpio -P
# grub-mkconfig -o /boot/grub/grub.cfg


# ==============================================================================
# >>> [СЦЕНАРИЙ Г] ГИБРИДНАЯ ГРАФИКА (AMD/INTEL iGPU + NVIDIA dGPU) <<<
# ==============================================================================

# pacman -S --noconfirm nvidia-open-dkms nvidia-utils lib32-nvidia-utils egl-wayland egl-wayland2 nvidia-settings
# pacman -S --noconfirm switcheroo-control nvidia-prime
# sed -i -E 's/^(GRUB_CMDLINE_LINUX_DEFAULT="[^"]*)"/\1 nvidia-drm.modeset=1 nvidia.NVreg_PreserveVideoMemoryAllocations=0 resume_offset=0"/' /etc/default/grub
# sed -i "s/^MODULES=(\(.*\))/MODULES=(\1 nvme)/" /etc/mkinitcpio.conf
# mkinitcpio -P
# grub-mkconfig -o /boot/grub/grub.cfg
# systemctl enable switcheroo-control.service
clear
echo " "
echo "#------------------------------------------------------------------------------"
echo "# 🔍 ПРОВЕРКА НАСТРОЕК ГРАФИКИ"
echo "#------------------------------------------------------------------------------"
echo "1. Параметры ядра GRUB:"
grep "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub
echo " "

if [ -f /etc/modprobe.d/nvidia.conf ]; then
  echo "2. Содержимое /etc/modprobe.d/nvidia.conf (только для Сценария В):"
  cat /etc/modprobe.d/nvidia.conf
  echo " "
fi

echo "3. Хуки mkinitcpio:"
grep "^HOOKS=" /etc/mkinitcpio.conf
echo " "

echo "4. Модули mkinitcpio (должен присутствовать nvme):"
grep "^MODULES=" /etc/mkinitcpio.conf
echo " "

echo "5. Статус службы switcheroo-control (для гибрида):"
systemctl is-enabled switcheroo-control.service 2>/dev/null || echo "Служба не включена или не установлена"
echo " "

echo "6. Установленные пакеты egl-wayland:"
pacman -Qs egl-wayland | grep -E "^extra/|версия"
echo " "
echo "#######################################################"
echo "## ✅  УСТАНОВКА ДРАЙВЕРОВ ВИДЕОКАРТ ЗАВЕРШЕНА       ##"
echo "#######################################################"
echo "# ✅ ВСЕ ДЕЙСТВИЯ ВЫПОЛНЕНЫ.   "
echo "# ⚠️ НЕ ВЫХОДИТЕ из chroot!   "
echo "# 📌 Убедитесь, что все команды из выбранных шагов выполнены.   "
echo "# ➡️ ПРОДОЛЖИТЕ УСТАНОВКУ:   "
echo " "
#################################################################







#################################################################
# 🖥️  [CHROOT] БЛОК 15: УСТАНОВКА В VIRTUALBOX
#################################################################

clear
pacman -S --noconfirm virtualbox-guest-utils
modprobe -a vboxguest vboxsf vboxvideo
systemctl enable vboxservice.service
echo "vboxguest vboxsf vboxvideo" > /etc/modules-load.d/virtualbox.conf
usermod -aG vboxsf forename
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
clear
echo " "
echo " 🔍 Проверка загруженных модулей."
echo " "
lsmod | grep vbox
echo " "
echo " "
echo " 🔍 Проверка группы пользователя."
# ⚠️ Убедитесь, что имя пользователя заменено корректно!
echo " "
id forename
echo " "
echo "#####################################################"
echo "## ✅ НАСТРОЙКА VIRTUALBOX ЗАВЕРШЕНА               ##"
echo "#####################################################"
echo " "
#################################################################






#################################################################
# 🖥️  [CHROOT] БЛОК 16: УСТАНОВКА ГРАФИЧЕСКОЙ СРЕДЫ (DE/WM)
#################################################################



#################################################################
# 🌐 ВАРИАНТ: KDE PLASMA
#################################################################

clear
pacman -S --noconfirm plasma-desktop breeze breeze-cursors breeze-gtk breeze-plymouth kdecoration kinfocenter libplasma qqc2-breeze-style kdeplasma-addons kwayland kwin kwin-x11 layer-shell-qt plasma-integration plasma-workspace plasma-workspace-wallpapers kde-gtk-config plymouth-kcm sddm-kcm systemsettings bluedevil kpipewire kscreen libkscreen plasma-nm plasma-pa powerdevil ksystemstats kwallet-pam kwrited plasma-login-manager polkit-kde-agent plasma-browser-integration
pacman -S --noconfirm kde-system dolphin-plugins kate konsole gwenview elisa okular ark
pacman -S --noconfirm ffmpegthumbs poppler-glib qt6-wayland
pacman -S --noconfirm gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd
pacman -S --noconfirm sddm
systemctl enable sddm.service
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
clear
echo " "
echo "#####################################################"
echo "## ✅ KDE PLASMA УСТАНОВЛЕНА УСПЕШНО               ##"
echo "#####################################################"
echo " "
exit
#################################################################


#################################################################
# 🌐 ВАРИАНТ: GNOME
#################################################################

clear
pacman -S --noconfirm gnome gnome-tweaks gnome-themes-extra gnome-shell-extensions dconf-editor file-roller gnome-browser-connector
pacman -S --noconfirm packagekit gnome-packagekit xdg-desktop-portal xdg-desktop-portal-gnome
pacman -S --noconfirm mpv shotwell
pacman -S --noconfirm gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd
pacman -S --noconfirm ffmpegthumbnailer poppler-glib
systemctl enable gdm.service
echo "[User]" > /var/lib/AccountsService/users/root
echo "SystemAccount=true" >> /var/lib/AccountsService/users/root
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
clear
echo " "
echo "#####################################################"
echo "## ✅ GNOME УСТАНОВЛЕНА УСПЕШНО                    ##"
echo "#####################################################"
echo " "
exit
#################################################################


#################################################################
🌌 ВАРИАНТ: COSMIC (System76)
#################################################################

clear
pacman -S --noconfirm cosmic
pacman -S --noconfirm cosmic-greeter
systemctl enable cosmic-greeter.service
pacman -S --noconfirm gnome-keyring
pacman -S --noconfirm gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd
pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-cosmic mpv shotwell
pacman -S --noconfirm ffmpegthumbnailer poppler-glib
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
clear
echo " "
echo "#####################################################"
echo "## ✅ COSMIC УСТАНОВЛЕНА УСПЕШНО                   ##"
echo "#####################################################"
echo " "
exit
#################################################################


#################################################################
# 🪟 ВАРИАНТ: XFCE4
#################################################################

clear
pacman -S --noconfirm xfce4 xfce4-goodies mugshot pavucontrol ristretto thunar-archive-plugin
pacman -S --noconfirm network-manager-applet blueman
pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-gtk mpv shotwell xdg-user-dirs
pacman -S --noconfirm ffmpegthumbnailer poppler-glib
pacman -S --noconfirm gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd
pacman -S --noconfirm lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
systemctl enable lightdm.service
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
clear
echo " "
echo "#####################################################"
echo "## ✅ XFCE4 УСТАНОВЛЕНА УСПЕШНО                    ##"
echo "#####################################################"
echo " "
exit
#################################################################


#################################################################
# 🍃 ВАРИАНТ: MATE
#################################################################

clear
pacman -S --noconfirm mate mate-extra
pacman -S --noconfirm network-manager-applet blueman
pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-gtk mpv shotwell
pacman -S --noconfirm ffmpegthumbnailer poppler-glib
pacman -S --noconfirm gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd
pacman -S --noconfirm lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings
systemctl enable lightdm.service
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
clear
echo " "
echo "#####################################################"
echo "## ✅ MATE УСТАНОВЛЕНА УСПЕШНО                     ##"
echo "#####################################################"
echo " "
exit
#################################################################


#################################################################
# 🕯️ ВАРИАНТ: CINNAMON
#################################################################

clear
pacman -S --noconfirm cinnamon cinnamon-translations gnome-terminal evince
pacman -S --noconfirm network-manager-applet blueman
pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-gtk mpv shotwell
pacman -S --noconfirm ffmpegthumbnailer poppler-glib
pacman -S --noconfirm gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd
pacman -S --noconfirm lightdm  lightdm-slick-greeter
systemctl enable lightdm.service
sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-slick-greeter/' /etc/lightdm/lightdm.conf
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
clear
echo " "
echo "#####################################################"
echo "## ✅ CINNAMON УСТАНОВЛЕНА УСПЕШНО                 ##"
echo "#####################################################"
echo " "
exit
#################################################################


#################################################################
# 🧩 ВАРИАНТ: LXQT
#################################################################

clear
pacman -S --noconfirm lxqt sddm breeze breeze-icons featherpad libstatgrab libsysstat
pacman -S --noconfirm network-manager-applet blueman
pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-gtk mpv shotwell
pacman -S --noconfirm ffmpegthumbnailer poppler-glib
pacman -S --noconfirm gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd
systemctl enable sddm.service
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
clear
echo " "
echo "#####################################################"
echo "## ✅ LXQT УСТАНОВЛЕНА УСПЕШНО                     ##"
echo "#####################################################"
echo " "
exit
#################################################################


#################################################################
# 🖼️ ВАРИАНТ: LXDE
#################################################################

clear
pacman -S --noconfirm lxde featherpad thunar-archive-plugin udiskie xfce4-notifyd dunst picom
pacman -S --noconfirm network-manager-applet blueman
pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-gtk mpv shotwell
pacman -S --noconfirm ffmpegthumbnailer poppler-glib gnome-themes-extra
pacman -S --noconfirm lightdm lightdm-slick-greeter
sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-slick-greeter/" /etc/lightdm/lightdm.conf
systemctl enable lightdm.service
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
clear
echo " "
echo "#####################################################"
echo "## ✅ LXDE УСТАНОВЛЕНА УСПЕШНО                     ##"
echo "#####################################################"
echo " "
exit
#################################################################







#################################################################
# 🧹  [LIVE] БЛОК 17: ЗАВЕРШЕНИЕ УСТАНОВКИ
#################################################################
umount -R /mnt
swapoff -a
poweroff
#################################################################


#################################################################
# 🧹 Очистка конфигурации ssh соединения (При необходимости)
#################################################################
rm -r .ssh/
#################################################################





#################################################################
# 🏁 ЗАВЕРШЕНИЕ УСТАНОВКИ
#################################################################
# ✅ Если все команды выше выполнились без ошибок и окна открылись:
#    - Система полностью настроена.
#    - Драйверы работают корректно.
#
# 🎉 Добро пожаловать в мир Arch Linux!
#
#################################################################
