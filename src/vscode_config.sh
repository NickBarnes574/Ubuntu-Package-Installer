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