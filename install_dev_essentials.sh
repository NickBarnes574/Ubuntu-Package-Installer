set -e # used to exit the script immediately if any errors occur
trap 'catch $? $LINENO' EXIT

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

    base_install
    print_style "\n***Complete***\n" "success"
    exit "$EXIT_SUCCESS"
}

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

base_install()
{
    # Perform initial setup
    sudo apt update && sudo apt dist-upgrade -y

    # Install base packages
    get_build_essential
    get_make
    get_cmake
    get_valgrind
    get_curl
    get_pip
    get_clang_suite
    get_cunit
    get_vscode
    get_git

    clear

    sanity_check

    set_up_git
    get_posix_cac
    setup_ssh_keys

    # Setup aliases
    set_aliases
}

print_check()
{
    local message="$1"
    local message_length=${#message}
    local padding_length=$((40 - message_length))

    print_style "$message$(printf '%.0s.' $(seq 1 $padding_length))" "info"
}

#---------------------------------------------------------------
# Name:        | Build-Essential
# Description: | Meta-packages necessary for compiling software
#---------------------------------------------------------------
get_build_essential()
{
    if ! dpkg -s build-essential >/dev/null 2>&1; then
        print_description "Build-Essential" "Meta-packages necessary for compiling software"
        sudo apt-get install -qq build-essential -y
    fi
}

#---------------------------------------------------------------
# Name:        | Make
# Description: | Used to build executable programs and libraries from source code
#---------------------------------------------------------------
get_make()
{
    if ! dpkg -s make >/dev/null 2>&1; then
        print_description "Make" "Used to build executable programs and libraries from source code"
        sudo apt-get install -qq make -y
    fi
}

#---------------------------------------------------------------
# Name:        | CMake
# Description: | Used to build executable programs and libraries from source code
#---------------------------------------------------------------
get_cmake()
{
    if ! dpkg -s cmake >/dev/null 2>&1; then
        print_description "CMake" "Used to build executable programs and libraries from source code"
        sudo apt-get install -qq cmake -y
    fi
}

#---------------------------------------------------------------
# Name:        | Curl
# Description: | Command-line tool to transfer data to or from a server
#---------------------------------------------------------------
get_curl()
{
    if ! dpkg -s curl >/dev/null 2>&1; then
        print_description "Curl" "Command-line tool to transfer data to or from a server"
        sudo apt-get install -qq curl -y
    fi
}

#---------------------------------------------------------------
# Name:        | Pip
# Description: | 3rd-party package manager for Python modules
#---------------------------------------------------------------
get_pip()
{
    if ! dpkg -s python3-pip >/dev/null 2>&1; then
        print_description "Pip" "3rd-party package manager for Python modules"
        sudo apt-get install -qq python3-pip -y
    fi
}

#---------------------------------------------------------------
# Name:        | Clang
# Description: | LLVM-based C/C++ compiler
# 
# Name:        | Clang Format
# Description: | Code Formatting tool for C/C++
#
# Name:        | Clang Tidy
# Description: | Static analyzer tool for C/C++
#---------------------------------------------------------------
get_clang_suite()
{
    if ! dpkg -s clang >/dev/null 2>&1; then
        print_description "Clang" "LLVM-based C/C++ compiler"
        sudo apt-get install -qq -y clang-12
    fi

    if ! dpkg -s clang-format >/dev/null 2>&1; then
        print_description "Clang Format" "Code Formatting tool for C/C++"
        sudo apt-get install -qq -y clang-format
    fi

    if ! dpkg -s clang-tidy >/dev/null 2>&1; then
        print_description "Clang Tidy" "Static analyzer tool for C/C++"
        sudo apt-get install -qq -y clang-tidy
    fi
}

#---------------------------------------------------------------
# Name:        | CUnit
# Description: | Unit testing framework for C
#---------------------------------------------------------------
get_cunit()
{
    if ! dpkg -s libcunit1 libcunit1-doc libcunit1-dev >/dev/null 2>&1; then
        print_description "CUnit" "Unit testing framework for C"
        sudo apt-get install -qq -y libcunit1 libcunit1-doc libcunit1-dev
    fi
}

#---------------------------------------------------------------
# Name:        | VS Code
# Description: | Source-code editor made by Microsoft
#---------------------------------------------------------------
get_vscode()
{
    if ! command -v code &> /dev/null; then
        print_description "VS Code" "Source-code editor made by Microsoft"
        sudo snap install --classic code
    fi

    install_vscode_extensions
    update_vscode_settings
    update_vscode_user_snippets
}

#---------------------------------------------------------------
# Name:        | Valgrind
# Description: | Memory management and bug detector for C
#---------------------------------------------------------------
get_valgrind()
{
    if ! dpkg -s valgrind >/dev/null 2>&1; then
        print_description "Valgrind" "Memory management and bug detector for C"
        sudo apt-get install -qq valgrind -y
    fi
}

install_vscode_extensions()
{
    if command -v code &> /dev/null; then

        # C/C++ Extension Pack
        extension="ms-vscode.cpptools-extension-pack"
        if ! code --list-extensions 2>/dev/null | grep -q "^$extension$"; then
            print_style "installing VS Code extension: C/C++ Extention Pack\n" "info"
            code --install-extension ms-vscode.cpptools-extension-pack 2>/dev/null
        fi

        # Doxygen Documentation Generator
        extension="cschlosser.doxdocgen"
        if ! code --list-extensions 2>/dev/null | grep -q "^$extension$"; then
            print_style "installing VS Code extension: Doxygen\n" "info"
            code --install-extension cschlosser.doxdocgen 2>/dev/null
        fi

        # Python
        extension="ms-python.python"
        if ! code --list-extensions 2>/dev/null | grep -q "^$extension$"; then
            print_style "installing VS Code extension: Python\n" "info"
            code --install-extension ms-python.python 2>/dev/null
        fi

        # VS Code PDF
        extension="tomoki1207.pdf"
        if ! code --list-extensions 2>/dev/null | grep -q "^$extension$"; then
            print_style "installing VS Code extension: VS Code PDF\n" "info"
            code --install-extension tomoki1207.pdf 2>/dev/null
        fi

    else
        print_style "VS Code is not installed. Cannot install VS Code extensions!\n" "danger"
    fi
}

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

        if [ "$choice" = "y" ]; then
            # Create SSH keys
            ssh-keygen
            print_style "SSH keys created successfully!\n" "success"
        fi
    fi
}

