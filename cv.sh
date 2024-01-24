#!/bin/bash

sudo apt update
sudo apt autoremove -y

# Basic tools
sudo apt install git byobu magic-wormhole openssh-server supervisor vlc python3-pip htop neovim curl hddtemp xsensors flameshot cpufrequtils indicator-cpufreq gparted expect -y
sudo prime-select nvidia

# AWS-cli
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# sudo ./aws/install
# rm -rf ./aws awscliv2.zip

# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh
sudo usermod -aG docker $(whoami)

# Docker-Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


# Nvidia-Container Toolkit
get_os_lts_version () {
    if [[ $(. /etc/os-release;echo $ID) == "ubuntu" ]]; then    # If an official ubuntu flavour
        version_id=$(. /etc/os-release;echo $VERSION_ID)
        if [[ ${version_id} == "18.10" || ${version_id} == "19.04" || ${version_id} == "19.10" ]]; then
            echo "18.04"
        elif [[ ${version_id} == "20.10" || ${version_id} == "21.04" || ${version_id} == "21.10" ]]; then
            echo "20.04"
        elif [[ ${version_id} == "22.10" || ${version_id} == "23.04" || ${version_id} == "23.10" ]]; then
            echo "22.04"
        elif [[ ${version_id} == "24.10" || ${version_id} == "25.04" || ${version_id} == "25.10" ]]; then
            echo "24.04"
        else
            # Already an LTS version, use as is.
            echo ${version_id}
        fi
    else                                                        # If an unofficial ubuntu flavour, like Zorin/Pop/...
        ubuntu_codename=$(. /etc/os-release;echo $UBUNTU_CODENAME)
        if [[ ${ubuntu_codename} == "focal" ]]; then
            echo "20.04"
        elif [[ ${ubuntu_codename} == "xenial" ]]; then
            echo "18.04"
        fi
    fi
}

OS_LTS_VERSION=$(get_os_lts_version)
distribution=$(. /etc/os-release;echo ubuntu$OS_LTS_VERSION)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
&& curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
curl -s -L https://nvidia.github.io/nvidia-container-runtime/experimental/$distribution/nvidia-container-runtime.list | sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
sudo apt-get update -y
sudo apt-get install -y nvidia-docker2 -y
sudo systemctl restart docker

# # XRDP that can be opened on port 3389, from https://www.e2enetworks.com/help/knowledge-base/how-to-install-remote-desktop-xrdp-on-ubuntu-18-04/
# sudo apt-get install xrdp -y
# sudo sed -i.bak '/fi/a #xrdp multiple users configuration \n mate-session \n' /etc/xrdp/startwm.sh
# sudo adduser xrdp ssl-cert
# sudo /etc/init.d/xrdp restart
# 
# # MS Teams installation
# curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
# sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
# sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list'
# sudo apt-get update
# sudo apt-get install teams -y
# rm microsoft.gpg
# 
# # VS Code Installation
# curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
# sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
# sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
# sudo apt-get install apt-transport-https -y
# sudo apt-get update
# sudo apt-get install code -y # or code-insiders
# rm microsoft.gpg
# 
# # Chrome
# wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
# sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
# sudo apt-get update
# sudo apt-get install google-chrome-stable -y
# 
# # VLC
# sudo apt-get install vlc -y
# 
# # Screen Recorder
# sudo add-apt-repository ppa:sylvain-pineau/kazam -y
# sudo apt-get update
# sudo apt-get install kazam -y
# 
# # Network Manager, for allowing non-sudo users to control the network configuration (which networkd doesn't allow without sudo)
# sudo apt-get install network-manager -y
# sudo apt-get install network-manager-openvpn -y
# 
# # Lock the linux kernel version and nvidia driver version by marking them for hold
# sudo apt-mark hold nvidia-*
# sudo apt-mark hold linux-image-*
# 
# # Install Reminna
# sudo snap install remmina
# 
# # Install OnlyOffice
# sudo snap install onlyoffice-desktopeditors
