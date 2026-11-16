#################################################################
# 🔍  [LIVE] БЛОК 0: НАСТРОЙКА ЛОКАЦИИ ЗЕРКАЛ (Mirrors)
#################################################################
# ℹ️ Зачем: Динамический подбор 10 ближайших стран для максимальной
#    скорости загрузки пакетов. Работает в любой точке мира.
# 💡 Принцип: Скрипт определяет ближайшие страны → вы заменяете
#    переменную Russia на полученный список → reflector использует
#    только самые быстрые зеркала для вашей локации.
#################################################################
# #------------------------------------------------------------------------------
# ШАГ 1: СОЗДАНИЕ СКРИПТА ОПРЕДЕЛЕНИЯ СТРАН
# #------------------------------------------------------------------------------
# 🐍 Создание Python-скрипта для расчета расстояний до столиц.
# Использует только стандартные библиотеки (urllib, json, math).
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
# #------------------------------------------------------------------------------
# ШАГ 2: ЗАПУСК СКРИПТА И ПОЛУЧЕНИЕ СПИСКА
# #------------------------------------------------------------------------------
# 🚀 Запуск скрипта для определения ближайших стран.
clear
echo "  "
echo "  "
python light_countries.py
# 🧹 Удаление скрипта после использования
rm -f ~/light_countries.py
echo "  "
echo "${CG}╔══════════════════════════════════════════════════════════════════════════╗${CN}"
echo "${CG}║${TG} БЛОК 0 ЗАВЕРШЁН — ЛОКАЦИЯ ЗЕРКАЛ ОПРЕДЕЛЕНА                              ${CN}${CG}║${CN}"
echo "${CG}╟──────────────────────────────────────────────────────────────────────────╢${CN}"
echo "${CG}║${CW}  Что сделано: таблица 10 ближайших стран выведена выше, временный        ${CN}${CG}║${CN}"
echo "${CG}║${CW}  скрипт light_countries.py удалён.                                       ${CN}${CG}║${CN}"
echo "${CG}║${CW}  Далее: БЛОК 1 — вписать страны в список (редактирование файла).         ${CN}${CG}║${CN}"
echo "${CG}╚══════════════════════════════════════════════════════════════════════════╝${CN}"
echo "  "
#################################################################







#################################################################
# 🔧  [EDIT] БЛОК 1: НАСТРОЙКА ЛОКАЦИИ ЗЕРКАЛ (Mirrors)
#################################################################
# ℹ️ Зачем: Для максимальной скорости установки пакетов.
# 💡 ИНСТРУКЦИЯ:
# • Составьте по порядку список стран, через запятую, которые ближе всего.
# • Замените переменную Russia на результат из скрипта.
# • ПРИМЕР: Russia  > Russia,Estonia,Finland,Latvia,Lithuania,Belarus,Sweden "
# 💡 СОВЕТ ПО РЕДАКТИРОВАНИЮ:
# • Если в Live-среде доступен графический редактор, используйте его для замены.
# • Иначе используйте поиск и замену в текстовом редакторе или команду sed.
# • Главное: убедитесь, что переменная (Russia) заменена!
#################################################################
#
#################################################################
# Назначение                  # Значение для замены (шаблон)
#################################################################
# Местоположение пользователя # Russia
#################################################################
#
#################################################################
# ✅ ПЕРЕХОДИТЕ К БЛОКУ 2
#################################################################







#################################################################
# ⚙️ [LIVE] БЛОК 2: ПОДГОТОВКА LIVE-СРЕДЫ
#################################################################
# ℹ️ Зачем: Настройка системных часов, обновление зеркал, установка
# вспомогательных утилит.
# ℹ️ Важно: Выполняется в загрузочной среде (до chroot).
# 💡 Включает: haveged, inxi, lshw.
#################################################################
clear
# 🎨 Цвета окон и рамок (безопасно задавать повторно в каждом блоке)
CN=$'\e[0m'; CB=$'\e[1;36m'; CW=$'\e[1;37m'; CG=$'\e[1;32m'; CY=$'\e[1;33m'; CR=$'\e[1;31m'; TB=$'\e[1;30;38;2;0;0;0;46m'; TG=$'\e[1;30;38;2;0;0;0;42m'; TY=$'\e[1;30;38;2;0;0;0;43m'
# 🎹 Латинская раскладка (us) — ЕДИНАЯ для всей установки: в ней же
#    будет вводиться любой пароль (схема us/us, подтверждена владельцем).
# 🔤 Русский вывод в консоли сохраняет шрифт cyr-sun16 ниже — за кириллицу
#    отвечает шрифт, а не раскладка.
loadkeys us
# 🔤 Установка русского шрифта для консоли
setfont cyr-sun16
# ⏰ Синхронизация системного времени через NTP
timedatectl set-ntp true
# 🌐 Включение русской и английской локали в locale.gen
sed -i "s/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/" /etc/locale.gen
sed -i "s/#ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/" /etc/locale.gen
# locale-gen — генерация выбранных локалей
locale-gen
# export LANG — установка основной локали системы
export LANG=ru_RU.UTF-8
# ⚙️ Настройка pacman: параллельная загрузка 15 пакетов
# ❗ Шаблон ищет строку С решёткой: в стандартном /etc/pacman.conf она
#    закомментирована («#ParallelDownloads = 5»). Прежняя форма
#    s/"ParallelDownloads = 5"/…/ не совпадала ни с чем, и параллельная
#    загрузка молча не включалась.
sed -i 's/^#ParallelDownloads = 5/ParallelDownloads = 15/' /etc/pacman.conf
# Включение цветного вывода pacman
sed -i s/"#Color"/"Color"/g /etc/pacman.conf
# Включение подробного списка пакетов при обновлении
sed -i "/^Color$/a VerbosePkgLists" /etc/pacman.conf
# Отключение таймаута загрузки пакетов
sed -i "/^Color$/a DisableDownloadTimeout" /etc/pacman.conf
# Включение индикатора прогресса "ILoveCandy"
sed -i "/^Color$/a ILoveCandy" /etc/pacman.conf
# Повторная синхронизация времени
timedatectl set-ntp true
clear








# 📋 НАСТРОЙКА REFLECTOR (ОПТИМИЗИРОВАННЫЙ)
# ℹ️ Назначение: Автоматический выбор и регулярное обновление быстрых зеркал pacman.
# ⚠️ Важно: Параметр --country должен быть заменён на ваш список из Блока 0/1.
# 💡 Формат: Одна команда на строку, комментарии через #.

# 🌐 1. Создание конфига (перезаписывает файл, задаёт страны)
echo "--country Russia" > /etc/xdg/reflector/reflector.conf
# ✅ Замените страны на результат скрипта light_countries.py
# ✅ Формат: через запятую БЕЗ пробелов (пробел ломает парсинг)
# ✅ Можно использовать коды стран: RU,EE,FI,LV,LT

# 🔒 2. Протокол подключения
echo "--protocol https" >> /etc/xdg/reflector/reflector.conf
# ✅ Всегда используйте HTTPS: шифрует трафик и отсеивает старые HTTP-зеркала
# ✅ Не добавляйте http, ftp или rsync без острой необходимости

# ⏱️ 3. Максимальный возраст зеркал (в часах)
echo "--age 24" >> /etc/xdg/reflector/reflector.conf
# ✅ Отсеивает зеркала, которые не синхронизировались с main > 24 часов
# ✅ Увеличьте до 48, если в регионе мало актуальных зеркал

# 📊 4. Критерий сортировки
echo "--sort rate" >> /etc/xdg/reflector/reflector.conf
# ✅ rate = реальная скорость загрузки (рекомендуется для pacman)
# ✅ Альтернативы: score (общий рейтинг), country (география)

# 🔝 5. Количество зеркал в финальном списке
echo "--latest 20" >> /etc/xdg/reflector/reflector.conf
# ✅ Оставляет 20 самых быстрых зеркал в /etc/pacman.d/mirrorlist
# ✅ Менее 10 → падает отказоустойчивость. Более 50 → pacman медленно проверяет зеркала

# 🌐 6. Таймауты подключения и загрузки (секунды)
echo "--connection-timeout 10" >> /etc/xdg/reflector/reflector.conf
echo "--download-timeout 10" >> /etc/xdg/reflector/reflector.conf
# ✅ 10 сек — оптимальный баланс для стабильного интернета
# ✅ Увеличьте до 15-20 при мобильной сети или нестабильном канале

# 💾 7. Путь сохранения итогового списка зеркал
echo "--save /etc/pacman.d/mirrorlist" >> /etc/xdg/reflector/reflector.conf
# ✅ Стандартный путь для pacman. Не менять без веской причины!
# ✅ Файл будет автоматически перезаписываться при запуске reflector

# 🔧 8. ПРИМЕНЕНИЕ НАСТРОЕК (выполнить после создания конфига)
systemctl restart reflector.service
clear







#################################################################
# 🧱  [LIVE] БЛОК 8: УСТАНОВКА БАЗОВЫХ ПАКЕТОВ
#################################################################
# ℹ️ Зачем: Установка минимальной системы, утилит и переход в chroot.
# 💡 Включает: base, btrfs, nano, reflector, pacman-contrib.
# ❗ Важно: Правильный fstab критически важен для загрузки!
#################################################################
# 🧹 Очистка экрана терминала
clear
# #------------------------------------------------------------------------------
# ШАГ 1: УСТАНОВКА БАЗОВОЙ СИСТЕМЫ
# #------------------------------------------------------------------------------
# ℹ️ Все пакеты ставятся ОДНИМ вызовом: быстрее и не повторяет инициализацию keyring.
# 📦 base — минимальный набор пакетов Arch Linux (~150 МБ)
# 📦 amd-ucode — микрокод для процессоров AMD (~3 МБ)
# ⚠️ Для Intel замените amd-ucode на intel-ucode iucode-tool
# 📦 memtest86+-efi — тест оперативной памяти для UEFI (~2 МБ)
# 📦 nano — простой текстовый редактор для новичков (~0.3 МБ)
# 📦 reflector — автоматический выбор ближайших зеркал (~0.3 МБ)
# 📦 pacman-contrib — утилиты для pacman: paccache, pacsort (~0.5 МБ)
# 📦 curl — загрузка файлов через HTTP/HTTPS (~0.7 МБ)
# 📦 btrfs-progs — утилиты для работы с BTRFS (~5 МБ)
# 📦 sudo — выполнение команд от root
pacman -S --noconfirm amd-ucode memtest86+-efi nano reflector pacman-contrib curl btrfs-progs sudo
clear
#################################################################






