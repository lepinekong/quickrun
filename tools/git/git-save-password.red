Red [
    Title: ""
    Needs: 'View
    .code: [
        Linux: {git config credential.helper store}
        Windows: {git config --global credential.helper wincred}
    ]
]

if not value? '.redlang [
    do https://redlang.red
]
.redlang [alias call-powershell]

.git-save-password: function [
    /version
    /help
][
    if version [
        print 0.0.0.1.1
    ]

    if help [
        .links: [
            https://help.github.com/articles/caching-your-github-password-in-git/
            https://help.github.com/articles/caching-your-github-password-in-git/
        ]
    ]

    #if config/OS = 'Windows [
        print "OS=Windows"
        command: {git config --global credential.helper wincred}

        unless error? try [
            .call-powershell/out command
        ] [
            return true
            exit
        ]
    ]

    return false
]

alias .git-save-password [git-save-password]

git-save-password

