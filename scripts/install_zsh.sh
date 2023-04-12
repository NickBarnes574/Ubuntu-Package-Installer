get_zsh()
{
    option=''

    if ! dpkg -s zsh >/dev/null 2>&1; then
        while [ "$option" != "y" ] && [ "$option" != "n" ]
        do
            print_style "Do you want to install zsh and make it the default shell? [y/n]\n" "info"
            read -r option
        done
        
        if [ "$option" = "y" ]; then
            # Update the package list
            sudo apt update

            # Install zsh
            sudo apt install -qq -y zsh

            # Set zsh as the default shell for the current user
            chsh -s $(which zsh)
        fi

        while [ "$option" != "y" ] && [ "$option" != "n" ]
        do
            print_style "Logout is required for changes to take effect. Logout now? [y/n]\n" "info"
            read -r option
        done

        if [ "$option" = "y" ]; then
            logout
        fi
    fi
}

get_zsh