#################################################################
# 🔧  [CHROOT] БЛОК 12: УСТАНОВКА ЯДРА, GRUB, MKINITCPIO
#################################################################
# ⏳ ОБЪЁМ БЛОКА 12: ~15 КБ ВСТАВКИ — на занятой ВМ вставляйте его ЧАСТЯМИ
#    (от одной границы «# #-----» до следующей, следующую порцию —
#     только ПОСЛЕ завершения тяжёлой команды).
# ℹ️ Зачем: Установка ядра, настройка загрузчика GRUB и initramfs
# для работы с Btrfs и гибернацией.
# 💡 Включает: GRUB, grub-btrfs, plymouth, resume из swap.
# ❗ КРИТИЧЕСКИ ВАЖНО: Без корректных настроек система НЕ ЗАГРУЗИТСЯ!
# 📌 ESP раздел монтируется в /boot для UEFI.
#################################################################
# 🧹 Очистка экрана терминала
clear
pacman -Syu
# #------------------------------------------------------------------------------
# ШАГ 1: УСТАНОВКА ЗАГРУЗЧИКА
# #------------------------------------------------------------------------------
# 📦 grub-btrfs — интеграция снапшотов BTRFS в GRUB (~0.2 МБ)
# 📦 inotify-tools — набор утилит inotify для мониторинга событий файловой системы в реальном времени
pacman -S --noconfirm grub-btrfs inotify-tools
# 📦 networkmanager — управление сетевыми подключениями (~2 МБ)
# 📦 wpa_supplicant — поддержка WPA/WPA2 для WiFi (~0.8 МБ)
# 📦 wireless_tools — утилиты для беспроводных сетей (~0.2 МБ)
pacman -S --noconfirm networkmanager wpa_supplicant wireless_tools
# 📦 openssh — сервер и клиент SSH для удалённого доступа (~2 МБ)
pacman -S --noconfirm openssh
# 🔧 Включение системных служб
systemctl enable NetworkManager.service
systemctl enable grub-btrfsd.service
systemctl enable sshd.service
# #------------------------------------------------------------------------------
# ШАГ 6: НАСТРОЙКА GRUB-BTRFS И ПУНКТОВ МЕНЮ
# #------------------------------------------------------------------------------
# 📋 Настройка отображения снапшотов в GRUB
sed -i "s|#GRUB_BTRFS_SUBMENUNAME=.*|GRUB_BTRFS_SUBMENUNAME=\"Arch Linux snapshots\"|" /etc/default/grub-btrfs/config
sed -i "s|#GRUB_BTRFS_TITLE_FORMAT=.*|GRUB_BTRFS_TITLE_FORMAT=(\"description\" \"date\")|" /etc/default/grub-btrfs/config
# 📋 Добавление пунктов меню включение и перезагрузка системы
tee -a /etc/grub.d/40_custom << "EOF"

menuentry "Выключение системы" {
    halt
}

menuentry "Перезагрузка системы" {
    reboot
}
EOF
# #------------------------------------------------------------------------------
# ШАГ 7: ГЕНЕРАЦИЯ КОНФИГУРАЦИИ И ПЕРЕСБОРКА
# #------------------------------------------------------------------------------
# 📋 Генерация конфигурации GRUB
grub-mkconfig -o /boot/grub/grub.cfg
# 📋 Пересборка initramfs
mkinitcpio -P
# 🧹 Очистка экрана терминала
clear
echo " "
#################################################################






################################################################## ШАГ 1: BTRFS ASSISTANT И SNAPPER — СОЗДАНИЕ СНИМКОВ СИСТЕМЫ
#################################################################
# ⚠️ ВАЖНО: Данный шаг обязателен для создания снимков системы
# ℹ️ Зачем: Установка и настройка элементов по созданию снимков
# 📦 snapper          — управление снапшотами Btrfs: CLI, демон snapperd, таймеры
# 📦 snap-pac         — хуки pacman: снапшоты pre/post на каждую транзакцию (откат обновлений)
# 📦 btrfsmaintenance — обслуживание Btrfs: balance/defrag/trim/scrub по расписанию
# 📦 btrfs-assistant  — GUI (Qt): подтома, снапшоты, конфиги snapper, восстановление
pacman -S --noconfirm snapper btrfsmaintenance btrfs-assistant
# ⚠️ snap-pac ставится ОТДЕЛЬНОЙ командой и со страховкой (решение эталона
#    v4.5). Он есть в extra, но если в вашем зеркале/снапшоте пакета не
#    окажется, pacman не выполнит ВСЮ транзакцию: без разделения вместе с
#    snap-pac не поставились бы ни snapper, ни btrfs-assistant, и снимков
#    не было бы вовсе. Так — падает только эта команда, а snapper и
#    таймеры ниже уже на месте.
pacman -S --noconfirm snap-pac || echo "⚠️ snap-pac не установлен — пакет в extra; проверьте зеркала или поставьте из AUR"
# ОБЯЗАТЕЛЬНО: конфиг snapper для / (без него все таймеры бесполезны).
#  НАСТРОЙКА BTRFS И SNAPPER
# Включить юниты snapper:
# 📦 snapper-backup.timer   — ежечасно: бэкап снапшотов на внешние носители; без них простаивает)
# 📦 snapper-boot.timer     — снапшот «boot» после каждой загрузки: точка «до этой загрузки»
# 📦 snapper-cleanup.timer  — каждый час: удаление старых снапшотов по лимитам из configs/
# 📦 snapper-sync.service   — синхронизация номеров снапшотов между конфигами (root/home)
# 📦 snapper-timeline.timer — ежечасные timeline-снапшоты (архив hourly/daily/monthly)
systemctl enable snapper-backup.timer snapper-boot.timer snapper-cleanup.timer snapper-sync.service snapper-timeline.timer
clear







