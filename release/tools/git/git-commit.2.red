Red [
    Title: "git-commit.2.red"
    Builds: [
        0.0.0.1 {Initial build}
    ]
    Iterations: [
        15 {system/lexer/pre-load: func [src part][]}
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

system/lexer/pre-load: func [src part][]

unless value? '.redlang [
    do https://redlang.red
]
.redlang [call-powershell string-expand alias cache]
.quickrun [git-status]

.git-commit: function [
    {Commit and push to remote repository unless /no-push}
    '>message {commit message}    
    /no-push {don't push to remote repository after commit}    
    ][

    switch type?/word get/any '>message [
        unset! [
            >message: ask "commit message (Enter to cancel) : "
            if >message = "" [
                print "cancelling git commit."
                exit
            ]
        ]
    ]        

    message: form :>message ; convert to string

    folder: to-local-file what-dir
    git-command: {git add -A -- .;git commit -m "<%message%>"}
    
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
        out: .call-powershell/out command
    ] [
        print ["commit done"]
        .git-status ; 0.0.0.2.01.2
        return true
    ]
    return false
]

.alias .git-commit [commit .commit git-commit .git-commit .cm cm]
