Red [
    Title: "git-amend.1.red"
    .links: [
        https://stackoverflow.com/questions/179123/how-to-modify-existing-unpushed-commits
        https://help.github.com/articles/changing-a-commit-message/
        https://gist.github.com/nepsilon/156387acf9e1e72d48fa35c4fabef0b4
    ]
]

unless value? '.call-powershell [
    do https://redlang.red/call-powershell.red
]

unless value? '.string-expand [
    do https://redlang.red/string-expand
]

do https://redlang.red/cd ; cd doesn't work

.git-amend: function ['>message /no-push][

    message: form >message
    folder: to-local-file what-dir
    command-template: {set-location '<%folder%>';git commit --amend -m "<%message%>";git push}
    if no-push [
        command-template: {set-location '<%folder%>';git commit --amend -m "<%message%>"}
    ]
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

git-amend: :.git-amend
amend: :.git-amend