#################################################################
# 🛠️  [CHROOT] БЛОК 13: СИСТЕМНЫЕ УТИЛИТЫ И НАСТРОЙКИ
#################################################################
# ℹ️ Зачем: Установка основных элементов системы.
# 💡 Включает: btrfs-assistant, Bluetooth, CUPS, xdg, PipeWire, архиваторы, мониторинг.
#################################################################
# #------------------------------------------------------------------------------
# ШАГ 2: БАЗОВЫЕ УТИЛИТЫ ГРАФИКИ
# #------------------------------------------------------------------------------
# ⚠️ ВАЖНО: Данный шаг обязателен для выполнения
# ℹ️ Зачем: Установка только базовых видеодрайверов для запуска графической оболочки
# 📦 mesa/lib32-mesa : Основа графического стека (OpenGL, OpenCL).
pacman -S --noconfirm mesa lib32-mesa
# #------------------------------------------------------------------------------
# ШАГ 3: FLATPAK — УНИВЕРСАЛЬНЫЙ МАГАЗИН ПРИЛОЖЕНИЙ
# #------------------------------------------------------------------------------
# 📦 Flatpak — установка Discord, Telegram, Zoom, Spotify без сборки из AUR
pacman -S --noconfirm flatpak
# 🌐 Подключение основного репозитория Flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# #------------------------------------------------------------------------------
# ШАГ 4: БАЗОВЫЕ УТИЛИТЫ И АРХИВАТОРЫ
# #------------------------------------------------------------------------------
# 📦 haveged — генератор энтропии для ускорения шифрования.
# 📦 wget — загрузка файлов через HTTP/HTTPS.
# 📦 usbutils — утилиты для USB (lsusb).
# 📦 lsof — список открытых файлов.
# 📦 dmidecode — информация о железе (DMI/SMBIOS).
# 📦 dialog — текстовые диалоговые окна.
# 📦 zip/unzip/unrar/p7zip/lzop/lrzip — архиваторы.
# 📦 pkgfile — найти пакет по файлу (обучающий инструмент: pkgfile -s vim)
# 📦 mlocate — быстрый поиск файлов.
# 📦 less — постраничный просмотр текста.
# 📦 bash-completion — автодополнение команд в bash.
pacman -S --noconfirm haveged wget usbutils lsof dmidecode dialog zip unzip unrar p7zip lzop lrzip pkgfile mlocate less bash-completion
# #------------------------------------------------------------------------------
# ШАГ 5: УТИЛИТЫ АДМИНИСТРИРОВАНИЯ И МОНИТОРИНГА
# #------------------------------------------------------------------------------
# 📦 neovim — продвинутый текстовый редактор.
# 📦 ripgrep — быстрый поиск по тексту.
# 📦 bat — улучшенная версия cat с подсветкой.
# 📦 zstd/lz4 — алгоритмы сжатия.
# 📦 btop — монитор системы.
# 📦 smartmontools — мониторинг S.M.A.R.T. дисков.
# 📦 lm_sensors — мониторинг температур.
# 📦 rsync — синхронизация файлов.
# 📦 git — система контроля версий.
# 📦 fwupd — обновление прошивок оборудования.
pacman -S --noconfirm neovim ripgrep bat zstd lz4 smartmontools lm_sensors rsync git fwupd
# #------------------------------------------------------------------------------
# ШАГ 6: ПОДДЕРЖКА ФАЙЛОВЫХ СИСТЕМ И СЕТЕЙ
# #------------------------------------------------------------------------------
# 📦 dosfstools — утилиты для FAT32.
# 📦 ntfs-3g — поддержка NTFS.
# 📦 exfatprogs — поддержка exFAT.
# 📦 gptfdisk — работа с GPT разделами.
# 📦 fuse2/fuse3/fuseiso — пользовательские ФС.
# 📦 nfs-utils/cifs-utils — сетевые ФС.
pacman -S --noconfirm dosfstools ntfs-3g exfatprogs gptfdisk fuse2 fuse3 fuseiso nfs-utils cifs-utils
# #------------------------------------------------------------------------------
# ШАГ 7: СИСТЕМНЫЕ СЕРВИСЫ
# #------------------------------------------------------------------------------
# power-profiles-daemon — системный демон (служба) питания
# ⚠️ ВАЖНО: Если планируете устанавливать TLP (Этап 12 пост-установки),
#    power-profiles-daemon НУЖНО БУДЕТ отключить, т.к. они конфликтуют!
pacman -S --noconfirm power-profiles-daemon
# запустить соответствующий сервис:
systemctl enable power-profiles-daemon.service
# 📦 dbus-broker — шина D-BUS.
pacman -S --noconfirm dbus-broker
systemctl enable dbus-broker.service
# 📦 cronie — планировщик задач.
pacman -S --noconfirm cronie
systemctl enable cronie.service systemd-timesyncd.service
# 📦 haveged — включение службы.
systemctl enable haveged.service
# 📋 Параметры своппинга (ArchWiki → Zram, § «Optimizing swap on zram»).
cat > /etc/sysctl.d/99-swap-parameters.conf << "EOF"
vm.swappiness = 100
vm.watermark_boost_factor = 0
vm.watermark_scale_factor = 125
vm.page-cluster = 0
EOF
# 📋 Настройка объёма журналов приложений (100M)
sed -Ei 's/^#?SystemMaxUse=.*/SystemMaxUse=100M/' /etc/systemd/journald.conf
# #------------------------------------------------------------------------------
# ШАГ 8: ZRAM И EARLYOOM (КРИТИЧНО ДЛЯ ОТЗЫВЧИВОСТИ)
# #------------------------------------------------------------------------------
# 📦 zram-generator — сжатый swap в RAM. Критичен для систем с ≤16 ГБ RAM.
pacman -S --noconfirm zram-generator
# 📋 Настройка: 50% RAM, алгоритм zstd, приоритет 100 (выше дискового swap)
cat > /etc/systemd/zram-generator.conf << "EOF"
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
EOF
# 📦 earlyoom — убивает тяжёлые процессы ДО полного зависания системы.
pacman -S --noconfirm earlyoom
systemctl enable earlyoom.service
# 📦 paccache — автоматическая очистка кэша pacman (из pacman-contrib)
systemctl enable paccache.timer
# 📋 fstrim.timer — страховка.
systemctl enable fstrim.timer
# #------------------------------------------------------------------------------
# ШАГ 9: БЕЗОПАСНОСТЬ СЕТЕВЫХ СЛУЖБ
# #------------------------------------------------------------------------------
# 📦 fail2ban — защита SSH от брутфорса (SSH включён в Блоке 12!)
# 📋 fail2ban — НЕ фильтр пакетов: он банит адреса по логам. Сами sshd,
pacman -S --noconfirm fail2ban
systemctl enable fail2ban.service
# #------------------------------------------------------------------------------
# ШАГ 9A: МЕЖСЕТЕВОЙ ЭКРАН NFTABLES
# #------------------------------------------------------------------------------
# 📦 nftables — фильтр пакетов (fail2ban им не является).
pacman -S --noconfirm nftables
cat > /etc/nftables.conf << "EOF"
table inet arch_install {
    chain input {
        type filter hook input priority 0; policy drop;

        # Established/related — ответы на наши же исходящие соединения
        ct state established,related accept;
        ct state invalid drop;

        # Loopback
        iif "lo" accept;

        # ICMP/ICMPv6 — без него сеть «молча не пингуется»
        ip protocol icmp accept;
        ipv6-nexthdr icmpv6 accept;

        # SSH: не более 4 новых подключений в минуту с одного адреса
        tcp dport 22 ct state new meter ssh_limit { ip saddr limit rate 4/minute burst 4 packets } accept;

        # Локальная сеть (avahi/mDNS, cups): разрешаем только link-local
        udp dport 5353 ip saddr 169.254.0.0/16 accept;

        log prefix "nftables-drop: " limit rate 5/minute;
    }

    chain forward {
        type filter hook forward priority 0; policy drop;
    }

    chain output {
        type filter hook output priority 0; policy accept;
    }
}
EOF
systemctl enable nftables.service
# #------------------------------------------------------------------------------
# ШАГ 10: АППАРАТНАЯ ПОДДЕРЖКА НОУТБУКОВ И ПЕРИФЕРИИ
# #------------------------------------------------------------------------------
# 📦 fprintd — сканер отпечатков пальцев (90% современных ноутбуков)
# 📦 modemmanager + usb_modeswitch — 4G/5G модемы в ноутбуках
# 📦 geoclue — геолокация (нужна для автоматической смены ночной темы, часовых поясов)
pacman -S --noconfirm fprintd modemmanager usb_modeswitch geoclue
systemctl enable ModemManager.service
# #------------------------------------------------------------------------------
# ШАГ 11: BLUETOOTH, ПРИНТЕРЫ И СКАНЕРЫ
# #------------------------------------------------------------------------------
# 📦 bluez/bluez-utils — Bluetooth стек.
pacman -S --noconfirm bluez bluez-utils
# 📦 bluez-tools — дополнительные утилиты Bluetooth (pairing, trust)
pacman -S --noconfirm bluez-tools
systemctl enable bluetooth.service
sed -i "s/#AutoEnable=true/AutoEnable=true/g" /etc/bluetooth/main.conf
# 📦 cups/cups-pdf — принтеры и PDF.
# 📦 ghostscript/gsfonts — обработка PostScript.
# 📦 avahi — обнаружение в сети.
# 📦 system-config-printer — GUI настройки принтеров.
# 📦 simple-scan — программа для сканирования.
pacman -S --noconfirm cups cups-pdf ghostscript gsfonts avahi system-config-printer
systemctl enable cups.service avahi-daemon.service
# 📦 ipp-usb — современная печать по USB без драйверов (AirPrint/Mopria)
# 📦 sane-airscan — сканирование по сети/USB без драйверов (eSCL/WSD)
pacman -S --noconfirm ipp-usb sane-airscan
# #------------------------------------------------------------------------------
# ШАГ 12: XDG, МОНТИРОВАНИЕ И АУДИО
# #------------------------------------------------------------------------------
# 📦 xdg-utils/xdg-user-dirs — стандарты freedesktop.org.
pacman -S --noconfirm xdg-utils xdg-user-dirs
xdg-user-dirs-update
# 📦 udisks2/udiskie/polkit — автоматическое монтирование.
pacman -S --noconfirm udisks2 udiskie polkit
# 📦 pipewire-* — аудио/видео сервер.
# 📦 alsa-utils — утилиты ALSA.
# 📦 sof-firmware — прошивки для DSP.
pacman -S --noconfirm pipewire-alsa pipewire-pulse pipewire-jack pipewire-v4l2 pipewire-zeroconf alsa-utils sof-firmware
# 📦 wireplumber — менеджер сессий PipeWire.
pacman -S --noconfirm wireplumber
systemctl --global enable pipewire pipewire-pulse wireplumber
# 📦 helvum — GUI для маршрутизации PipeWire (патч-бей, удобно для новичков)
pacman -S --noconfirm helvum
# #------------------------------------------------------------------------------
# ШАГ 13: МУЛЬТИМЕДИА И КОДЕКИ
# #------------------------------------------------------------------------------
# 📦 gstreamer + кодеки — воспроизведение медиа.
# 📦 ffmpeg — конвертация видео/аудио.
# 📦 libdvdcss — воспроизведение DVD.
pacman -S --noconfirm gstreamer gst-plugins-{base,good,bad,ugly} gst-libav ffmpeg a52dec faac faad2 flac lame libdca libdv libmad libmpeg2 libtheora libvorbis wavpack x264 x265 xvidcore libdvdcss taglib
# #------------------------------------------------------------------------------
# ШАГ 14: ДОКУМЕНТАЦИЯ И СЕТЕВЫЕ УТИЛИТЫ
# #------------------------------------------------------------------------------
# 📦 man-db/man-pages/man-pages-ru — документация.
pacman -S --noconfirm man-db man-pages man-pages-ru
# 📦 iproute2/inetutils/dnsutils — сетевые утилиты.
pacman -S --noconfirm iproute2 inetutils dnsutils
# #------------------------------------------------------------------------------
# ШАГ 15: ШРИФТЫ
# #------------------------------------------------------------------------------
# 📦 noto-fonts/emoji — шрифты Noto.
# 📦 ttf-dejavu/liberation/terminus — основные шрифты.
# 📦 wqy-zenhei/bitmapfont — китайские шрифты.
# 📦 fontconfig/freetype2/harfbuzz/libxft — библиотеки шрифтов.
pacman -S --noconfirm noto-fonts noto-fonts-emoji ttf-dejavu ttf-liberation terminus-font wqy-zenhei wqy-bitmapfont fontconfig freetype2 harfbuzz libxft
# 📋 Обновление кэша шрифтов.
fc-cache -fv
# #------------------------------------------------------------------------------
# ШАГ 16: БАЗОВЫЙ СОФТ
# #------------------------------------------------------------------------------
# 📦 firefox-i18n-ru      # веб-браузер Mozilla Firefox — основной браузер (Руссифицированный)
# 📦 htop                 # интерактивный монитор процессов (улучшенная замена top)
# 📦 cpu-x                # инфо о процессоре/системе в стиле CPU-Z (графический)
# 📦 gparted              # графический редактор разделов диска (форматирование, ресайз)
# 📦 qbittorrent          # торрент-клиент с открытым кодом, без рекламы
# 📦 libreoffice-still-ru # офисный пакет LibreOffice, стабильная ветка "Still" (Руссифицированный)
# 📦 inxi                 # подробная сводка о системе в консоли: CPU, RAM, диски, сеть
# 📦 btop                 # современный мониторинг ресурсов в терминале (TUI): CPU, память, сеть
# 📦 thunderbird-i18n-ru  # почтовый клиент + календарь Mozilla Thunderbird (Руссифицированный)
pacman -S --noconfirm firefox-i18n-ru htop cpu-x gparted qbittorrent libreoffice-still-ru inxi btop thunderbird-i18n-ru
clear
#################################################################






#################################################################
# 🎨 [CHROOT] БЛОК 14: УСТАНОВКА ВИДЕОДРАЙВЕРОВ И НАСТРОЙКА WAYLAND
#################################################################
# ⏳ ОБЪЁМ БЛОКА 14: ~9 КБ ВСТАВКИ — на занятой ВМ вставляйте его ЧАСТЯМИ
#    (от одной границы «# #-----» до следующей, следующую порцию —
#     только ПОСЛЕ завершения тяжёлой команды).
# 💡 ВНИМАНИЕ:
# • Этот блок опциональный!
# • Его необходимо пропустить в случае:
# • 1. Если установка идёт в виртуальной среде (VirtualBox)
# • 2. Если решили установить видеодрайвера самостоятельно после установки системны
# • 3. Если установка будет по инструкции: "POST-INSTALL Arch Linux.txt"
# • 4. Пропустите его для старых и слабых компьютеров для офисной работы.
# ❗ Внимание: Настройки для ОДИНОЧНОЙ и ГИБРИДНОЙ графики кардинально
#    отличаются! Раскомментируйте (уберите #) ТОЛЬКО нужный сценарий.
#################################################################

