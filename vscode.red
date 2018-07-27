Red [
    Title: "vscode.red"
]

.VSCode:  function['>file.or.folder [word! string! file! url! block! unset!] /local ][

    file-or-folder: to-local-file to-red-file >file.or.folder

    call/show rejoin ["code" { } {"} file-or-folder {"}]
]

VSCode: :.VSCode
