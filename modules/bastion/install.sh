# Install WireGuard
sudo modprobe wireguard
sudo yum install "@Development Tools"
sudo yum groupinstall "Development Tools"
git clone https://git.zx2c4.com/wireguard-tools
make -C wireguard-tools/src -j$(nproc)

# Setup
wg genkey > server.key
wg pubkey < server.key > server.pub

sudo systemctl enable wg-quick@wg0.service
sudo systemctl start wg-quick@wg0.service
