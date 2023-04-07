source utilities.sh

sanity_check()
{
    print_style "---RUNNING SANITY CHECKS---\n\n" "info"
    sleep 1
    print_style "[PACKAGE NAME]                          [RESULT]  [VERSION]\n" "header"
    print_style "-----------------------------------------------------------------------\n" "header"

    print_check "Build-Essential"
    if dpkg -s build-essential >/dev/null 2>&1; then
        local version=$(dpkg --status build-essential | grep '^Version:' | cut -d ' ' -f 2)
        print_style "[PASS]    " "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[FAIL]\n" "danger"
    fi

    print_check "Make"
    if dpkg -s make >/dev/null 2>&1; then
        local version=$(make --version | grep '^GNU Make' | cut -d ' ' -f 3)
        print_style "[PASS]    " "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[FAIL]\n" "danger"
    fi
    
    print_check "CMake"
    if dpkg -s cmake >/dev/null 2>&1; then
        local version=$(cmake --version | grep 'version' | cut -d ' ' -f 3)
        print_style "[PASS]    " "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[FAIL]\n" "danger"
    fi

    print_check "Valgrind"
    if dpkg -s valgrind >/dev/null 2>&1; then
        local version=$(valgrind --version | grep '^valgrind' | cut -d '-' -f 2)
        print_style "[PASS]    " "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[FAIL]\n" "danger"
    fi

    print_check "Curl"
    if dpkg -s curl >/dev/null 2>&1; then
        local version=$(curl --version | grep '^curl' | cut -d ' ' -f 2)
        print_style "[PASS]    " "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[FAIL]\n" "danger"
    fi

    print_check "Pip"
    if dpkg -s python3-pip >/dev/null 2>&1; then
        local version=$(pip --version | grep '^pip' | cut -d ' ' -f 2)
        print_style "[PASS]    " "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[FAIL]\n" "danger"
    fi

    print_check "Clang"
    if dpkg -s clang-12 >/dev/null 2>&1; then
        local version=$(clang-12 --version | grep version | cut -d ' ' -f 3)
        print_style "[PASS]    " "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[FAIL]\n" "danger"
    fi

    print_check "Clang Format"
    if dpkg -s clang-format >/dev/null 2>&1; then
        local version=$(clang-format --version | grep version | cut -d ' ' -f 3)
        print_style "[PASS]    " "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[FAIL]\n" "danger"
    fi

    print_check "Clang Tidy"
    if dpkg -s clang-tidy >/dev/null 2>&1; then
        local version=$(clang-tidy --version | grep version | cut -d ' ' -f 5)
        print_style "[PASS]    " "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[FAIL]\n" "danger"
    fi

    print_check "Cunit"
    if dpkg -s libcunit1 libcunit1-doc libcunit1-dev >/dev/null 2>&1; then
        local version=$(apt-cache policy libcunit1 | grep Installed | cut -d ' ' -f 4)
        print_style "[PASS]    " "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[FAIL]\n" "danger"
    fi

    print_check "Git"
    # Check if git is already installed
    if dpkg -s git-all >/dev/null 2>&1; then
        local version=$(git --version | grep version | cut -d ' ' -f 3)
        print_style "[PASS]    " "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[FAIL]\n" "danger"
    fi

    print_check "VS Code"
    if command -v code &> /dev/null; then
        local version=$(code --version | head -n 1)
        print_style "[PASS]    " "success"
        print_style "[$version]\n" "warning"
    else
        print_style "[FAIL]\n" "danger"
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
        if code --list-extensions 2>/dev/null | grep -q "^$name$"; then
            print_style "[PASS]\n" "success"
        else
            print_style "[FAIL]\n" "danger"
        fi
    done
    
    print_style "-----------------------------------------------------------------------\n" "header"
}

sanity_check