; / -------------------  header file  ------------------
Red [
    File: "npm"
    Title: "npm"
    Html-Proxy: 
    Description: {
        
    }
    Features: [
        
    ]
    Builds:[
        [0.0.0.1.01.1 {  }]
    ]
    TODO: [
        1 {allow todo: 1.}
        2 {...}
    ]
]


; / -------------------  load libraries  ------------------
unless value? '.redlang [
    do https://redlang.red
]
.redlang [cd do-events alias]


; / -------------------  npm function  ------------------
.npm: function [
    {Usage: 
    - version or npm version: get version
    - global or npm global: get global install directory
    - list or npm list: list global packages
    - config or npm config: print config
    - init or npm init: will create a default package.json    
    - install or npm "install <your-package>": will install a package with options available
    - npm <your-command>: custom command
    }
    '>command "your command"
    /no-confirmation "don't ask confirmation"
    /no-options "don't propose options"
    /boot "internal usage only"
    /locally "force locally"
    /local initial-directory
][

    initial-directory: copy []

    if empty? initial-directory [

        if error? try [
            folder: pick split-path system/options/script 1
        ][
            folder: what-dir
        ]

        either not none? folder [
            append initial-directory folder
        ][
            append initial-directory what-dir
        ]
    ] 
    

    short-command: form >command

    ;-------------------------------------------------
    true-command-list: copy [ ; BUG due to lack of copy
        version "--version" {}
        global "config get prefix" {}
        config "config list" {}
        init "init --y" {}
        clean "cache clean --force" {Sometimes npm's cache gets confused. You can reset it}
    ]

    either locally [
        append true-command-list  [list "list" {}]
    ][
        json-file: to-red-file rejoin [initial-directory/1 %package.json]
        either exists? json-file [
            append true-command-list  [list "list" {}]
        ][
            append true-command-list  [list "list --global --depth=0" {}]
        ]
    ]


    ;-------------------------------------------------
    
    if not none? true-command: select true-command-list to-word short-command [
        short-command: true-command
    ]    
    
    ;-------------------------------------------------
    shortcuts-list: extract true-command-list 3 
    append shortcuts-list [cache ls outdated shrinkwrap]

    if boot [        
        ; code generation for keyword functions
        ; example for list keyword:
        ; list: function[][npm list]
        ; forall shortcuts-list [
        ;     shortcut: shortcuts-list/1
        ;     block-code: copy [npm]
        ;     append block-code shortcut
        ;     f: function[] block-code
        ;     set in system/words shortcut :f
        ; ]
        return true
    ]
    ;-------------------------------------------------

    append shortcuts-list 'cache
    no-confirmation-list: shortcuts-list
    confirmation-list: [clean]

    no-confirmation: false
    ;found?: find no-confirmation-list to-word short-command 
    keyword: to-word (form >command)
    found?: find no-confirmation-list to-word keyword
    if found? [
        found?: find confirmation-list keyword
        unless found? [
            no-confirmation: true
        ]
    ]

    ;-------------------------------------------------
    switch short-command [
        "cache" [
            folder: rejoin [get-env "APPDATA" {\} "npm-cache"]
            unless value? 'explorer [
                do https://redlang.red/explorer
            ]
            explorer folder
            return true
        ]
    ]
    npm-command: rejoin [{npm } short-command] 
    powershell-command: rejoin [{powershell -Command } {"} npm-command {"}]

    unless no-confirmation [

        question: rejoin [{Confirm: } npm-command { (Y="Yes" or else = Cancel): }]
        unless no-options [
            question: rejoin [{Confirm: } npm-command { (Y="Yes" O="Options" or else = Cancel): }]
        ]
        
        ans: ask question
        .do-events/no-wait

        if ans <> "Y" [
            return ans
        ]
    ]
    out: copy ""
    print npm-command
    call/wait/output powershell-command out 
    print out
    return out
]
.alias .npm [npm]


