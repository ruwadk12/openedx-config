

# install Homebrew on Ubuntu
sudo apt update
sudo apt install build-essential procps curl file git -y
echo 'ubuntu:ubuntu' | sudo chpasswd
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gcc

# install Python 3.13 and set up a virtual environment for Tutor
brew install python@3.13

ln -sf /home/linuxbrew/.linuxbrew/bin/python3.13 /home/linuxbrew/.linuxbrew/bin/python3
ln -sf /home/linuxbrew/.linuxbrew/bin/python3.13 /home/linuxbrew/.linuxbrew/bin/python

python@3.13 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install "tutor[full]"

echo 'alias python=python3' >> ~/.bashrc
echo 'alias pip=pip3' >> ~/.bashrc
echo 'export PATH="/home/linuxbrew/.linuxbrew/opt/python@3.13/bin:$PATH"' >> ~/.bashrc

# install Docker and Docker Compose
sudo apt remove docker docker-engine docker.io containerd runc
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release -y
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo usermod -aG docker $USER
docker --version
docker compose version


