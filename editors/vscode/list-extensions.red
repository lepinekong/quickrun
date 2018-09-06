Red [
    Title: ""
]

if not value? '.redlang [
    do https://redlang.red
]
.redlang [call-powershell]

.list-extensions: function [][
    .call-powershell/out {code --list-extensions}
]