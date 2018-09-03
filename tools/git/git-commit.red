Red [
    Title: "git-commit.1.red"
    Builds: [
        0.0.0.1 {Initial build}
    ]
    Iterations: [
        8 {refactoring}
        7 {Optional >message}
        6 {Help documentation}
        5 {fix annoyances
            - when msg passed as variable must use ()
            - double powershell printing log
        }
        4 {/no-push}
    ]
]

unless value? '.redlang [
    do https://redlang.red
]
.redlang [call-powershell string-expand alias]

.git-commit: function [
    {Commit and push to remote repository unless /no-push}
    /no-push {don't push to remote repository after commit}    
    '>message {commit message}
    ][

    switch type?/word get/any '>message [
        unset! [
            >message: ask "commit message (Enter to cancel) : "
            if >message = "" [
                print "cancelling git commit."
                exit
            ]
        ]
        word! string! file! url! block! [
            message: form >message ; convert to string
        ]
    ]        

    folder: to-local-file what-dir
    
    unless no-push [
        git-command: rejoin [git-command {;} {git push}] 
    ]

    command-template: rejoin [{set-location '<%folder%>'} {;} git-command] 

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

.alias .git-commit [commit .commit git-commit .git-commit .cm cm]