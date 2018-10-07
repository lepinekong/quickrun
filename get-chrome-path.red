Red [
    Title: "get-chrome-path.red"
]

if not value? '.redlang [
    do https://redlang.red
]
.redlang [alias]

.get-chrome-path: function [][
    return chrome-path: rejoin [{"} get-env "programfiles(x86)" "\Google\Chrome\Application\chrome.exe" {"}]
]

.alias .get-chrome-path [get-chrome-path]
