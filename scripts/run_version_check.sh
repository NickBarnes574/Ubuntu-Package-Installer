#! /bin/bash

source ../src/utilities.sh
source ../src/version_checker.sh

extensions=(
    "ms-vscode.cpptools-extension-pack:C/C++ Extension Pack"
    "cschlosser.doxdocgen:Doxygen"
    "ms-python.python:Python"
    "tomoki1207.pdf:VS Code PDF"
)

check_package()
{
    local function_call="$1"
    local display_name="$2"
    local output="$3"

    print_check "${display_name}"
    if eval "${function_call}"; then
        print_style "[PASS]   " "success"
        echo -ne $output
    else
        print_style "[FAIL]   " "danger"
        echo -ne $output
    fi
}

check_extension()
{
    local extension_name="${extension%%:*}"
    local display_name="${extension#*:}"

    print_check "${display_name}"
    if code --list-extensions 2>/dev/null | grep -q "^$extension_name$"; then
        print_style "[PASS]\n" "success"
    else
        print_style "[FAIL]\n" "danger"
    fi
}

version_check()
{
    print_style "---[RUNNING VERSION CHECKS]---\n\n" "info"
    sleep 1
    print_style "[PACKAGE NAME]           [RESULT] [VERSION]\n" "header"
    print_style "-----------------------------------------------------------------------\n" "header"
    index=0

    for check in "${checks[@]}"
    do
        # Extract function call
        local function_call="${check%%:*}"

        # Extract display name
        local temp="${check#*:}"
        local pack_disp_name="${temp%%:*}"

        local out="$output"

        check_package "$function_call" "$pack_disp_name" "$out"

        ((index+=1))
    done

    print_style "\n[EXTENSION]              [RESULT]\n" "header"
    print_style "-----------------------------------------------------------------------\n" "header"

    for extension in "${extensions[@]}"
    do
        local extension_name="${extension%%:*}"
        local ext_disp_name="${extension#*:}"    
        check_extension "$extension_name" "$ext_disp_name"
    done
    echo
}

version_check