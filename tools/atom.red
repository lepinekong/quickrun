Red [
    Title: "atom.red"
    SemVer: [1.0.0 {alpha}]  
    Builds: [
        0.0.0.1 {Initial Build from vscode.3.red build 0.0.0.1}
    ]
    Iterations: [
        1 {Initial Iteration
            - core feature
            - documentation
        }
    ]
]

if not value? '.redlang [
    do https://redlang.red
]

.redlang [alias]

.atom:  function [
    {Open Visual Studio Code with optional file or folder}
    '>file.or.folder [word! string! file! url! block! unset!] 
    /browse
    /project
][
    file-or-folder: to-local-file clean-path to-red-file form :>file.or.folder
    command: rejoin ["code" { } {"} file-or-folder {"}]
    print command ; meta-comment: added in 0.0.0.1.3
    call/show command
]

alias .atom [atom code]

