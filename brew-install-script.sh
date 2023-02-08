#!/bin/sh

#Install Rosetta for M1
/usr/sbin/softwareupdate --install-rosetta --agree-to-license
arch -x86_64 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

#Install package managers 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/jessenia/.zprofile

eval "$(/opt/homebrew/bin/brew shellenv)"

#Install xcode command line tools
touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
softwareupdate -i -a

rm /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress

#Install brew bundle
brew bundle install

#Install Mike McQuaid strap
git clone https://github.com/MikeMcQuaid/strap
cd strap
bash bin/strap.sh 

#Install web browsers
brew install --cask google-chrome
brew install --cask brave-browser

#Install software
brew install --cask 1password
brew install --cask adobe-acrobat-pro
brew install ansible
brew install --cask discord
brew install docker
brew install --cask goland
brew install --cask iterm2
brew install jq
brew install --cask mysqlworkbench
brew install --cask notion
brew install --cask slack
brew install zsh
brew install --cask postman
brew install --cask pritunl
brew install --cask pycharm
brew install --cask viscosity
brew install --cask visual-studio-code
brew install --cask zoom

#Frontend Dev tools
brew install npm
brew install eslint
npm install --save-dev jest



#Install command line tools
brew install bazelisk
brew install git
brew install golang
go get google.golang.org/grpc
brew install python
brew install python3
python -m pip install boto3
brew install ruby
brew install tree
brew install watchman
brew install wget
brew install coreutils
brew install terraform
brew install tmux


#Terraform and M1 TF provider helper
brew install kreuzwerker/taps/m1-terraform-provider-helper
m1-terraform-provider-helper activate
m1-terraform-provider-helper install hashicorp/template -v v2.2.0
brew tap hashicorp/tap 
brew install hashicorp/tap/terraform
brew install tfenv
brew install terraform-docs

#Python formulae
python3 -m pip install --upgrade setuptools
python3 -m pip install --upgrade pip setuptools wheel
python3 -m pip install beautysh

#Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zshrc
omz update
brew install starship
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
brew tap homebrew/cask-fonts && brew install --cask font-fira-code-nerd-font

#Download iTerm Themes
cd ~/Downloads
wget https://github.com/mbadolato/iTerm2-Color-Schemes/zipball/master
cd ~

#Install Powerlevel10k
cd ~/github
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

#Install additional plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sudo gem install colorls
npm install -g secman
curl -sL https://cutt.ly/tran-cli | bash


#Show all hidden files
defaults write com.apple.Finder AppleShowAllFiles true
killall Finder

#Set up Git
git config --global user.name "Jessenia"
git config --global user.email "1072588+jessenia@users.noreply.github.com"
git config –global core.editor "vim"

#Set up Yubikey agent
brew install yubikey-agent
brew install ykman
brew services start yubikey-agent
echo ""export SSH_AUTH_SOCK="$(brew --prefix)/var/run/yubikey-agent.sock"" >> ~/.zshrc"
source ~/.zshrc

#Set up Vundle
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

#Set up AWSume
pipx install awsume

#set up vagrant
brew install vagrant
vagrant autocomplete install --bash --zsh

#kubernetes
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl.sha256"
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
sudo chown root: /usr/local/bin/kubectl

#geth
brew tap ethereum/ethereum
brew install ethereum
git clone https://github.com/ethereum/go-ethereum.git
cd go-ethereum
make geth
./build/bin/geth #start geth

#bazel
git clone https://github.com/prysmaticlabs/prysm
cd prysm
git checkout v3.2.0

bazel build //cmd/beacon-chain:beacon-chain --config=release
bazel build //cmd/validator:validator --config=release


#python @ bloxroute
pip3 install virtualenv
python3 -m venv venv
source venv/bin/activate
cd bloxroute-dev
pip install -r bxcommon/requirements.txt
pip install -r bxcommon/requirements-dev.txt
pip install -r bxapi/requirements.txt
pip install -r bxapi/requirements-dev.txt