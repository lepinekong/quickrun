Red [
    Title: "npm.red"
    .links: [
        https://www.sitepoint.com/beginners-guide-node-package-manager/
    ]
]

npm: function [
    {Usage: 
    - npm version
    - npm <your-command>
    }
    '>command "your command"
    /no-confirmation "don't ask confirmation"
][

    short-command: form >command

    switch short-command [
        "version" [
            short-command: "--version"
            no-confirmation: true
        ]
    ]
    npm-command: rejoin [{npm } short-command] 
    powershell-command: rejoin [{powershell -Command } {"} npm-command {"}]
    unless no-confirmation [
        ans: ask rejoin [{Confirm: } npm-command { (Y="Yes" O="Options" else = Cancel): }] 
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


