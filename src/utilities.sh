print_style() {
    case "$2" in
        "info")
            COLOR="96m"; # cyan
            ;;
        "success")
            COLOR="92m"; # green
            ;;
        "warning")
            COLOR="93m"; # yellow
            ;;
        "danger")
            COLOR="91m"; # red
            ;;
        "header")
            COLOR="35m"; # magenta
            ;;
        *)
            COLOR="0m"; # default color
            ;;
    esac

    STARTCOLOR="\e[$COLOR";
    ENDCOLOR="\e[0m";

    printf "$STARTCOLOR%b$ENDCOLOR" "$1";
}

print_description()
{
    print_style "---------------------------------------------------------------\n" "info"
    print_style "Name:        | $1\n" "info"
    print_style "Description: | $2\n" "info"
    print_style "---------------------------------------------------------------\n" "info"
}

print_check()
{
    local message="$1"
    local message_length=${#message}
    local padding_length=$((25 - message_length))

    print_style "$message$(printf '%.0s.' $(seq 1 $padding_length))" "info"
}

set_aliases()
{
    #default
    rc_file=~/.bashrc

    # Check if the 'valrun' alias already exists
    if ! grep -q "alias valrun='valgrind --leak-check=full'" $rc_file; then
        echo "alias valrun='valgrind --leak-check=full'" >> $rc_file
    fi

     # insert additional aliases here
}