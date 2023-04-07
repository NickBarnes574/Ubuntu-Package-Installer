catch()
{
    if [ "$1" != "0" ]; then
        # error handling goes here
        print_style "\n*** ERROR: Exit failure with $1 on line $2 ***\n" "danger"
    fi
}

main()
{
    EXIT_SUCCESS=0
    EXIT_FAILURE=1

    if ! vm_compatible; then
        exit "$EXIT_FAILURE"
    fi

    # install vm tools
    sudo apt install -y qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils

    # add the user to all groups
    add_to_groups

    # install vm manager
    sudo apt install -y virt-manager

    final_check

    print_style "\n***Complete***\n" "success"

    exit "$EXIT_SUCCESS"
}

set -e
trap 'catch $? $LINENO' EXIT

    # # install_vm_tools
    # local username=id -n
    # echo $username

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
        *)
            COLOR="0m"; # default color
            ;;
    esac

    STARTCOLOR="\e[$COLOR";
    ENDCOLOR="\e[0m";

    printf "$STARTCOLOR%b$ENDCOLOR" "$1";
}

print_check()
{
    local message="$1"
    local message_length=${#message}
    local padding_length=$((40 - message_length))

    print_style "$message$(printf '%.0s.' $(seq 1 $padding_length))" "info"
}

vm_compatible()
{
    # Check if the operating system can run a VM
    if egrep -c '(vmx|svm)' /proc/cpuinfo > 1; then
        return 0 # true
    else
        echo "Operating system is not VM compatible"
        return 1 # false
    fi
}

add_to_groups()
{
    local username=$(whoami)

    sudo adduser $username libvirt
    sudo adduser $username kvm
}

final_check()
{
    print_style "\n[-----------RUNNING FINAL CHECKS-----------]\n" "info"

    print_check "qemu-kvm"
    if kvm --version >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_check "libvirt-clients"
    if dpkg -s libvirt-clients >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_check "libvirt-daemon-system"
    if dpkg -s libvirt-daemon-system >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_check "bridge-utils"
    if dpkg -s bridge-utils >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_check "virt-manager"
    if dpkg -s virt-manager >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_style "[MISSING]\n" "warning"
    fi
}

main