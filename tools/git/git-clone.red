Red [
    Title: "git-clone.red"
    Builds: [
        0.0.0.1 {Initial Build - weird doesn't appear in git change}
    ]
]

do https://redlang.red/dot.do
.do/redlang [
    call-powershell string-expand
]

.git-clone: function ['>repo][

    repo: form >repo
    command-template: {git clone <%repo%>}
    command: .expand command-template [
        repo: (repo)
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

git-clone: :.git-clone
clone: :.git-clone
cl: :.git-clone

