Red [
    Title: "npm.red"
    .links: [
        https://www.sitepoint.com/beginners-guide-node-package-manager/
        https://docs.npmjs.com/getting-started/installing-npm-packages-locally
        https://kapeli.com/cheat_sheets/npm.docset/Contents/Resources/Documents/index
    ]
    Build: [
        0.0.0.1 {First version}
    ]
    Iterations: [
        0.0.0.1.8 {Search}
        0.0.0.1.7 {Cleaning}
        0.0.0.1.6 {initial-directory - FIXED BUG }
        0.0.0.1.5 {initial-directory - BUG }
        0.0.0.1.4 {release}
        0.0.0.1.3 {code generation}
        0.0.0.1.2 {refactoring of shortcuts-list}
        0.0.0.1.1 {Initial version}
    ]
]


npm: function [
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
    /local initial-directory
][

    initial-directory: copy []

    if empty? initial-directory [
        folder: pick split-path system/options/script 1
        either not none? folder [
            append initial-directory folder
        ][
            append initial-directory what-dir
        ]
    ] 

    short-command: form >command

    true-command-list: [
        version "--version"
        global "config get prefix"
        config "config list"
        init "init --y"
    ]

    json-file: to-red-file rejoin [initial-directory/1 %package.json]
    either exists? json-file [
        append true-command-list  [list "list"]
    ][
        append true-command-list  [list "list --global --depth=0"]
    ]
    
    if not none? true-command: select true-command-list to-word short-command [
        short-command: true-command
    ]
    
    shortcuts-list: extract true-command-list 2 
    append shortcuts-list [cache ls outdated]

    if boot [        
        ; code generation for keyword functions
        ; example for list keyword:
        ; list: function[][npm list]
        forall shortcuts-list [
            shortcut: shortcuts-list/1
            block-code: copy [npm]
            append block-code shortcut
            f: function[] block-code
            set in system/words shortcut :f
        ]
        return true
    ]

    append shortcuts-list 'cache
    no-confirmation-list: shortcuts-list

    if find no-confirmation-list to-word short-command [
        no-confirmation: true
    ]

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

install: function [
    {Will install a package with options

    Usage examples:
        - install jsdoc
        - install underscore@1.8.2
        - install/version underscore 1.8.2
    }
    '>package 
    /version {precise version} '>version {semantic version: major.minor.patch}
    ][
    package: form >package
    >version: form >version
    if version [
        package: rejoin [package {@} >version]
    ]
    npm-command: rejoin [{install } {-g } package]
    ans: npm (npm-command)
    if ans = "O" [
        replace npm-command {-g } {}
        Print {Do you want to:
            1.1 install locally and save in dependencies (package.json created if necessary)
            1.2 install locally and save in devDependencies (package.json created if necessary)
            1.3 install locally and save in optionalDependencies (package.json created if necessary)
            2. install locally without saving to your local package.json
        }
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
    ]
]

update: function [
    {Update package}
    '>package {package name or all}
][
    
    package: form >package

    outdated
    either package = "all" [
        npm/no-options update
    ][
        npm-command: rejoin [{update } package]
        npm/no-options npm-command
    ]

]

search: function ['>package][
    package: form >package
    npm-command: rejoin [{search } package]
    npm/no-confirmation (npm-command) 
]

;help npm
;npm version
;npm cache
;npm config

npm/boot
print "" ; weird without this line next line doesn't execute