; / -------------------  npm install function  ------------------
.npm-install: function [
    {Will install a package with options

    Usage examples:
        - install jsdoc
        - install/locally underscore@1.8.2
        - install/locally/version underscore 1.8.2
    }
    '>package 
    /version {precise version} '>version {semantic version: major.minor.patch}
    /locally
    ][
    package: form >package
    >version: form >version
    if version [
        package: rejoin [package {@} >version]
    ]

    npm-command: rejoin [{install } {-g } package]

    ans: "N"
    unless locally [
        
        .do-events/no-wait
        ans: npm (npm-command)
        .do-events/no-wait
        
    ]

    either (ans = "O") or locally [
        replace npm-command {-g } {}
        Print replace/all {Do you want to:
            1.1 install <%package%> locally and save it in dependencies (package.json created if necessary)
            1.2 install <%package%> locally and save it in devDependencies (package.json created if necessary)
            1.3 install <%package%> locally and save it in optionalDependencies (package.json created if necessary)
            2. install <%package%> locally without saving it to your local package.json
        } {<%package%>} package
        ans: ask "Select Option number or else to Cancel: "
        switch/default ans [
            "1.1" [
                if not exists? %package.json [init]
                npm-command: rejoin [npm-command { --save}]               
            ]
            "1.2" [
                if not exists? %package.json [init]
                npm-command: rejoin [npm-command { --save-dev}]               
            ]      
            "1.3" [
                if not exists? %package.json [init]
                npm-command: rejoin [npm-command { --save-optional}]               
            ]                   
            "2" [
                ;npm/no-confirmation (npm-command)
            ]
        ][
            return false
        ]
        npm/no-confirmation (npm-command) 
        npm-command: "list"
        npm/no-confirmation/locally (npm-command) 
    ][
        npm-command: "list --global --depth=0"
        npm/no-confirmation (npm-command) 
    ]
]

.alias .npm-install [npm-install]


; / -------------------  npm update function  ------------------
.npm-update: function [
    {Update package}
    '>package {package name or all}
    /global
][
    
    package: form >package

    outdated
    either package = "all" [
        npm-command: 'update
    ][
        npm-command: rejoin [{update } package]
    ]
    either global [
        npm-command: rejoin [npm-command { } {-g}]
    ][
        if package = "npm" [
            ans: ask {Do you want to update npm package globally ("Y" = "YES"): }
            if ans = "Y" [
                npm-command: rejoin [npm-command { } {-g}]
            ]
        ]
    ]
    
    npm/no-options (npm-command)
]

.alias .npm-update [npm-update]


; / -------------------  npm uninstall function  ------------------
.npm-uninstall: function [
    {Will uninstall a package with options

    Usage examples:
        - uninstall jsdoc
        - uninstall/locally underscore@1.8.2
        - uninstall/locally/version underscore 1.8.2
    }
    '>package 
    /version {precise version} '>version {semantic version: major.minor.patch}
    /locally
    ][
    package: form >package
    >version: form >version
    if version [
        package: rejoin [package {@} >version]
    ]

    npm-command: rejoin [{uninstall } {-g } package]

    ans: "N"
    unless locally [
        ans: npm (npm-command)
    ]

    either (ans = "O") or locally [
        replace npm-command {-g } {}
        ; Print replace/all {Do you want to:
        ;     1.1 uninstall <%package%> locally and save it in dependencies (package.json created if necessary)
        ;     1.2 uninstall <%package%> locally and save it in devDependencies (package.json created if necessary)
        ;     1.3 uninstall <%package%> locally and save it in optionalDependencies (package.json created if necessary)
        ;     2. uninstall <%package%> locally without saving it to your local package.json
        ; } {<%package%>} package
        ; ans: ask "Select Option number or else to Cancel: "
        ; switch/default ans [
        ;     "1.1" [
        ;         if not exists? %package.json [init]
        ;         npm-command: rejoin [npm-command { --save}]               
        ;     ]
        ;     "1.2" [
        ;         if not exists? %package.json [init]
        ;         npm-command: rejoin [npm-command { --save-dev}]               
        ;     ]      
        ;     "1.3" [
        ;         if not exists? %package.json [init]
        ;         npm-command: rejoin [npm-command { --save-optional}]               
        ;     ]                   
        ;     "2" [
        ;         ;npm/no-confirmation (npm-command)
        ;     ]
        ; ][
        ;     return false
        ; ]
        npm/no-confirmation (npm-command) 
        npm-command: "list"
        npm/no-confirmation/locally (npm-command) 
    ][
        npm-command: "list --global --depth=0"
        npm/no-confirmation (npm-command) 
    ]
]

.alias .npm-uninstall [npm-uninstall]


; / -------------------  npm search function  ------------------
.npm-search: function ['>package][
    package: form >package
    npm-command: rejoin [{search} { } package]
    npm/no-confirmation (npm-command) 
]

.alias .npm-search [npm-search]


; / -------------------  npm list function  ------------------
.npm-list: function [/locally][
    npm-command: "list"
    either locally [
        npm/no-confirmation/locally (npm-command)         
    ][
        npm/no-confirmation (npm-command)          
    ]
]

.alias .npm-list [npm-list]


; / -------------------  npm docs function  ------------------
.npm-docs: function ['>package][
    package: form >package
    npm-command: rejoin [{docs} { } package]
    npm/no-confirmation (npm-command) 
]

.alias .npm-docs [npm-docs]






; / -------------------  npm boot  ------------------
.npm/boot
print "" ; weird without this line next line doesn't execute


;help npm
;npm version
;npm cache
;npm config

help npm
print {Type "help npm" to show this help again}

