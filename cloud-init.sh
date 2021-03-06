#!/bin/bash
set -euo pipefail

USERNAME=chris # TODO: Customize the sudo non-root username here

# Install packages
apt-get update
apt-get install -y zsh

# Create user and immediately expire password to force a change on login
useradd --create-home --shell "/bin/bash" --groups sudo "${USERNAME}"
passwd --delete "${USERNAME}"
chage --lastday 0 "${USERNAME}"

# Create SSH directory for sudo user and move keys over
home_directory="$(eval echo ~${USERNAME})"
mkdir --parents "${home_directory}/.ssh"
cp /root/.ssh/authorized_keys "${home_directory}/.ssh"
chmod 0700 "${home_directory}/.ssh"
chmod 0600 "${home_directory}/.ssh/authorized_keys"
chown --recursive "${USERNAME}":"${USERNAME}" "${home_directory}/.ssh"

# Copy .vimrc
wget -O ${home_directory}/.vimrc https://raw.githubusercontent.com/ChrHan/dev-box/master/.vimrc

# Change shell to zsh
usermod --shell $(which zsh) chris
echo 'chris ALL=(ALL) NOPASSWD:ALL' | sudo EDITOR='tee -a' visudo

echo '# disable zsh-newuser' > ${home_directory}/.zshrc
# Install oh-my-zsh
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Disable root SSH login with password
sed --in-place 's/^PermitRootLogin.*/PermitRootLogin prohibit-password/g' /etc/ssh/sshd_config
if sshd -t -q; then systemctl restart sshd fi

