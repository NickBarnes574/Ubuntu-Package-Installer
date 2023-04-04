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
    print_style "\n              **Preparing to install package**\n" "info"
    print_style "---------------------------------------------------------------\n" "info"
    print_style "Name:        | $1\n" "info"
    print_style "Description: | $2\n" "info"
    print_style "---------------------------------------------------------------\n" "info"
}

base_install()
{
    # Perform initial setup
    # sudo apt update && sudo apt dist-upgrade -y
    setup_ssh_keys
    get_zsh

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
    get_posix_cac

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
    print_check "Build-Essential"
    if dpkg -s build-essential >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_description "Build-Essential" "Meta-packages necessary for compiling software"
        sudo apt install build-essential -y
    fi
}

#---------------------------------------------------------------
# Name:        | Make
# Description: | Used to build executable programs and libraries from source code
#---------------------------------------------------------------
get_make()
{
    print_check "Make"
    if dpkg -s make >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_description "Make" "Used to build executable programs and libraries from source code"
        sudo apt install make -y
    fi
}

#---------------------------------------------------------------
# Name:        | CMake
# Description: | Used to build executable programs and libraries from source code
#---------------------------------------------------------------
get_cmake()
{
    print_check "CMake"
    if dpkg -s cmake >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_description "CMake" "Used to build executable programs and libraries from source code"
        sudo apt install cmake -y
    fi
}

#---------------------------------------------------------------
# Name:        | Curl
# Description: | Command-line tool to transfer data to or from a server
#---------------------------------------------------------------
get_curl()
{
    print_check "Curl"
    if dpkg -s curl >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_description "Curl" "Command-line tool to transfer data to or from a server"
        sudo apt-get install curl -y
    fi
}

#---------------------------------------------------------------
# Name:        | Pip
# Description: | 3rd-party package manager for Python modules
#---------------------------------------------------------------
get_pip()
{
    print_check "Pip"
    if dpkg -s python3-pip >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_description "Pip" "3rd-party package manager for Python modules"
        sudo apt install python3-pip -y
    fi
}

#---------------------------------------------------------------
# Name:        | Clang
# Description: | Alternative C compiler
# 
# Name:        | Clang Format
# Description: | Formatting tool for C
#
# Name:        | Clang Tidy
# Description: | Static analyzer tool for C
#---------------------------------------------------------------
get_clang_suite()
{
    print_check "Clang"
    if dpkg -s clang >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_description "Clang" "Alternative C compiler"
        sudo apt install -y clang
    fi

    print_check "Clang Format"
    if dpkg -s clang-format >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_description "Clang Format" "Formatting tool for C"
        sudo apt install -y clang-format
    fi

    print_check "Clang Tidy"
    if dpkg -s clang-tidy >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_description "Clang Tidy" "Static analyzer tool for C"
        sudo apt install -y clang-tidy
    fi
}

#---------------------------------------------------------------
# Name:        | CUnit
# Description: | Unit testing framework for C
#---------------------------------------------------------------
get_cunit()
{
    print_check "Cunit"
    if dpkg -s libcunit1 libcunit1-doc libcunit1-dev >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_description "CUnit" "Unit testing framework for C"
        sudo apt-get install libcunit1 libcunit1-doc libcunit1-dev
    fi
}

#---------------------------------------------------------------
# Name:        | VS Code
# Description: | Source-code editor made by Microsoft
#---------------------------------------------------------------
get_vscode()
{
    print_check "VS Code"
    if dpkg -s code >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_description "VS Code" "Source-code editor made by Microsoft"

        curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        sudo install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'
        sudo apt update
        sudo apt install code -y
    fi

    install_vscode_extensions
    update_vscode_settings
    update_vscode_user_snippets
}

#---------------------------------------------------------------
# Name:        | Valgrind
# Description: | Memory leak checker for C
#---------------------------------------------------------------
get_valgrind()
{
    print_check "Valgrind"
    if dpkg -s valgrind >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_description "Valgrind" "Source-code editor made by Microsoft"

        sudo apt install valgrind -y
    fi
}