clear
# 🎨 Цвета окон и рамок (безопасно задавать повторно в каждом блоке)
CN=$'\e[0m'; CB=$'\e[1;36m'; CW=$'\e[1;37m'; CG=$'\e[1;32m'; CY=$'\e[1;33m'; CR=$'\e[1;31m'; TB=$'\e[1;30;38;2;0;0;0;46m'; TG=$'\e[1;30;38;2;0;0;0;42m'; TY=$'\e[1;30;38;2;0;0;0;43m'

# #------------------------------------------------------------------------------
# ШАГ 1: БАЗОВЫЕ УТИЛИТЫ ДЛЯ ТЕСТИРОВАНИЯ ГРАФИКИ (ДЛЯ ВСЕХ СЦЕНАРИЕВ)
# #------------------------------------------------------------------------------
# 📦 vulkan-tools  : Утилита vulkaninfo для диагностики Vulkan.
# 📦 libva-utils    : Утилита vainfo для проверки видео-ускорения (VA-API).
# 📦 mesa-utils     : Утилита glxinfo для проверки OpenGL.
# 📦 mesa-demos     : Дополнительные утилиты (glxgears и др.) для проверки OpenGL.
# 📦 glmark2        : Бенчмарк производительности графики.
# 📦 nvtop          : Монитор GPU (как htop, но для видеокарт AMD/NVIDIA/Intel).
# 📦 vkd3d/lib32-vkd3d : Транслятор DirectX 12 в Vulkan (КРИТИЧЕСКИ ВАЖНО для игр через Proton/Steam!).

pacman -S --noconfirm vulkan-tools libva-utils mesa-utils mesa-demos glmark2 nvtop vkd3d lib32-vkd3d

# #------------------------------------------------------------------------------
# ШАГ 2: ВЫБОР СЦЕНАРИЯ ВИДЕО (ВЫПОЛНИТЬ ТОЛЬКО ОДИН ВАРИАНТ)
# #------------------------------------------------------------------------------
# 💡 ИНСТРУКЦИЯ:
# • Для одной видеокарты: выполните ТОЛЬКО один сценарий (А, Б или В).
# • Для гибридной (AMD iGPU + NVIDIA dGPU): выполните ШАГ 1 + Сценарий Г.
# • Удалите символ # только перед командами выбранного сценария.

# ==============================================================================
# >>> [СЦЕНАРИЙ А] INTEL (Встроенная графика) <<<
# ==============================================================================
# 📦 intel-media-driver : VA-API для аппаратного декодирования видео.
# 📦 vulkan-intel       : Драйвер Vulkan для Intel (критично для игр/Steam).
# 📦 lib32-vulkan-intel : 32-битная версия для поддержки Steam/Proton.
#
# pacman -S --noconfirm intel-media-driver vulkan-intel lib32-vulkan-intel


# ==============================================================================
# >>> [СЦЕНАРИЙ Б] AMD (Radeon / APU) <<<
# ==============================================================================
# 📦 vulkan-radeon       : Драйвер Vulkan для AMD (критично для игр/Steam).
# 📦 lib32-vulkan-radeon : 32-битная версия для поддержки Steam/Proton.
# 📦 corectrl            : Утилита для управления AMD GPU (разгон, профили, мониторинг).
#
# pacman -S --noconfirm vulkan-radeon lib32-vulkan-radeon corectrl


# ==============================================================================
# >>> [СЦЕНАРИЙ В] NVIDIA (ОДИНОЧНАЯ, ДЕСКТОП / ПК) <<<
# ==============================================================================
# ⚠️ Выполнять ТОЛЬКО если в системе одна видеокарта NVIDIA (без iGPU)!
# 📦 nvidia-open-dkms   : Проприетарный драйвер (максимальная стабильность).
# 📦 nvidia-utils       : Утилиты и библиотеки (включая VA-API).
# 📦 lib32-nvidia-utils : 32-битные библиотеки для игр (Steam/Proton).
# 📦 egl-wayland        : Библиотека EGL для Wayland (актуальная версия 1.1.x).
# 📦 egl-wayland2       : Библиотека EGL для Wayland (старая версия 1.0.x для совместимости).
# 📦 nvidia-settings    : Панель управления настройками GPU.
#
# pacman -S --noconfirm nvidia-open-dkms nvidia-utils lib32-nvidia-utils egl-wayland egl-wayland2 nvidia-settings
#
# 📋 1. Добавить параметр ядра nvidia-drm.modeset=1 в GRUB (обязательно для Wayland)
# sed -i -E 's/^(GRUB_CMDLINE_LINUX_DEFAULT="[^"]*)"/\1 nvidia-drm.modeset=1"/' /etc/default/grub
#
# 📋 2. Конфигурация модулей (modprobe) для сохранения VRAM при сне/гибернации
# echo "options nvidia-drm modeset=1" > /etc/modprobe.d/nvidia.conf
# echo "options nvidia NVreg_PreserveVideoMemoryAllocations=1" >> /etc/modprobe.d/nvidia.conf
# echo "options nvidia NVreg_TemporaryFilePath=/var/tmp" >> /etc/modprobe.d/nvidia.conf
#
# 📋 3. Включение системных служб управления сном/гибернацией (обязательно для ПК)
# systemctl enable nvidia-suspend.service nvidia-hibernate.service nvidia-resume.service
#
# 📋 4. Пересобрать initramfs и обновить GRUB
# mkinitcpio -P
# grub-mkconfig -o /boot/grub/grub.cfg


# ==============================================================================
# >>> [СЦЕНАРИЙ Г] ГИБРИДНАЯ ГРАФИКА (AMD/INTEL iGPU + NVIDIA dGPU) <<<
# ==============================================================================
# ⚠️ РЕКОМЕНДУЕМЫЙ СЦЕНАРИЙ ДЛЯ НОУТБУКОВ С ГИБРИДНОЙ ГРАФИКОЙ
# (Любая комбинация: AMD Radeon + NVIDIA, Intel Iris/UHD + NVIDIA)
# 📦 1. Установка драйверов NVIDIA и критически важных библиотек EGL для Wayland
# pacman -S --noconfirm nvidia-open-dkms nvidia-utils lib32-nvidia-utils egl-wayland egl-wayland2 nvidia-settings

# 📦 2. Установка инструмента управления питанием dGPU
# switcheroo-control (современный, интеграция в GUI, рекомендуется для Wayland)
# nvidia-prime (запуск через prime-run в терминале, раскомментируйте при необходимости)
# pacman -S --noconfirm switcheroo-control nvidia-prime

# 📋 3. Настройка параметров ядра (GRUB) – ОБЯЗАТЕЛЬНО ДЛЯ ГИБРИДА!
# Добавляем:
#   - nvidia-drm.modeset=1 (обязательно для Wayland и корректного переключения видеорежимов)
#   - nvidia.NVreg_PreserveVideoMemoryAllocations=0 (предотвращает kernel panic при пробуждении,
#     запрещая драйверу сохранять состояние VRAM, так как dGPU на ноутбуке обесточивается)
#   - resume_offset=0 (критически важен, если используется Swap-файл на BTRFS; безвреден для Swap-раздела)
# sed -i -E 's/^(GRUB_CMDLINE_LINUX_DEFAULT="[^"]*)"/\1 nvidia-drm.modeset=1 nvidia.NVreg_PreserveVideoMemoryAllocations=0 resume_offset=0"/' /etc/default/grub

# 📋 4. Пересборка initramfs и обновление GRUB
# mkinitcpio -P
# grub-mkconfig -o /boot/grub/grub.cfg

# 📋 5. Включение службы switcheroo-control для управления питанием дискретной графики
# systemctl enable switcheroo-control.service
# ==============================================================================

# #------------------------------------------------------------------------------
# ПРОВЕРКА РЕЗУЛЬТАТОВ
# #------------------------------------------------------------------------------
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
echo "${CG}╔══════════════════════════════════════════════════════════════════════════╗${CN}"
echo "${CG}║${TG} БЛОК 14 ЗАВЕРШЁН — ДРАЙВЕРЫ ВИДЕОКАРТ                                    ${CN}${CG}║${CN}"
echo "${CG}╟──────────────────────────────────────────────────────────────────────────╢${CN}"
echo "${CG}║${CW}  Все действия выполнены. НЕ ВЫХОДИТЕ из chroot!                          ${CN}${CG}║${CN}"
echo "${CG}║${CW}  Убедитесь, что все команды из выбранных шагов выполнены.                ${CN}${CG}║${CN}"
echo "${CG}║${CW}  Далее: БЛОК 15 (только VirtualBox) или БЛОК 16 (графическая             ${CN}${CG}║${CN}"
echo "${CG}║${CW}  среда).                                                                 ${CN}${CG}║${CN}"
echo "${CG}╚══════════════════════════════════════════════════════════════════════════╝${CN}"
echo "# ✅ ВСЕ ДЕЙСТВИЯ ВЫПОЛНЕНЫ.   "
echo "# ⚠️ НЕ ВЫХОДИТЕ из chroot!   "
echo "# 📌 Убедитесь, что все команды из выбранных шагов выполнены.   "
echo "# ➡️ ПРОДОЛЖИТЕ УСТАНОВКУ:   "
echo " "
#################################################################







#################################################################
# 🖥️  [CHROOT] БЛОК 15: УСТАНОВКА В VIRTUALBOX
#################################################################
# ℹ️ Зачем: Настройка интеграции с VirtualBox (гостевые дополнения).
# 💡 Включает: vboxguest, vboxsf, vboxvideo, общие папки.
# ❗ Важно: Выполняйте этот блок ТОЛЬКО если установка в VirtualBox!
# 📌 Переменная: Замените "forename" на имя вашего пользователя.
#################################################################
# #------------------------------------------------------------------------------
# ШАГ 1: УСТАНОВКА ПАКЕТОВ
# #------------------------------------------------------------------------------
# 📦 virtualbox-guest-utils — гостевые утилиты и драйверы VirtualBox.
pacman -S --noconfirm virtualbox-guest-utils
# #------------------------------------------------------------------------------
# ШАГ 2: НАСТРОЙКА МОДУЛЕЙ И СЛУЖБ
# #------------------------------------------------------------------------------
printf 'vboxguest\nvboxsf\n' > /etc/modules-load.d/virtualbox.conf
# #------------------------------------------------------------------------------
# ШАГ 3: НАСТРОЙКА ПОЛЬЗОВАТЕЛЯ
# #------------------------------------------------------------------------------
usermod -aG vboxsf forename
# #------------------------------------------------------------------------------
# ШАГ 4: ОБНОВЛЕНИЕ ЗАГРУЗЧИКА И INITRAMFS
# #------------------------------------------------------------------------------
# 📋 Обновление конфигурации GRUB.
grub-mkconfig -o /boot/grub/grub.cfg
# 📋 Пересборка initramfs.
mkinitcpio -P
# 🧹 Очистка экрана терминала
clear
#################################################################






