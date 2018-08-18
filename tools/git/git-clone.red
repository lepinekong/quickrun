Red [
    Title: "git-clone.red"
    Builds: [
        0.0.0.1.3 {Added version}
        0.0.0.1.2 {Ask repo if not passed}
        0.0.0.1.1 {Initial Build}
    ]
]

do https://redlang.red/dot.do
.do/redlang [
    call-powershell string-expand cd confirm
]

.git-clone: function [
    '>repo [any-type!]
    /version
][
    if version [
        print 0.0.0.1.3
    ]

    switch type?/word get/any '>repo [
        unset! [
            >repo: to-url ask "repo (url, folder): "
        ]
    ]    

    repo: form >repo
    command-template: {git clone <%repo%>}
    command: .expand command-template [
        repo: (repo)
    ]

    if not confirm rejoin [{local repo: } what-dir][
        folder: request-dir
        cd (folder)
    ]
    print "starting..."
    unless error? try [
        .call-powershell/out command
    ] [
        print ["done"]
        return true
        exit
    ]
    return false
]

git-clone: :.git-clone
clone: :.git-clone
cl: :.git-clone

