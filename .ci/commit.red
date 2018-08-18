Red [
    Title: "cd.red"
]

url: https://quickrun.red/git-clone

do https://quickrun.red/git-commit
cd %../
commit {f git-clone/version}
ask "pause..."
write-clipboard read url
do url

