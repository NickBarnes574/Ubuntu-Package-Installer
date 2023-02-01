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
# Name:        | Check
# Description: | Unit testing framework for C
#---------------------------------------------------------------
sudo apt-get install check -y

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