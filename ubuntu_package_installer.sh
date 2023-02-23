#!/bin/bash

# NOTE: This script assumes you are running Ubuntu Linux 22.04

# Perform initial update/upgrade
sudo apt update && sudo apt dist-upgrade -y

#---------------------------------------------------------------
# Name:        | Build-Essential
# Description: | Meta-packages necessary for compiling software
#---------------------------------------------------------------
sudo apt install build-essential -y

#---------------------------------------------------------------
# Name:        | Curl
# Description: | Command-line tool to transfer data to or from a server
#---------------------------------------------------------------
sudo apt-get install curl -y

#---------------------------------------------------------------
# Name:        | Pip
# Description: | 3rd-party package manager for Python modules
#---------------------------------------------------------------
sudo apt install python3-pip -y

#---------------------------------------------------------------
# Name:        | Make
# Description: | Used to build executable programs and libraries from source code
#---------------------------------------------------------------
sudo apt install make -y

#---------------------------------------------------------------
# Name:        | CMake
# Description: | Used to build executable programs and libraries from source code
#---------------------------------------------------------------
sudo apt-get -y install cmake

#---------------------------------------------------------------
# Name:        | Clang
# Description: | Alternative C compiler for use with CMake
#---------------------------------------------------------------
sudo apt install -y clang

#---------------------------------------------------------------
# Name:        | Clang Format
# Description: | Formatting tool for C
#---------------------------------------------------------------
sudo apt install -y clang-format

#---------------------------------------------------------------
# Name:        | Clang Tidy
# Description: | Static analyzer tool for C
#---------------------------------------------------------------
sudo apt install -y clang-tidy

#---------------------------------------------------------------
# Name:        | CUnit
# Description: | Unit testing framework for C
#---------------------------------------------------------------
sudo apt-get install libcunit1 libcunit1-doc libcunit1-dev

#---------------------------------------------------------------
# Name:        | Git
# Description: | Distributed version control system for developers
#---------------------------------------------------------------

# 1. Install Git
sudo apt-get install git-all -y

# 2. Configure user name
git config --global user.name "Nick Barnes"

# 3. Configure email
git config --global user.email "nick.a.barnes44@gmail.com"

#---------------------------------------------------------------
# Name:        | VS Code
# Description: | Source-code editor made by Microsoft
#---------------------------------------------------------------

# 1. Update the packages index and install dependencies
sudo apt install software-properties-common apt-transport-https wget -y

# 2. Import the Microsoft GPG key
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -

# 3. Enable the VS Code repository
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

# 4. Install VS Code
sudo apt install code -y

#---------------------------------------------------------------
# Name:        | Sublime Text 4
# Description: | Source-code editor for Windows, MacOS and Linux
# Tutorial: https://linuxhint.com/install-sublime-text-4-ubuntu/
#---------------------------------------------------------------

# 1. Download the Sublime Text GPG key
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo tee /etc/apt/trusted.gpg.d/sublimehq-pub.asc

# 2. Update the APT package repository cache
sudo apt update

# 3. Install the apt-transport-https package
sudo apt-get install apt-transport-https -y

# 4. Add the official package repository
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# 5. Update the APT package repository cache again
sudo apt update

# 6. Install the latest version of Sublime Text
sudo apt install sublime-text -y

#---------------------------------------------------------------
# Name:        | LaTex
# Description: | Software system for preparing scientific documents
# Installing LaTex for Sublime Text: https://rowannicholls.github.io/sublime_text/latex.html
#---------------------------------------------------------------

# 1. Install the base version of LaTex
sudo apt install -y texlive-latex-base

# 2. install extras
sudo apt install -y dvipng
sudo apt install -y texlive-latex-extra
sudo apt install -y texlive-fonts-recommended
sudo apt install -y texlive-pictures
sudo apt install -y texlive-font-utils  # Needed for eps figures to work
sudo apt install -y latexmk  # Needed for running Latex in Sublime Text
sudo apt install -y texlive-lang-greek

#---------------------------------------------------------------
# Name:        | ImageMagick (For use with LaTex)
# Description: | Display, create, convert, and modify images
#---------------------------------------------------------------
cd ~/Downloads
wget https://www.imagemagick.org/download/ImageMagick.tar.gz
tar xvzf ImageMagick.tar.gz
cd ImageMagick-7.0.*/
./configure
make
sudo make install
sudo ldconfig /usr/local/lib
cd ~ # Return to home directory when finished

#---------------------------------------------------------------
# Name:        | Discord
# Description: | Voice, video, and text chat app
#---------------------------------------------------------------
sudo snap install discord -y

#---------------------------------------------------------------
# Name:        | Spotify
# Description: | Music streaming service provider
#---------------------------------------------------------------

# 1. Configure the debian repository
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

# 2. Install Spotify
sudo apt-get update && sudo apt-get install spotify-client

#---------------------------------------------------------------
# Name:        | ZSH
# Description: | An extended version of Bash (Bourne Shell)
#---------------------------------------------------------------

# 1. Install ZSH
sudo apt install zsh -y

# 2. Make it the default shell
chsh -s $(which zsh)

#--------------------------------------
######## INSTALLATION COMPLETE ########
#--------------------------------------
echo 'Finished installation procedure!'
echo 'NOTE: Please log out and log back in again to use ZSH'