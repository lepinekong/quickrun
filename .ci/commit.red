Red [
    Title: "cd.red"
]

do https://redlang.red
.redlang [log cd]

msg: ask "msg: "
log %commit.log msg

do https://quickrun.red/git-commit
cd %../
commit (msg)

