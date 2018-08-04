Red [
    Title: "npm.red"
    .links: [
        https://www.sitepoint.com/beginners-guide-node-package-manager/
    ]
    Build: [
        0.0.0.1 {Initial version}
    ]
    Iterations: [
        0.0.0.1.2 {/no-options}
        0.0.0.1.1 {/no-confirmation}
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
][

    short-command: form >command
    no-confirmation-list: [
        version 
        global 
        config 
        cache 
        list
    ]

    if find no-confirmation-list to-word short-command [
        no-confirmation: true
    ]

    switch short-command [
        "version" [
            short-command: "--version"
        ]
        "list" [
            short-command: "list --global"
        ]
        "global" [
            short-command: "config get prefix"
        ]
        "config" [
            short-command: "config list"         
        ]
        "cache" [
            folder: rejoin [get-env "APPDATA" {\} "npm-cache"]
            unless value? 'explorer [
                do https://redlang.red/explorer
            ]
            ;call/wait rejoin [{start explorer } {"} folder {"}]
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

version: does [
    npm version
]

global: does [
    npm global
]

config: does [
    npm config
]

list: does [
    npm list
]

list