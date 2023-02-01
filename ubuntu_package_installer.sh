#!/bin/bash

# NOTE: This script assumes you are running Ubuntu Linux 22.04

# Perform initial update/upgrade
sudo apt update && sudo apt dist-upgrade -y

sudo apt install build-essential curl file git

#---------------------------
# CURL
#---------------------------
sudo apt-get install curl

#---------------------------
# PIP (for installing Python3 packages)
#---------------------------
sudo apt install python3-pip

#---------------------------
# MAKE (used to help compile C programs with Makfiles)
#---------------------------
sudo apt install make -y

#---------------------------
# CHECK (For unit testing C programs)
#---------------------------
sudo apt-get install check

#---------------------------
# GIT
#---------------------------

# 1. Install Git
sudo apt-get install git-all

# 2. Configure user name
git config --global user.name "Nick Barnes"

# 3. Configure email
git config --global user.email "nick.a.barnes44@gmail.com"

#---------------------------
# VS CODE
#---------------------------

# 1. Update the packages index and install dependencies
sudo apt install software-properties-common apt-transport-https wget -y

# 2. Import the Microsoft GPG key
wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -

# 3. Enable the VS Code repository
sudo add-apt-repository "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main"

# 4. Install VS Code
sudo apt install code

#---------------------------
# SPOTIFY
#---------------------------

# 1. Configure the debian repository
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

# 2. Install Spotify
sudo apt-get update && sudo apt-get install spotify-client

#---------------------------
# ZSH
#---------------------------

# 1. Install ZSH
sudo apt install zsh

# 2. Make it the default shell
chsh -s $(which zsh)

#--------------------------------------
######## INSTALLATION COMPLETE ########
#--------------------------------------
echo 'Finished installation procedure!'
echo 'NOTE: Please log out and log back in again to use ZSH'