#################################################################
# 🖥️  [CHROOT] БЛОК 16: УСТАНОВКА ГРАФИЧЕСКОЙ СРЕДЫ (DE/WM)
#################################################################
# ⏳ ОБЪЁМ БЛОКА 16: ~28 КБ ВСТАВКИ — на занятой ВМ вставляйте его ЧАСТЯМИ
#    (от одной границы «# #-----» до следующей, следующую порцию —
#     только ПОСЛЕ завершения тяжёлой команды).
# ℹ️ Зачем: Установка выбранного окружения рабочего стола.
# 💡 Включает: KDE Plasma, GNOME, XFCE4, MATE, Cinnamon, LXQT, LXDE.
# ❗ ВАЖНО: Убедитесь, что видеодрайверы установлены (БЛОК 12).
# ⚠️ КРИТИЧНО: Выберите и выполните ТОЛЬКО ОДИН вариант ниже!
# Установка нескольких сред может привести к конфликтам.
#################################################################
#
#################################################################
#  ## 🖥️ ВЫБЕРИТЕ ГРАФИЧЕСКУЮ СРЕДУ                   ##
#################################################################
#
#  Скопируйте и выполните команды ТОЛЬКО для одной среды:
#
#    [KDE]     — Современная, настраиваемая, Qt6
#    [GNOME]   — Минималистичная, GTK4, Wayland по умолчанию
#    [COSMIC]  — Современная, высокопроизводительная среда на Rust (Wayland)
#    [XFCE4]   — Легкая, стабильная, GTK3
#    [MATE]    — Классическая, форк GNOME 2
#    [CINNAMON]— Традиционная, GTK3, от Linux Mint
#    [LXQT]    — Очень легкая, Qt5/Qt6
#    [LXDE]    — Максимально легкая, GTK2
#################################################################


#################################################################
# 🌐 ВАРИАНТ: KDE PLASMA
#################################################################
# 💡 Рекомендуется для современных ПК и ноутбуков.
# 📦 Включает: Plasma, Dolphin, Konsole, Kate, SDDM.
# #------------------------------------------------------------------------------
# 🧹 Очистка экрана терминала
clear
pacman -S --noconfirm kde-system dolphin-plugins kate konsole gwenview elisa okular ark
# 📦 Кодеки, интеграция, порталы Wayland/XDG и поддержка Wayland для Qt
pacman -S --noconfirm ffmpegthumbs poppler-glib qt6-wayland
# 📦 GVFS для монтирования устройств и сетевых дисков (SMB/NFS/OneDrive/MTP)
# ❗ gvfs-google удалён, используйте gvfs-goa (настраивается в Параметрах)
pacman -S --noconfirm gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd
# 📦 Дисплейный менеджер SDDM
pacman -S --noconfirm sddm
systemctl enable sddm.service
# 🎨 Тема входа Breeze — без неё SDDM показывает блёклую maldives
mkdir -p /etc/sddm.conf.d
printf '[Theme]\nCurrent=breeze\n' > /etc/sddm.conf.d/10-theme.conf
# 🎨 Тема Plymouth Breeze вместо дефолтной bgrt (-R сразу пересоберёт initramfs)
plymouth-set-default-theme -R breeze
# 🖥️ Экран входа тоже в Wayland: композитор kwin_wayland вместо дефолтного weston.
#    Режим экспериментальный, Numlock в нём не настраивается. Чёрный экран на
#    NVIDIA (Сценарии В/Г) — удалите /etc/sddm.conf.d/10-wayland.conf (откат в X11).
cat > /etc/sddm.conf.d/10-wayland.conf << "EOF"
[General]
DisplayServer=wayland
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell

[Wayland]
CompositorCommand=kwin_wayland --drm --no-lockscreen --no-global-shortcuts --locale1
EOF
# 🎬 Пауза 2 с перед стартом SDDM: анимация Plymouth доигрывает, переход плавный
#    (проверка: systemctl status sddm → строка «Drop-In:»; sleep — под длину анимации)
mkdir -p /etc/systemd/system/sddm.service.d
printf '[Service]\nExecStartPre=/bin/sleep 2\n' > /etc/systemd/system/sddm.service.d/override.conf
# 📋 Обновление конфигурации
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
# 🧹 Очистка экрана терминала
clear
# 🚪 Выход из chroot
exit
#################################################################


#################################################################
# 🌐 ВАРИАНТ: GNOME
#################################################################
# 💡 Современная среда с упором на простоту и Wayland.
# 📦 Включает: GNOME Shell, Nautilus, GNOME Terminal, GDM.
# #------------------------------------------------------------------------------
# 🧹 Очистка экрана терминала
clear
# 📦 PackageKit (GTK), порталы и поддержка Wayland
pacman -S --noconfirm packagekit gnome-packagekit xdg-desktop-portal xdg-desktop-portal-gnome
# 📦 Мультимедиа: универсальный плеер и просмотрщик изображений
pacman -S --noconfirm mpv shotwell
# 📦 GVFS для монтирования устройств и сетевых дисков
pacman -S --noconfirm gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd
# 📦 Кодеки
pacman -S --noconfirm ffmpegthumbnailer poppler-glib
echo "[User]" > /var/lib/AccountsService/users/root
echo "SystemAccount=true" >> /var/lib/AccountsService/users/root
# 🎬 GDM сам плавно гасит Plymouth (двухстадийный переход из коробки) —
#    sleep-drop-in здесь НЕ нужен, он лишь искусственно удлинит загрузку.
# 📋 Обновление конфигурации
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
# 🧹 Очистка экрана терминала
clear
# 🚪 Выход из chroot
exit
#################################################################


#################################################################
# 🌌 ВАРИАНТ: COSMIC (System76)
#################################################################
# 💡 Современная, высокопроизводительная среда на Rust (Wayland).
# 📦 Включает: cosmic-comp (композитор), cosmic-files, cosmic-terminal,
# cosmic-settings, xdg-desktop-portal-cosmic и полный набор приложений.
# ❗ ВАЖНО:
# • COSMIC работает ТОЛЬКО в режиме Wayland (X11 не поддерживается).
# • Среда находится в стадии активной разработки.
# • Для видеокарт NVIDIA настоятельно рекомендуется использовать
#   проприетарные драйверы (nvidia-open-dkms) и свежие ядра для стабильной
#   работы Wayland-сессии. Убедитесь, что они установлены до этого шага.
# #------------------------------------------------------------------------------
# 🧹 Очистка экрана терминала
clear
# 📦 Установка полной группы пакетов COSMIC из официального репозитория [extra]
# 💡 Группа `cosmic` включает все основные компоненты, зависимости и порталы.
pacman -S --noconfirm cosmic
# 📦 Родной дисплейный менеджер cosmic-greeter (на базе greetd, рекомендовано Arch Wiki)
pacman -S --noconfirm cosmic-greeter
# ⚙️ Включение службы cosmic-greeter для автоматического запуска при загрузке
systemctl enable cosmic-greeter.service
# 📦 Хранилище ключей (рекомендовано Arch Wiki, так как COSMIC не имеет своего keyring)
pacman -S --noconfirm gnome-keyring
# 📦 GVFS для монтирования устройств и сетевых дисков (SMB/NFS/OneDrive/MTP)
pacman -S --noconfirm gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd
# 📦 Порталы Wayland/XDG, мультимедиа и просмотр изображений
pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-cosmic mpv shotwell
# 📦 Кодеки и миниатюры для файловых менеджеров
pacman -S --noconfirm ffmpegthumbnailer poppler-glib
# 🎬 Пауза 2 с перед стартом гритера: анимация Plymouth доигрывает, переход плавный
#    (проверка: systemctl status cosmic-greeter → строка «Drop-In:»; sleep — под длину анимации)
mkdir -p /etc/systemd/system/cosmic-greeter.service.d
printf '[Service]\nExecStartPre=/bin/sleep 2\n' > /etc/systemd/system/cosmic-greeter.service.d/override.conf
# 📋 Обновление конфигурации загрузчика и initramfs
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
# 🧹 Очистка экрана терминала
clear
# 🚪 Выход из chroot
exit
#################################################################


#################################################################
# 🪟 ВАРИАНТ: XFCE4
#################################################################
# 💡 Легкая и стабильная среда для слабых и средних ПК.
# 📦 Включает: XFCE4, Thunar, LightDM, утилиты.
# #------------------------------------------------------------------------------
# 🧹 Очистка экрана терминала
clear
# 🔐 Polkit-агент для GTK-окружений (обязателен для привилегированных GUI-операций: GParted, монтирование USB)
pacman -S --noconfirm polkit-gnome
# 📦 Сетевые апплеты
pacman -S --noconfirm network-manager-applet blueman
# 📦 Порталы Wayland/XDG, мультимедиа и просмотр изображений
pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-gtk mpv shotwell xdg-user-dirs
# 📦 Кодеки
pacman -S --noconfirm ffmpegthumbnailer poppler-glib
# 📦 GVFS для монтирования устройств и сетевых дисков
pacman -S --noconfirm gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd
# 📦 Дисплейный менеджер LightDM
pacman -S --noconfirm lightdm-gtk-greeter-settings
systemctl enable lightdm.service
# 🎬 Пауза 2 с перед стартом LightDM: анимация Plymouth доигрывает, переход плавный
#    (проверка: systemctl status lightdm → строка «Drop-In:»; sleep — под длину анимации)
mkdir -p /etc/systemd/system/lightdm.service.d
printf '[Service]\nExecStartPre=/bin/sleep 2\n' > /etc/systemd/system/lightdm.service.d/override.conf
# 📋 Обновление конфигурации
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
# 🧹 Очистка экрана терминала
clear
# 🚪 Выход из chroot
exit
#################################################################


