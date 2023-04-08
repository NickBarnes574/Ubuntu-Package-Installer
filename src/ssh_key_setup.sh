source src/utilities.sh

setup_ssh_keys()
{
    option=''

    print_style "\n[SSH KEYS]------------------------------------\n" "header"

    # Check if SSH keys already exist
    if ! [ -f ~/.ssh/id_rsa.pub ]; then

        # Ask the user if they would like to create SSH keys
        while [ "$option" != "y" ] && [ "$option" != "n" ]
        do
            print_style "No SSH keys were found. Would you like to create them? [y/n]\n" "info"
            read -r option
        done

        if [ "$option" = "y" ]; then
            # Create SSH keys
            ssh-keygen
        fi
    fi
}
