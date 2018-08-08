Red [
    Title: "change-email.1.red"
    .links: [
        https://help.github.com/articles/setting-your-commit-email-address-in-git/
    ]
]


.change-email: function [
    '>email [string! email! unset!]
    /github-no-reply
][

    switch/default type?/word get/any '>email [
        unset! [
            >email: ask "Email: "
        ]
        string! email! [
            >email: form >email
        ]
    ] [
        throw error 'script 'expect-arg >email
    ]    

    folder: to-local-file what-dir
    either github-no-reply [
        command-template: {git config --global user.email <%>email%>@users.noreply.github.com}
    ][
        command-template: {git config --global user.email <%>email%>}
    ]
    
    command: .expand command-template [
        folder: (folder)
        message: (message)
    ]

    print "starting git commit..."
    unless error? try [
        .call-powershell/out command
    ] [
        print ["commit done"]
        return true
    ]
    return false
]

change-email: :.change-email
email: :.change-email