#---------------------------------------------------------------
# Name:        | Git
# Description: | Distributed version control system for developers
#---------------------------------------------------------------
get_git()
{
    # Check if git is already installed
    if ! dpkg -s git-all >/dev/null 2>&1; then
        print_description "Git" "Distributed version control system for developers"
        sudo apt-get install -qq git-all -y
    fi
}

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

set_aliases()
{
    #default
    rc_file=~/.bashrc

    # Check if the 'valrun' alias already exists
    if ! grep -q "alias valrun='valgrind --leak-check=full'" $rc_file; then
        echo "alias valrun='valgrind --leak-check=full'" >> $rc_file
    fi

     # insert additional aliases here
    
    print_style "aliases successfully installed.\n" "info"
}

update_vscode_settings()
{
    custom_settings=''

    if command -v code &> /dev/null; then
        custom_settings='{
    "editor.formatOnPaste": true,
    "editor.formatOnSave": true,
    "editor.formatOnType": true,
    "files.autoSave": "onFocusChange",
    "editor.tabCompletion": "on",
    "editor.codeActionsOnSave": {
        "source.fixAll": true,
        "source.organizeImports": true
    },
    "editor.minimap.autohide": true,
    "explorer.autoReveal": false,
    "C_Cpp.autocompleteAddParentheses": true,
    "C_Cpp.clang_format_sortIncludes": true,
    "C_Cpp.formatting": "clangFormat",
    "security.workspace.trust.untrustedFiles": "open",
    "cmake.configureOnOpen": true,
    "C_Cpp.default.customConfigurationVariables": {},
}'

        echo "$custom_settings" > ~/.config/Code/User/settings.json
    fi
}

update_vscode_user_snippets()
{
    source_file_snippets=''
    header_file_snippets=''

    if command -v code &> /dev/null; then

        mkdir -p ~/.config/Code/User/snippets

        source_file_snippets='{
	// Place your snippets for c here. Each snippet is defined under a snippet name and has a prefix, body and 
	// description. The prefix is what is used to trigger the snippet and the body will be expanded and inserted. Possible variables are:
	// $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. Placeholders with the 
	// same ids are connected.
	// Example:
	// "Print to console": {
	// 	"prefix": "log",
	// 	"body": [
	// 		"console.log('$1');",
	// 		"$2"
	// 	],
	// 	"description": "Log output to console"
	// }
    "source file template":
    {
        "prefix" : "src",
		"body" : [
			"#include \"${TM_FILENAME_BASE}.h\"",
			"",
			"$0",
			"",
			"/*** end of file ***/",
			""
		],
		"description" : "to produce the boilerplate code for a C source file"
    },
}'      
        echo "$source_file_snippets" > ~/.config/Code/User/snippets/c.json

        header_file_snippets='{
    // Place your global snippets here. Each snippet is defined under a snippet name and has a scope, prefix, body and 
    // description. Add comma separated ids of the languages where the snippet is applicable in the scope field. If scope 
    // is left empty or omitted, the snippet gets applied to all languages. The prefix is what is 
    // used to trigger the snippet and the body will be expanded and inserted. Possible variables are: 
    // $1, $2 for tab stops, $0 for the final cursor position, and ${1:label}, ${2:another} for placeholders. 
    // Placeholders with the same ids are connected.
    // Example:
    // "Print to console": {
    //     "scope": "javascript,typescript",
    //     "prefix": "log",
    //     "body": [
    //         "console.log('$1');",
    //         "$2"
    //     ],
    //     "description": "Log output to console"
    // }
    "header file template": {
        "prefix": "hdr",
        "body": [
            "/**",
            "* @file ${TM_FILENAME_BASE}.h",
            "*",
            "* @brief $1",
            "*/",
            "#ifndef _${TM_FILENAME_BASE/(.*)/${1:/upcase}/}_H",
            "#define _${TM_FILENAME_BASE/(.*)/${1:/upcase}/}_H",
            "",
            "$0",
            "",
            "#endif /* _${TM_FILENAME_BASE/(.*)/${1:/upcase}/}_H */",
            "",
            "/*** end of file ***/",
            ""
        ],
        "description": "to produce the boilerplate code for a C header file",
    },
}'
        echo "$header_file_snippets" > ~/.config/Code/User/snippets/h.code-snippets
    fi
}

get_posix_cac()
{
    option=''

    print_style "\n[POSIX CAC]-----------------------------------\n" "header"

    while [ "$option" != "y" ] && [ "$option" != "n" ]
    do
        print_style "Do you want to install CAC credentials? [y/n]\n" "info"
        read -r option
    done
    
    if [ "$option" = "y" ]; then
        chmod +x ./install_posix_cac.sh
        ./install_posix_cac.sh
    fi
}

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

main