install_vscode_extensions()
{
    print_style "\n---BEGIN VS CODE EXTENSIONS CHECK---\n" "info"

    if dpkg -s code >/dev/null 2>&1; then

        # C/C++ Extension Pack
        print_check "1. C/C++ Extension Pack"
        extension="ms-vscode.cpptools-extension-pack"
        if code --list-extensions | grep -q "^$extension$"; then
            print_style "[OK]\n" "success"
        else
            print_style "installing VS Code extension: C/C++ Extention Pack\n" "info"
            code --install-extension ms-vscode.cpptools-extension-pack
        fi

        # Doxygen Documentation Generator
        print_check "2. Doxygen"
        extension="cschlosser.doxdocgen"
        if code --list-extensions | grep -q "^$extension$"; then
            print_style "[OK]\n" "success"
        else
            print_style "installing VS Code extension: Doxygen\n" "info"
            code --install-extension cschlosser.doxdocgen
        fi

        # Python
        print_check "3. Python"
        extension="ms-python.python"
        if code --list-extensions | grep -q "^$extension$"; then
            print_style "[OK]\n" "success"
        else
            print_style "installing VS Code extension: Python\n" "info"
            code --install-extension ms-python.python
        fi

        # VS Code PDF
        print_check "4. VS Code PDF"
        extension="tomoki1207.pdf"
        if code --list-extensions | grep -q "^$extension$"; then
            print_style "[OK]\n" "success"
        else
            print_style "installing VS Code extension: VS Code PDF\n" "info"
            code --install-extension tomoki1207.pdf
        fi

    else
        print_style "VS Code is not installed. Cannot install VS Code extensions!\n" "danger"
    fi

    print_style "---END VS CODE EXTENSIONS CHECK---\n\n" "info"
}

setup_ssh_keys()
{
    print_check "SSH Keys"
    # Check if SSH keys already exist
    if [ -f ~/.ssh/id_rsa.pub ]; then
        print_style "[OK]\n" "success"
    else
        # Ask the user if they would like to create SSH keys
        read -p "SSH keys are not installed. Would you like to create them? [y/n] " choice
        if [ "$choice" = "y" ]; then
            # Create SSH keys
            ssh-keygen
            print_style "SSH keys created successfully!\n" "success"
        else
            print_style "SSH keys were not installed.\n" "info"
        fi
    fi
}

#---------------------------------------------------------------
# Name:        | Git
# Description: | Distributed version control system for developers
#---------------------------------------------------------------
get_git()
{
    configure=''

    print_check "Git"
    # Check if git is already installed
    if dpkg -s git-all >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        print_description "Git" "Distributed version control system for developers"
        sudo apt-get install git-all -y
    fi

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

        print_style "Is the following information correct? [y/n]\n" "info"
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

get_zsh()
{
    option=''
    print_check "zsh"
    if dpkg -s zsh >/dev/null 2>&1; then
        print_style "[OK]\n" "success"
    else
        while [ "$option" != "y" ] && [ "$option" != "n" ]
        do
            print_style "Do you want to install zsh and make it the default shell? [y/n]\n" "info"
            read -r option
        done
        
        if [ "$option" = "y" ]; then
            # Update the package list
            sudo apt update

            # Install zsh
            sudo apt install -y zsh

            # Set zsh as the default shell for the current user
            chsh -s $(which zsh)
        fi
    fi
}

set_aliases()
{
    #default
    rc_file=~/.bashrc

    # Create aliases for ZSH if installed, otherwise create them for BASH
    if dpkg -s zsh >/dev/null 2>&1; then
        rc_file=~/.zshrc
    fi

    # Check if the 'valrun' alias already exists
    if ! grep -q "alias valrun='valgrind --leak-check=full'" $rc_file; then
        echo "alias valrun='valgrind --leak-check=full'" >> $rc_file
    fi

     # insert additional aliases here
}

update_vscode_settings()
{
    custom_settings=''

    if dpkg -s code >/dev/null 2>&1; then
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
    "editor.rulers": [
        80,
        120
    ],
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

    if dpkg -s code >/dev/null 2>&1; then
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
    while [ "$option" != "y" ] && [ "$option" != "n" ]
    do
        print_style "Do you want to install CAC credentials? [y/n]\n" "info"
        read -r option
    done
    
    if [ "$option" = "y" ]; then
        ./install_posix_cac.sh
    fi
}

main