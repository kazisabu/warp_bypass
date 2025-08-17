#!/bin/bash
set -euo pipefail
mapfile -t DEB_FILES < <(ls *.deb 2>/dev/null || true)
if [[ ${#DEB_FILES[@]} -eq 0 ]]; then
    echo "[!] No .deb package found in current directory"
    exit 1
elif [[ ${#DEB_FILES[@]} -eq 1 ]]; then
    DEB_PKG="${DEB_FILES[0]}"
    echo "[*] Using package: $DEB_PKG"
else
    echo "[*] Multiple .deb files found:"
    select choice in "${DEB_FILES[@]}"; do
        if [[ -n "$choice" ]]; then
            DEB_PKG="$choice"
            break
        fi
    done
fi
TMP_USER="warpuser_$RANDOM"
WARP_BIN="/opt/warpdotdev/warp-terminal/warp"
SUDOERS_FILE="/etc/sudoers.d/$TMP_USER"
DISPLAY_NUM="${DISPLAY:-:0}"
if [[ $EUID -ne 0 ]]; then
    echo "[!] Run as root"
    exit 1
fi
for cmd in xhost macchanger; do
    if ! command -v $cmd &>/dev/null; then
        echo "[!] Missing dependency: $cmd"
        exit 1
    fi
done
HAS_DHCLIENT=false
if command -v dhclient &>/dev/null; then
    HAS_DHCLIENT=true
fi

if [[ ! -f "$DEB_PKG" ]]; then
    echo "[!] Warp package '$DEB_PKG' not found"
    exit 1
fi
echo "[*] Creating temp user: $TMP_USER"
useradd -m -s /bin/bash "$TMP_USER"
echo "$TMP_USER ALL=(ALL) NOPASSWD:ALL" > "$SUDOERS_FILE"
chmod 440 "$SUDOERS_FILE"
if ! dpkg -l | grep -q warp-terminal; then
    echo "[*] Installing Warp from $DEB_PKG"
    apt install -y "./$DEB_PKG"
fi

if [[ ! -x "$WARP_BIN" ]]; then
    echo "[!] Warp binary not found or not executable at $WARP_BIN"
    exit 127
fi
echo "[*] Blocking telemetry domains..."
tee -a /etc/hosts >/dev/null <<EOF
0.0.0.0 telemetry.warp.dev
0.0.0.0 events.warp.dev
0.0.0.0 rudderstack.warp.dev
EOF
IFACE=$(ip route | grep '^default' | awk '{print $5}' | head -n1)
if [[ -n "$IFACE" ]]; then
    echo "[*] Randomizing MAC on $IFACE"
    ip link set "$IFACE" down
    macchanger -r "$IFACE" >/dev/null
    ip link set "$IFACE" up
    if $HAS_DHCLIENT; then
        echo "[*] Renewing DHCP lease"
        dhclient "$IFACE" -r >/dev/null 2>&1 || true
        dhclient "$IFACE" >/dev/null 2>&1
    else
        echo "[!] dhclient not found — skipping DHCP renewal"
    fi
fi
echo "[*] Granting X11 access to $TMP_USER"
xhost +SI:localuser:$TMP_USER
cleanup() {
    echo "[*] Warp closed. Cleaning up..."
    xhost -SI:localuser:$TMP_USER
    pkill -u "$TMP_USER" &>/dev/null || true
    userdel -r "$TMP_USER" &>/dev/null || true
    rm -f "$SUDOERS_FILE"
    echo "[*] Done. Temp user and data wiped."
}
trap cleanup EXIT
echo "[*] Launching Warp as $TMP_USER..."
sudo -u "$TMP_USER" env DISPLAY=$DISPLAY_NUM XAUTHORITY=/home/$TMP_USER/.Xauthority "$WARP_BIN"
