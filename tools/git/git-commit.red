Red [
    Title: "git-commit.1.red"
    Builds: [
        0.0.0.1 {Initial build}
    ]
    Iterations: [
        5 {fix annoyances
            - when msg passed as variable must use ()
            - double powershell printing log
        }
        4 {/no-push}
    ]
]

unless value? '.call-powershell [
    do https://redlang.red/call-powershell.red
]

unless value? '.string-expand [
    do https://redlang.red/string-expand
]

do https://redlang.red/cd ; cd doesn't work


.git-commit: function ['>message /no-push][

    message: form >message
    folder: to-local-file what-dir
    command-template: {set-location '<%folder%>';git add -A -- .;git commit -m "<%message%>";git push}
    if no-push [
        command-template: {set-location '<%folder%>';git add -A -- .;git commit -m "<%message%>"}
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

git-commit: :.git-commit
commit: :.git-commit
cm: :.git-commit
