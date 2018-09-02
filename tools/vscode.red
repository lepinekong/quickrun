Red [
    Title: "vscode.red"
    SemVer: [1.0.0 {alpha}] ; semantic version 
    Builds: [
        0.0.0.1 {Initial Build}
    ]
    Iterations: [
        1 {Initial Iteration
            - core feature
            - documentation
        }
    ]
]

.VSCode:  function [
    {Open Visual Studio Code with optional file or folder}
    '>file.or.folder [word! string! file! url! block! unset!] 
    /browse
    /project
][
    file-or-folder: to-local-file to-red-file form :>file.or.folder
    command: rejoin ["code" { } {"} file-or-folder {"}]

    call/show command
]

VSCode: :.VSCode