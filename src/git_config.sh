source src/utilities.sh

set_up_git()
{
    configure=''
    print_style "\n[CONFIGURE GIT]-------------------------------\n" "header"

    # Ask if the user wants to set up global username and email if not already configured
    while [ "$configure" != "y" ] && [ "$configure" != "n" ]
    do
        if check_git_config; then
            print_style "Git username and email found:\n" "success"
            print_style "username: $(git config --global user.name)\n" "warning"
            print_style "email: $(git config --global user.email)\n" "warning"
        else
            print_style "Git not configured.\n" "warning"
        fi

        print_style "Manage username/email? [y/n]\n" "info"
        read -r configure
    done

    if [ "$configure" = "y" ]; then
        configure_git
    else
        print_style "skipping git configuration.\n" "info"
    fi
}

# Checks if git global username and email exist
check_git_config()
{
    if git config --global user.name > /dev/null || git config --global user.email > /dev/null; then
        return 0
    else
        return 1
    fi
}

# Sets up a new git global username and email
configure_git()
{
    option=''
    name=''
    email=''
    
    while [ "$option" != "y" ] && [ "$option" != "n" ]
    do
        print_style "Please enter your git username:\n" "info"
        read -r name

        print_style "Please enter your git email:\n" "info"
        read -r email

        print_style "\nIs the following information correct? [y/n]\n" "info"
        print_style "username: $name\n" "warning"
        print_style "email: $email\n" "warning"
        read -r option
    done

    if [ "$option" = "y" ]; then
        # Configure user name
        git config --global user.name "$name"

        # Configure email
        git config --global user.email "$email"

    else
        option=''

        while [ "$option" != "y" ] && [ "$option" != "n" ]
        do
            print_style "Re-enter git username and email? [y/n]\n" "info"
            read -r option
        done

        if [ "$option" = "y" ]; then
            configure_git
        fi
    fi
}