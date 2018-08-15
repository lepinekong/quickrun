Red [
    Title: "amend.red"
]

do https://quickrun.red/git-commit
do https://quickrun.red/git-amend
do https://redlang.red/cd
cd %../
commit {fix git.html.red -> git.html}
