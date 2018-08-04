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
    - npm version
    - npm <your-command>
    }
    '>command "your command"
    /no-confirmation "don't ask confirmation"
    /no-options
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


