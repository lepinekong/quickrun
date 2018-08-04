Red [
    Title: "npm.red"
    .links: [
        https://www.sitepoint.com/beginners-guide-node-package-manager/
    ]
    Build: [
        0.0.0.1 {First version}
    ]
    Iterations: [
        0.0.0.1.4 {release}
        0.0.0.1.3 {code generation}
        0.0.0.1.2 {refactoring of shortcuts-list}
        0.0.0.1.1 {Initial version}
    ]
]

npm: function [
    {Usage: 
    - npm version: get version
    - npm global: get global install directory
    - npm <your-command>: custom command
    }
    '>command "your command"
    /no-confirmation "don't ask confirmation"
    /no-options "don't propose options"
    /init
][

    short-command: form >command

    true-command-list: [
        version "--version"
        global "config get prefix"
        config "config list"
        list "list --global"
    ]
    
    if not none? true-command: select true-command-list to-word short-command [
        short-command: true-command
    ]
    
    shortcuts-list: extract true-command-list 2 

    if init [
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

;help npm
;npm version
;npm cache
;npm config

npm/init
print "" ; weird without this line next line doesn't execute