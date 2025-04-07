#!/bin/bash

mkdir /var/pangolin
cd /var/pangolin

wget -O dyndns.bash "https://raw.githubusercontent.com/HPPinata/Notizen/refs/heads/main/pangolin/dyndns.bash" && chmod +x ./dyndns.bash
wget -O installer "https://github.com/fosrl/pangolin/releases/latest/download/installer_linux_$(uname -m | sed 's/x86_64/amd64/;s/aarch64/arm64/')" && chmod +x ./installer

read -p "DynDNS Domain: " ZONE
read -p "Auth Token: " TK

./dyndns.bash
./installer

sed -i 's+image: fosrl/pangolin:.*+image: fosrl/pangolin:latest+g' docker-compose.yml
sed -i 's+image: fosrl/gerbil:.*+image: fosrl/gerbil:latest+g' docker-compose.yml
sed -i 's+image: traefik:.*+image: traefik:v3+g' docker-compose.yml

cat <<'EOL' > update.bash
#!/bin/bash
cd /var/pangolin
docker compose pull
docker compose build --pull
docker compose up -d
docker system prune -a -f
EOL
cat update.bash
chmod +x update.bash

cat <<EOL | crontab -
SHELL=/bin/bash
BASH_ENV=/etc/profile

*/1 * * * * ZONE=( $ZONE ) TK=$TK /var/pangolin/dyndns.bash
@reboot /var/pangolin/update.bash
EOL
crontab -l
