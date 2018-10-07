Red [
    Title: ""
    Needs: 'View
]

if not value? '.redlang [
    do https://redlang.red
]

.redlang [
    call-powershell
    confirm
    alias
]

Context [

    set in system/words '.git-status function [
        /version
        /help
    ][
        if version [
            print 0.0.0.1.1
        ]

        if help [
            .links: [
                https://git-scm.com/docs/git-status
            ]
        ]

        command: {git status}

        unless error? try [
            .call-powershell/out command
            ; either confirm (command) [
            ;     .call-powershell/out command
            ; ][
            ;     print rejoin [{abort} " " command "."]
            ;     quit
            ; ]
            
        ][
            print ["done"]
            return true
            exit
        ]
        return false
    ]

]

.alias .git-status [git-status status]
