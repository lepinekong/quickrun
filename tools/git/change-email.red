Red [
    Title: "change-email.1.red"
]


.change-email: function ['>email [string! email! unset!]][

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
    command-template: {git config --global user.email <%>email%>}
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