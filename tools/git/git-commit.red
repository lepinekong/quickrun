Red [
    Title: "git-commit.1.red"
    Builds: [
        0.0.0.1 {Initial build}
    ]
    Iterations: [
        3 {
unless value? 'syscd [
    do https://redlang.red/cd
]
        }
    ]
]

unless value? '.call-powershell [
    do https://redlang.red/call-powershell.red
]

unless value? '.string-expand [
    do https://redlang.red/string-expand
]

unless value? 'syscd [
    do https://redlang.red/cd
]


.git-commit: function ['>message][

    message: form >message
    folder: to-local-file what-dir
    command-template: {set-location '<%folder%>';git add -A -- .;git commit -m "<%message%>"}
    command: .expand command-template [
        folder: (folder)
        message: (message)
    ]

    print "starting..."
    unless error? try [
        .call-powershell/out command
    ] [
        print ["done"]
        return true
    ]
    return false
]

git-commit: :.git-commit
commit: :.git-commit
cm: :.git-commit
