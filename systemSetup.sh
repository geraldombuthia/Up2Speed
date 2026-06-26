#!/bin/bash
set -e
echo "--------Install dependencies--------"

echo "Updating package lists and installing dependencies..."
sudo apt update
sudo apt install -y zsh python3-venv dfu-util build-essential git cmake ninja-build picocom gcc-arm-none-eabi gdb-multiarch binutils-arm-none-eabi stlink-tools

git config --global user.name "Gerald Mbuthia"
git config --global user.email "geraldombuthia@gmail.com"

echo "--------Check dependencies--------"
git --version
echo -e "\e[32m[Found]\e[0m git: $(git --version)"

for cmd in gcc make cmake picocom arm-none-eabi-gcc st-info dfu-util git; do
    if command -v $cmd &> /dev/null; then
        echo -e "\e[32m[Found]\e[0m $cmd: $($cmd --version | head -n 1)"
    else
        echo -e "\e[31m[Missing]\e[0m $cmd"
    fi
done

echo "--------Setup permissions--------"
sudo usermod -aG dialout $USER

echo "--------Install Docker--------"
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)

# Add Docker's official GPG key:
sudo apt update
sudo apt install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo -e "\e[32m[Found]\e[0m docker: $(sudo systemctl status docker)"

echo "--------Check Docker--------"
sudo usermod -aG docker $USER

OUTPUT=$(sudo docker run --rm hello-world 2>&1)
EXIT_CODE=$?
 
echo "$OUTPUT"
 
if [ $EXIT_CODE -eq 0 ] && echo "$OUTPUT" | grep -q "Hello from Docker!"; then
    echo ""
    echo "Docker hello-world ran successfully."
else
    echo ""
    echo "Docker hello-world failed or produced unexpected output (exit code: $EXIT_CODE)."
    exit 1
fi


echo "--------Install mbed-tools--------"
rm -rf ~/mbed-venv
python3 -m venv ~/mbed-venv
source ~/mbed-venv/bin/activate
~/mbed-venv/bin/python3 -m pip install --upgrade pip setuptools wheel
~/mbed-venv/bin/python3 -m pip install mbed-tools # 

echo -e "\e[32m[Found]\e[0m mbed-tools: $(mbed-tools --version)"
if ! grep -q "alias mbed-tools" ~/.bashrc; then
    echo "alias mbed-tools='~/mbed-venv/bin/mbed-tools'" >> ~/.bashrc
fi
alias mbed-tools='~/mbed-venv/bin/mbed-tools'
echo -e "\e[32m[Success]\e[0m $(mbed-tools --version) installed and aliased as 'mbed-tools'"

# --- 6. Final Status ---
echo "------------------------------------------------"
echo -e "\e[33m[IMPORTANT]\e[0m Groups updated: $(groups)"
echo -e "\e[33m[ACTION REQUIRED]\e[0m Please REBOOT or LOG OUT to finalize Docker/Dialout permissions."
echo "------------------------------------------------"


