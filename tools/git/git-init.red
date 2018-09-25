Red [
    Title: ""
    Needs: 'View
]

if not value? '.redlang [
    do https://redlang.red
]

.redlang [
    call-powershell
]

.git-init: function [
    /version
    /help
][
    if version [
        print 0.0.0.1.1
    ]

    if help [
        .links: [
            https://git-scm.com/docs/git-init
        ]
    ]

    command: {git init}

    unless error? try [
        .call-powershell/out command
    ][
        print ["done"]
        return true
        exit
    ]
    return false
]

git-init: :.git-init
init: :.git-init