#################################################################
# 🍃 ВАРИАНТ: MATE
#################################################################
# 💡 Классическая среда, форк GNOME 2.
# 📦 Включает: MATE, Caja, LightDM.
# #------------------------------------------------------------------------------
# 🧹 Очистка экрана терминала
clear
# 🔐 Polkit-агент для GTK-окружений (обязателен для привилегированных GUI-операций: GParted, монтирование USB)
pacman -S --noconfirm polkit-gnome
# 📦 Сетевые апплеты
pacman -S --noconfirm network-manager-applet blueman
# 📦 Порталы Wayland/XDG, мультимедиа и просмотр изображений
pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-gtk mpv shotwell
# 📦 Кодеки
pacman -S --noconfirm ffmpegthumbnailer poppler-glib
# 📦 GVFS для монтирования устройств и сетевых дисков
pacman -S --noconfirm gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd
# 📦 Дисплейный менеджер LightDM
pacman -S --noconfirm lightdm-gtk-greeter-settings
systemctl enable lightdm.service
# 🎬 Пауза 2 с перед стартом LightDM: анимация Plymouth доигрывает, переход плавный
#    (проверка: systemctl status lightdm → строка «Drop-In:»; sleep — под длину анимации)
mkdir -p /etc/systemd/system/lightdm.service.d
printf '[Service]\nExecStartPre=/bin/sleep 2\n' > /etc/systemd/system/lightdm.service.d/override.conf
# 📋 Обновление конфигурации
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
# 🧹 Очистка экрана терминала
clear
# 🚪 Выход из chroot
exit
#################################################################


#################################################################
# 🕯️ ВАРИАНТ: CINNAMON
#################################################################
# 💡 Традиционная среда от разработчиков Linux Mint.
# 📦 Включает: Cinnamon, Nemo, LightDM.
# #------------------------------------------------------------------------------
# 🧹 Очистка экрана терминала
clear
# 🔐 Polkit-агент для GTK-окружений (обязателен для привилегированных GUI-операций: GParted, монтирование USB)
pacman -S --noconfirm polkit-gnome
# 📦 Сетевые апплеты
pacman -S --noconfirm network-manager-applet blueman
# 📦 Порталы Wayland/XDG, мультимедиа и просмотр изображений
pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-gtk mpv shotwell
# 📦 Кодеки
pacman -S --noconfirm ffmpegthumbnailer poppler-glib
# 📦 GVFS для монтирования устройств и сетевых дисков
pacman -S --noconfirm gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd
# 📦 Дисплейный менеджер LightDM
pacman -S --noconfirm lightdm  lightdm-slick-greeter
systemctl enable lightdm.service
sed -i 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-slick-greeter/' /etc/lightdm/lightdm.conf
# 🎬 Пауза 2 с перед стартом LightDM: анимация Plymouth доигрывает, переход плавный
#    (проверка: systemctl status lightdm → строка «Drop-In:»; sleep — под длину анимации)
mkdir -p /etc/systemd/system/lightdm.service.d
printf '[Service]\nExecStartPre=/bin/sleep 2\n' > /etc/systemd/system/lightdm.service.d/override.conf
# 📋 Обновление конфигурации
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
# 🧹 Очистка экрана терминала
clear
# 🚪 Выход из chroot
exit
#################################################################


#################################################################
# 🧩 ВАРИАНТ: LXQT
#################################################################
# 💡 Очень легкая среда на базе Qt.
# 📦 Включает: LXQT, PCManFM-Qt, SDDM.
# #------------------------------------------------------------------------------
# 🧹 Очистка экрана терминала
clear
# 🔐 Polkit-агент для GTK-окружений (обязателен для привилегированных GUI-операций: GParted, монтирование USB)
pacman -S --noconfirm polkit-gnome
# 📦 Сетевые апплеты
pacman -S --noconfirm network-manager-applet blueman
# 📦 Порталы Wayland/XDG, мультимедиа и просмотр изображений
pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-gtk mpv shotwell
# 📦 Кодеки
pacman -S --noconfirm ffmpegthumbnailer poppler-glib
# 📦 GVFS для монтирования устройств и сетевых дисков
pacman -S --noconfirm gvfs gvfs-afc gvfs-dnssd gvfs-goa gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-onedrive gvfs-smb gvfs-wsdd
# 📦 Дисплейный менеджер SDDM
systemctl enable sddm.service
# 🎬 Пауза 2 с перед стартом SDDM: анимация Plymouth доигрывает, переход плавный
#    (проверка: systemctl status sddm → строка «Drop-In:»; sleep — под длину анимации)
mkdir -p /etc/systemd/system/sddm.service.d
printf '[Service]\nExecStartPre=/bin/sleep 2\n' > /etc/systemd/system/sddm.service.d/override.conf
# 📋 Обновление конфигурации
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
# 🧹 Очистка экрана терминала
clear
# 🚪 Выход из chroot
exit
#################################################################


#################################################################
# 🖼️ ВАРИАНТ: LXDE
#################################################################
# 💡 Максимально легкая среда для старых ПК.
# 📦 Включает: LXDE, Openbox, LightDM.
# #------------------------------------------------------------------------------
# 🧹 Очистка экрана терминала
clear
# 🔐 Polkit-агент для GTK-окружений (обязателен для привилегированных GUI-операций: GParted, монтирование USB)
pacman -S --noconfirm polkit-gnome
# 📦 Сетевые апплеты
pacman -S --noconfirm network-manager-applet blueman
# 📦 Порталы Wayland/XDG, мультимедиа и просмотр изображений
pacman -S --noconfirm xdg-desktop-portal xdg-desktop-portal-gtk mpv shotwell
# 📦 Кодеки и темы
pacman -S --noconfirm ffmpegthumbnailer poppler-glib gnome-themes-extra
# 📦 Дисплейный менеджер LightDM
pacman -S --noconfirm lightdm lightdm-slick-greeter
sed -i "s/#greeter-session=example-gtk-gnome/greeter-session=lightdm-slick-greeter/" /etc/lightdm/lightdm.conf
systemctl enable lightdm.service
# 🎬 Пауза 2 с перед стартом LightDM: анимация Plymouth доигрывает, переход плавный
#    (проверка: systemctl status lightdm → строка «Drop-In:»; sleep — под длину анимации)
mkdir -p /etc/systemd/system/lightdm.service.d
printf '[Service]\nExecStartPre=/bin/sleep 2\n' > /etc/systemd/system/lightdm.service.d/override.conf
# 📋 Обновление конфигурации
grub-mkconfig -o /boot/grub/grub.cfg
mkinitcpio -P
# 🧹 Очистка экрана терминала
clear
# 🚪 Выход из chroot
exit
#################################################################







#################################################################
# 🧹  [LIVE] БЛОК 17: ЗАВЕРШЕНИЕ УСТАНОВКИ
#################################################################
# ℹ️ Зачем: убрать за собой то, что создавалось только для установки,
#    отключить swap, размонтировать файловые системы и выключить ВМ.
# ❗ ПОРЯДОК КОМАНД ВАЖЕН: очистка ключей SSH выполняется ДО poweroff.
#    В исходном макете «rm -r .ssh/» стоял после poweroff и не выполнялся
#    НИКОГДА: ключи, созданные для Live-сессии, оставались в системе.
# 💡 Если umount сообщает «target is busy» — найдите процессы
#    (lsof +f -- /mnt) и повторите umount -R /mnt.
#################################################################
# #------------------------------------------------------------------------------
# ШАГ 1: ОЧИСТКА КЛЮЧЕЙ SSH СОЗДАНА ДЛЯ LIVE-СЕССИИ — УДАЛЯЕМ
# #------------------------------------------------------------------------------
# 🔑 ~/.ssh в Live-среде содержит authorized_keys, по которому вы заходили
#    по SSH во время установки. В установленной системе ему не место.
rm -rf ~/.ssh/
ls -la ~/.ssh 2>/dev/null || echo "ключи SSH удалены — каталога нет"
# #------------------------------------------------------------------------------
# ШАГ 2: ОТКЛЮЧЕНИЕ SWAP, РАЗМОНТИРОВАНИЕ И ВЫКЛЮЧЕНИЕ
# #------------------------------------------------------------------------------
echo "${CY}╔══════════════════════════════════════════════════════════════════════════╗${CN}"
echo "${CY}║${TY} ВНИМАНИЕ: КОМАНДЫ ЗАВЕРШЕНИЯ ВЫПОЛНЯЮТСЯ ПО ПОРЯДКУ                      ${CN}${CY}║${CN}"
echo "${CY}╟──────────────────────────────────────────────────────────────────────────╢${CN}"
echo "${CY}║${CW}  Сначала — очистка ключей SSH (rm -r ~/.ssh), и только ПОТОМ             ${CN}${CY}║${CN}"
echo "${CY}║${CW}  swapoff, umount и poweroff. В исходном макете очистка стояла            ${CN}${CY}║${CN}"
echo "${CY}║${CW}  после poweroff и не выполнялась никогда.                                ${CN}${CY}║${CN}"
echo "${CY}║${CW}  Если umount сообщает «target is busy» — закройте процессы:              ${CN}${CY}║${CN}"
echo "${CY}║${CW}  lsof +f -- /mnt, затем повторите umount -R /mnt.                        ${CN}${CY}║${CN}"
echo "${CY}╚══════════════════════════════════════════════════════════════════════════╝${CN}"
# 📋 Сначала swapoff: пока swap активен, umount раздела под него не пройдёт.
swapoff -a
umount -R /mnt
echo "${CG}╔══════════════════════════════════════════════════════════════════════════╗${CN}"
echo "${CG}║${TG} БЛОК 17 ЗАВЕРШЁН — УСТАНОВКА ЗАКОНЧЕНА                                   ${CN}${CG}║${CN}"
echo "${CG}╟──────────────────────────────────────────────────────────────────────────╢${CN}"
echo "${CG}║${CW}  Что сделано: ключи SSH, созданные для Live-сессии, удалены,             ${CN}${CG}║${CN}"
echo "${CG}║${CW}  swap отключён, файловые системы размонтированы. Следующая               ${CN}${CG}║${CN}"
echo "${CG}║${CW}  команда — poweroff; после неё не выполняется уже ничего.                ${CN}${CG}║${CN}"
echo "${CG}║${CW}  Далее: извлеките установочный носитель, включите компьютер              ${CN}${CG}║${CN}"
echo "${CG}║${CW}  и загрузитесь в новую систему. Первая загрузка идёт БЕЗ                 ${CN}${CG}║${CN}"
echo "${CG}║${CW}  «quiet splash» — лог виден, причину сбоя не скрывает заставка.          ${CN}${CG}║${CN}"
echo "${CG}║${CW}  После успешного входа — БЛОК 18 (он в конце этого файла).               ${CN}${CG}║${CN}"
echo "${CG}╚══════════════════════════════════════════════════════════════════════════╝${CN}"
# ❗ После poweroff не выполняется уже ничего — поэтому все окна и проверки
#    этого блока стоят ВЫШЕ.
poweroff
#################################################################






