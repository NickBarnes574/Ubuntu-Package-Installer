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

final_check()
{
    # print_check "SSH Keys"
    # # Check if SSH keys already exist
    # if [ -f ~/.ssh/id_rsa.pub ]; then
    #     print_style "[OK]\n" "success"
    # else
    #     print_style "[MISSING]\n" "warning"
    # fi

    # print_check "zsh"
    # if dpkg -s zsh >/dev/null 2>&1; then
    #     print_style "[OK]\n" "success"
    # else
    #     print_style "[MISSING]\n" "warning"
    # fi

    print_check "Build-Essential"
    if dpkg -s build-essential >/dev/null 2>&1; then
        local version=$(dpkg --status build-essential | grep '^Version:' | cut -d ' ' -f 2)
        print_style "[OK]" "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_check "Make"
    if dpkg -s make >/dev/null 2>&1; then
        local version=$(make --version | grep '^GNU Make' | cut -d ' ' -f 3)
        print_style "[OK]" "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[MISSING]\n" "warning"
    fi
    
    print_check "CMake"
    if dpkg -s cmake >/dev/null 2>&1; then
        local version=$(cmake --version | grep 'version' | cut -d ' ' -f 3)
        print_style "[OK]" "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_check "Valgrind"
    if dpkg -s valgrind >/dev/null 2>&1; then
        local version=$(valgrind --version | grep '^valgrind' | cut -d '-' -f 2)
        print_style "[OK]" "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_check "Curl"
    if dpkg -s curl >/dev/null 2>&1; then
        local version=$(curl --version | grep '^curl' | cut -d ' ' -f 2)
        print_style "[OK]" "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_check "Pip"
    if dpkg -s python3-pip >/dev/null 2>&1; then
        local version=$(pip --version | grep '^pip' | cut -d ' ' -f 2)
        print_style "[OK]" "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_check "Clang"
    if dpkg -s clang >/dev/null 2>&1; then
        local version=$(clang --version | grep version | cut -d ' ' -f 3)
        print_style "[OK]" "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_check "Clang Format"
    if dpkg -s clang-format >/dev/null 2>&1; then
        local version=$(clang-format --version | grep version | cut -d ' ' -f 3)
        print_style "[OK]" "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_check "Clang Tidy"
    if dpkg -s clang-tidy >/dev/null 2>&1; then
        local version=$(clang-tidy --version | grep version | cut -d ' ' -f 3)
        print_style "[OK]" "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_check "Cunit"
    if dpkg -s libcunit1 libcunit1-doc libcunit1-dev >/dev/null 2>&1; then
        local version=$(apt-cache policy libcunit1 | grep -Po '?<=Installed: )\S+' | cut -d '-' -f1,2)
        print_style "[OK]" "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_check "Git"
    # Check if git is already installed
    if dpkg -s git-all >/dev/null 2>&1; then
        local version=$(git --version | grep version | cut -d ' ' -f 3)
        print_style "[OK]" "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_check "VS Code"
    if command -v code &> /dev/null; then
        local version=$(code --version | cut -d ' ' -f 1)
        print_style "[OK]" "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[MISSING]\n" "warning"
    fi

    print_style "\n---VS CODE EXTENSIONS---\n" "info"

    # Define the extensions to check for
    extensions=(
        "ms-vscode.cpptools-extension-pack:C/C++ Extension Pack"
        "cschlosser.doxdocgen:Doxygen"
        "ms-python.python:Python"
        "tomoki1207.pdf:VS Code PDF"
    )

    # Check if each extension is installed
    for extension in "${extensions[@]}"
    do
        name="${extension%%:*}"
        display_name="${extension#*:}"

        print_check "${display_name}"
        if NODE_NO_WARNINGS=1 code --list-extensions | grep -q "^$name$"; then
            print_style "[OK]\n" "success"
        else
            print_style "[MISSING]\n" "warning"
        fi
    done
    
    # echo "1. C/C++ Extension Pack"
    # extension="ms-vscode.cpptools-extension-pack"
    # if code --list-extensions | grep -q "^$extension$"; then
    #     print_style "[OK]\n" "success"
    # else
    #     print_style "[MISSING]\n" "warning"
    # fi

    # echo "2. Doxygen"
    # extension="cschlosser.doxdocgen"
    # if code --list-extensions | grep -q "^$extension$"; then
    #     print_style "[OK]\n" "succenss"
    # else
    #     print_style "[MISSING]\n" "warning"
    # fi

    # echo "3. Python"
    # extension="ms-python.python"
    # if code --list-extensions | grep -q "^$extension$"; then
    #     print_style "[OK]\n" "success"
    # else
    #     print_style "[MISSING]\n" "warning"
    # fi

    # echo "4. VS Code PDF"
    # extension="tomoki1207.pdf"
    # if code --list-extensions | grep -q "^$extension$"; then
    #     print_style "[OK]\n" "success"
    # else
    #     print_style "[MISSING]\n" "warning"
    # fi
}

final_check