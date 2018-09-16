Red [
    Title: ""
    Needs: 'View
    .code: [
        Linux: {git config credential.helper store}
        Windows: {git config --global credential.helper wincred}
    ]
]

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

    command: {git config --global credential.helper wincred}

    unless error? try [
        .call-powershell/out command
    ] [
        print ["done"]
        return true
        exit
    ]
    return false
]