#################################################################
# 🏁  [SYSTEM] БЛОК 18: ПОСЛЕ ПЕРВОЙ УСПЕШНОЙ ЗАГРУЗКИ
#################################################################
# ℹ️ Зачем: то, что нельзя или не нужно делать из chroot и до первой загрузки.
# ❗ Выполняется в УЖЕ ЗАГРУЖЕННОЙ системе, от обычного пользователя (sudo).
# 💡 Первая загрузка намеренно идёт БЕЗ «quiet splash»: если что-то пошло не
#    так, причину видно в логе, а не за заставкой plymouth.
#################################################################
# 🧹 Очистка экрана терминала
clear
# 🎨 Цвета окон и рамок (безопасно задавать повторно в каждом блоке)
CN=$'\e[0m'; CB=$'\e[1;36m'; CW=$'\e[1;37m'; CG=$'\e[1;32m'; CY=$'\e[1;33m'; CR=$'\e[1;31m'; TB=$'\e[1;30;38;2;0;0;0;46m'; TG=$'\e[1;30;38;2;0;0;0;42m'; TY=$'\e[1;30;38;2;0;0;0;43m'
# #------------------------------------------------------------------------------
# ШАГ 1: ДИАГНОСТИКА SYSTEMD
# #------------------------------------------------------------------------------
echo "${CB}╔══════════════════════════════════════════════════════════════════════════╗${CN}"
echo "${CB}║${TB} ПРОВЕРКА 1/7: ЗДОРОВЬЕ СИСТЕМЫ                                           ${CN}${CB}║${CN}"
echo "${CB}╟──────────────────────────────────────────────────────────────────────────╢${CN}"
echo "${CB}║${CW}  Ожидается: «0 loaded units listed» — ни одна служба не упала.           ${CN}${CB}║${CN}"
echo "${CB}║${CW}  Если список не пуст, смотрите причину: systemctl status <служба>        ${CN}${CB}║${CN}"
echo "${CB}║${CW}  и journalctl -b -p err. Не переходите дальше, пока не поняли ошибку.    ${CN}${CB}║${CN}"
echo "${CB}╚══════════════════════════════════════════════════════════════════════════╝${CN}"
sudo systemctl --failed
sudo journalctl -b -p err --no-pager | tail -20
# #------------------------------------------------------------------------------
# ШАГ 2: ПРОВЕРКА ТОГО, ЧТО СОЗДАНО ПРИ УСТАНОВКЕ
# #------------------------------------------------------------------------------
echo "${CB}╔══════════════════════════════════════════════════════════════════════════╗${CN}"
echo "${CB}║${TB} ПРОВЕРКА 2/7: МОНТИРОВАНИЕ КОРНЯ И ПОДТОМОВ                              ${CN}${CB}║${CN}"
echo "${CB}╟──────────────────────────────────────────────────────────────────────────╢${CN}"
echo "${CB}║${CW}  Ожидается: / — btrfs с subvol=/@; /home, /var/log и                     ${CN}${CB}║${CN}"
echo "${CB}║${CW}  /var/cache/pacman/pkg — подтома того же устройства; /boot —             ${CN}${CB}║${CN}"
echo "${CB}║${CW}  отдельный раздел.                                                       ${CN}${CB}║${CN}"
echo "${CB}║${CW}  Корень должен быть смонтирован ИМЕННО подтомом @: подтом по             ${CN}${CB}║${CN}"
echo "${CB}║${CW}  умолчанию не менялся намеренно (иначе откат в btrfs-assistant           ${CN}${CB}║${CN}"
echo "${CB}║${CW}  оставил бы систему загруженной из backup-копии).                        ${CN}${CB}║${CN}"
echo "${CB}╚══════════════════════════════════════════════════════════════════════════╝${CN}"
findmnt /
findmnt -R / | head -30
sudo btrfs subvolume list / | head -20
echo "${CB}╔══════════════════════════════════════════════════════════════════════════╗${CN}"
echo "${CB}║${TB} ПРОВЕРКА 3/7: SWAP И ГИБЕРНАЦИЯ                                          ${CN}${CB}║${CN}"
echo "${CB}╟──────────────────────────────────────────────────────────────────────────╢${CN}"
echo "${CB}║${CW}  Ожидается: одна строка swap (раздел или lv_swap) ненулевого размера     ${CN}${CB}║${CN}"
echo "${CB}║${CW}  и resume=UUID=… в параметрах ядра.                                      ${CN}${CB}║${CN}"
echo "${CB}║${CW}  Без swap гибернация невозможна; без resume=… система не попытается      ${CN}${CB}║${CN}"
echo "${CB}║${CW}  восстановиться, даже если swap есть.                                    ${CN}${CB}║${CN}"
echo "${CB}╚══════════════════════════════════════════════════════════════════════════╝${CN}"
swapon --show
cat /proc/cmdline
echo "${CB}╔══════════════════════════════════════════════════════════════════════════╗${CN}"
echo "${CB}║${TB} ПРОВЕРКА 4/7: ТАЙМЕРЫ И СЛУЖБЫ                                           ${CN}${CB}║${CN}"
echo "${CB}╟──────────────────────────────────────────────────────────────────────────╢${CN}"
echo "${CB}║${CW}  Ожидается: в списке active есть fstrim.timer, reflector.timer,          ${CN}${CB}║${CN}"
echo "${CB}║${CW}  paccache.timer и grub-btrfsd.service.                                   ${CN}${CB}║${CN}"
echo "${CB}║${CW}  fstrim.timer — страховка на случай, если токен «defaults» оставлен      ${CN}${CB}║${CN}"
echo "${CB}║${CW}  как есть: без него и без discard=async TRIM не выполняется вовсе.       ${CN}${CB}║${CN}"
echo "${CB}╚══════════════════════════════════════════════════════════════════════════╝${CN}"
systemctl list-timers --all | head -15
systemctl is-enabled fstrim.timer reflector.timer paccache.timer
systemctl is-active grub-btrfsd.service
echo "${CB}╔══════════════════════════════════════════════════════════════════════════╗${CN}"
echo "${CB}║${TB} ПРОВЕРКА 5/7: МЕЖСЕТЕВОЙ ЭКРАН NFTABLES                                  ${CN}${CB}║${CN}"
echo "${CB}╟──────────────────────────────────────────────────────────────────────────╢${CN}"
echo "${CB}║${CW}  Ожидается: ruleset с таблицей inet arch_install и политикой drop        ${CN}${CB}║${CN}"
echo "${CB}║${CW}  на вход. Правила были включены в БЛОКЕ 13, но не применялись из         ${CN}${CB}║${CN}"
echo "${CB}║${CW}  chroot — теперь они в силе.                                             ${CN}${CB}║${CN}"
echo "${CB}║${CW}  Если ruleset пуст: sudo systemctl restart nftables и посмотрите         ${CN}${CB}║${CN}"
echo "${CB}║${CW}  journalctl -u nftables.                                                 ${CN}${CB}║${CN}"
echo "${CB}╚══════════════════════════════════════════════════════════════════════════╝${CN}"
sudo nft list ruleset | head -30
sudo systemctl is-active nftables.service
# #------------------------------------------------------------------------------
# ШАГ 3: ПЕРВОЕ ПОЛНОЕ ОБНОВЛЕНИЕ
# #------------------------------------------------------------------------------
# ❗ Первое обновление делается ПОСЛЕ загрузки, а не из chroot: так видно
#    ошибки, и система не остаётся в частично обновлённом состоянии.
sudo pacman -Syu
# #------------------------------------------------------------------------------
# ШАГ 4: SNAPPER И СНИМКИ
# #------------------------------------------------------------------------------
echo "${CY}╔══════════════════════════════════════════════════════════════════════════╗${CN}"
echo "${CY}║${TY} ДЕЙСТВИЕ: НАСТРОЙКА SNAPPER                                              ${CN}${CY}║${CN}"
echo "${CY}╟──────────────────────────────────────────────────────────────────────────╢${CN}"
echo "${CY}║${CW}  Команда snapper create-config создаёт /.snapshots и подтом снимков.     ${CN}${CY}║${CN}"
echo "${CY}║${CW}  Конфигурация берётся из /etc/snapper/config-templates/default.          ${CN}${CY}║${CN}"
echo "${CY}║${CW}  После настройки сделайте первый снимок и убедитесь, что он появился     ${CN}${CY}║${CN}"
echo "${CY}║${CW}  в меню GRUB — это делает grub-btrfsd.                                   ${CN}${CY}║${CN}"
echo "${CY}╚══════════════════════════════════════════════════════════════════════════╝${CN}"
sudo snapper create-config /
sudo snapper -c root create --description "после установки"
sudo snapper -c root list
echo "${CB}╔══════════════════════════════════════════════════════════════════════════╗${CN}"
echo "${CB}║${TB} ПРОВЕРКА 6/7: СНИМКИ ПОПАДАЮТ В МЕНЮ GRUB                                ${CN}${CB}║${CN}"
echo "${CB}╟──────────────────────────────────────────────────────────────────────────╢${CN}"
echo "${CB}║${CW}  Ожидается: снимок виден в списке snapper, а в /boot/grub/ появляется    ${CN}${CB}║${CN}"
echo "${CB}║${CW}  подменю «Arch Linux snapshots» после обновления меню.                   ${CN}${CB}║${CN}"
echo "${CB}║${CW}  grub-btrfsd.service следит за /.snapshots через inotify и обновляет     ${CN}${CB}║${CN}"
echo "${CB}║${CW}  меню сам; вручную — sudo grub-mkconfig -o /boot/grub/grub.cfg.          ${CN}${CB}║${CN}"
echo "${CB}║${CW}  Важно: снимки btrfs — НЕ резервная копия, они лежат на том же диске.    ${CN}${CB}║${CN}"
echo "${CB}╚══════════════════════════════════════════════════════════════════════════╝${CN}"
ls -1 /.snapshots/ 2>/dev/null | head
grep -c "Arch Linux snapshots\|snapshot" /boot/grub/grub.cfg || true
# #------------------------------------------------------------------------------
# ШАГ 5: ТИХАЯ ЗАГРУЗКА
# #------------------------------------------------------------------------------
# 📋 Теперь, когда система успешно загрузилась, можно включить тихую
#    загрузку. До этого шага «quiet splash» не включался намеренно.
echo "${CY}╔══════════════════════════════════════════════════════════════════════════╗${CN}"
echo "${CY}║${TY} ДЕЙСТВИЕ: ВКЛЮЧЕНИЕ ТИХОЙ ЗАГРУЗКИ                                       ${CN}${CY}║${CN}"
echo "${CY}╟──────────────────────────────────────────────────────────────────────────╢${CN}"
echo "${CY}║${CW}  Команды добавляют quiet splash в параметры ядра и пересобирают меню     ${CN}${CY}║${CN}"
echo "${CY}║${CW}  GRUB. После этого первая загрузка с логом заменяется заставкой plymouth.${CN}${CY}║${CN}"
echo "${CY}║${CW}  Если что-то пойдёт не так, уберите quiet splash тем же sed и выполните  ${CN}${CY}║${CN}"
echo "${CY}║${CW}  grub-mkconfig — лог вернётся.                                           ${CN}${CY}║${CN}"
echo "${CY}╚══════════════════════════════════════════════════════════════════════════╝${CN}"
sudo sed -i 's|^GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 |GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet splash |' /etc/default/grub
# 🔍 Обязательная проверка: «quiet splash» должен появиться в строке.
#    Если его нет — подстановка не сработала, тихая загрузка не включилась.
grep '^GRUB_CMDLINE_LINUX_DEFAULT' /etc/default/grub
sudo grub-mkconfig -o /boot/grub/grub.cfg
# 🔍 И вторая проверка — в самом меню: GRUB читает /boot/grub/grub.cfg,
#    а не /etc/default/grub. «quiet splash» обязан попасть в строку linux.
grep -m1 "quiet splash" /boot/grub/grub.cfg || echo "❗ «quiet splash» НЕ попал в grub.cfg — проверьте /etc/default/grub и повторите grub-mkconfig"
echo "${CG}╔══════════════════════════════════════════════════════════════════════════╗${CN}"
echo "${CG}║${TG} БЛОК 18 ЗАВЕРШЁН — СИСТЕМА ПРОВЕРЕНА ПОСЛЕ ЗАГРУЗКИ                      ${CN}${CG}║${CN}"
echo "${CG}╟──────────────────────────────────────────────────────────────────────────╢${CN}"
echo "${CG}║${CW}  Что сделано: диагностика systemd, проверка подтомов, swap и resume,     ${CN}${CG}║${CN}"
echo "${CG}║${CW}  таймеров, nftables и snapper; первое полное обновление; включена        ${CN}${CG}║${CN}"
echo "${CG}║${CW}  тихая загрузка.                                                         ${CN}${CG}║${CN}"
echo "${CG}║${CW}  Далее: sudo reboot — и система загружается с заставкой plymouth.        ${CN}${CG}║${CN}"
echo "${CG}║${CW}  ПОСЛЕ перезагрузки выполните следующий шаг (он ниже): одна команда      ${CN}${CG}║${CN}"
echo "${CG}║${CW}  подтверждает, что лог действительно погас, а заставка действительно     ${CN}${CG}║${CN}"
echo "${CG}║${CW}  запускалась. Без неё «тихая загрузка включена» остаётся обещанием.      ${CN}${CG}║${CN}"
echo "${CG}║${CW}  Добро пожаловать в Arch Linux!                                          ${CN}${CG}║${CN}"
echo "${CG}╚══════════════════════════════════════════════════════════════════════════╝${CN}"
# #------------------------------------------------------------------------------
# ШАГ 6: ПОСЛЕ ПЕРЕЗАГРУЗКИ — КОМАНДА ПРОВЕРКИ ТИХОЙ ЗАГРУЗКИ
# #------------------------------------------------------------------------------
# 📋 КОГДА ВЫПОЛНЯТЬ: после sudo reboot, в УЖЕ ЗАГРУЖЕННОЙ системе.
#    Это не продолжение вставки БЛОКА 18 — команды копируют отдельной
#    порцией, когда машина загрузилась снова.
# ❗ ЗАЧЕМ ЭТОТ ШАГ НУЖЕН (разъяснение для тех, кто будет править макет):
#    Предыдущий шаг проверяет ФАЙЛЫ: /etc/default/grub (источник) и
#    /boot/grub/grub.cfg (то, что читает GRUB). Но правильный файл НЕ
#    означает правильную загрузку. Между ними ещё три места, где всё
#    может разойтись молча:
#      • GRUB загрузил не ту запись (резервное ядро, пункт снимка) —
#        параметры из GRUB_CMDLINE_LINUX_DEFAULT в неё не попали;
#      • параметры до ядра не дошли — тогда лог снова бежит по экрану;
#      • plymouth не стартовал, хотя хук в initramfs есть (конфиг не
#        пересобран, ShowDelay=5 — заставка не успевает появиться).
#    На глаз после загрузки это не выяснить: экран уже погас. Поэтому
#    спрашивают РАБОТАЮЩУЮ систему: /proc/cmdline показывает, что ядру
#    ДЕЙСТВИТЕЛЬНО передал загрузчик, а journalctl -b — что ДЕЙСТВИТЕЛЬНО
#    делал plymouth в этой загрузке. Это единственный источник правды,
#    и до перезагрузки он не существует.
echo "${CB}╔══════════════════════════════════════════════════════════════════════════╗${CN}"
echo "${CB}║${TB} ПРОВЕРКА 7/7: ТИХАЯ ЗАГРУЗКА РАБОТАЕТ ПОСЛЕ ПЕРЕЗАГРУЗКИ                 ${CN}${CB}║${CN}"
echo "${CB}╟──────────────────────────────────────────────────────────────────────────╢${CN}"
echo "${CB}║${CW}  Ожидается: в /proc/cmdline видны quiet и splash, вердикт печатает       ${CN}${CB}║${CN}"
echo "${CB}║${CW}  «ТИХАЯ ЗАГРУЗКА РАБОТАЕТ»; в журнале этой загрузки есть строки          ${CN}${CB}║${CN}"
echo "${CB}║${CW}  plymouth («Show Plymouth Boot Screen»); тема заставки — bgrt.           ${CN}${CB}║${CN}"
echo "${CB}║${CW}  Логотипа в VirtualBox не будет: тема bgrt берёт картинку из таблицы     ${CN}${CB}║${CN}"
echo "${CB}║${CW}  ACPI BGRT, а виртуальная прошивка её не предоставляет — plymouth        ${CN}${CB}║${CN}"
echo "${CB}║${CW}  рисует только анимацию. Критерий успеха — НЕ логотип, а отсутствие      ${CN}${CB}║${CN}"
echo "${CB}║${CW}  бегущего лога ядра.                                                     ${CN}${CB}║${CN}"
echo "${CB}╚══════════════════════════════════════════════════════════════════════════╝${CN}"
# 📌 ГЛАВНАЯ КОМАНДА ШАГА: что загрузчик ДЕЙСТВИТЕЛЬНО передал ядру.
#    До перезагрузки этот вопрос задать нельзя — файла с ответом нет.
cat /proc/cmdline
# 🔍 Вердикт одной строкой. quiet гасит лог ядра, splash разрешает
#    заставку plymouth — нужны ОБА параметра, поэтому проверяются оба.
grep -qw quiet /proc/cmdline && grep -qw splash /proc/cmdline && echo "✅ ТИХАЯ ЗАГРУЗКА РАБОТАЕТ: ядро получило quiet splash" || echo "❗ Ядро запущено БЕЗ quiet splash — лог будет виден. Порядок действий — в комментариях ниже"
# 📋 Вторая половина вопроса — заставка. Параметры в cmdline ещё не
#    означают, что plymouth стартовал: хук мог не попасть в initramfs,
#    а ShowDelay=5 (заводское значение) — не дать заставке появиться на
#    быстрой загрузке. Факт запуска виден в журнале ЭТОЙ загрузки (-b).
sudo journalctl -b --no-pager | grep -i -m5 plymouth || echo "❗ В журнале этой загрузки нет ни одной строки plymouth — заставка не запускалась (порядок действий — в комментариях ниже)"
# 📋 Тема заставки (ожидается bgrt) и её конфиг: ShowDelay=0 обязателен,
#    иначе plymouth ждёт 5 секунд и на быстрой загрузке не появляется
#    вовсе — именно так это выглядело как «plymouth вообще не работает».
plymouth-set-default-theme
cat /etc/plymouth/plymouthd.conf
# 📋 Логотип темы bgrt берётся из таблицы ACPI BGRT, которую отдаёт
#    прошивка. В VirtualBox её нет — файл отсутствует, и это НЕ поломка:
#    будет только анимация (см. окно выше). На реальном UEFI-ПК здесь
#    появится путь к логотипу производителя.
ls /sys/firmware/acpi/bgrt/image 2>/dev/null || echo "ℹ️ BGRT нет: прошивка не отдаёт логотип, заставка будет только с анимацией (норма для ВМ)"
# 🩹 ЕСЛИ ЛОГ ВСЁ ЕЩЁ БЕЖИТ ИЛИ ЗАСТАВКИ НЕТ — проверяйте по порядку:
#    1. grep -m1 "quiet splash" /boot/grub/grub.cfg
#       Пусто → меню не пересобрано: повторите предыдущий шаг (sed +
#       grub-mkconfig) и перезагрузитесь снова.
#    2. В grub.cfg строка есть, а в /proc/cmdline параметров нет →
#       GRUB загрузил не ту запись. Перезагрузитесь и выберите обычный
#       пункт меню (не резервное ядро и не пункт снимка).
#    3. quiet splash в /proc/cmdline есть, а plymouth в журнале нет →
#       заставки нет в initramfs:
#         sudo lsinitcpio /boot/initramfs-linux-lts.img | grep -i plymouth
#       Пусто → пересоберите образ (sudo mkinitcpio -P) и перезагрузитесь.
#    4. plymouth в журнале есть, а заставки на экране не было → проверьте
#       ShowDelay=0 в /etc/plymouth/plymouthd.conf и ПЕРЕСОБЕРИТЕ образ:
#       конфиг запекается внутрь initramfs, правка без mkinitcpio -P не
#       действует (поэтому шаг PLYMOUTH в БЛОКЕ 12 стоит ДО пересборки).
# 🩹 ОТКАТ К ПОДРОБНОМУ ЛОГУ (эталонный способ «если что-то пошло не так»):
#      sudo sed -i 's/ quiet splash//' /etc/default/grub
#      sudo grub-mkconfig -o /boot/grub/grub.cfg
#      sudo reboot
#    Лог вернётся — причину сбоя снова будет видно. Это не потеря данных:
#    правятся только параметры ядра в меню GRUB.
