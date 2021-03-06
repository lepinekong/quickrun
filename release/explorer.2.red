Red [
    Title: "explorer.red"
]

if not value? '.redlang [
    do https://redlang.red
]

.explorer: function [
    '>file-or-folder [any-type! unset!]
    /_build
    /silent
    /_debug
][

    >builds: [
        0.0.0.2.2 {}
        0.0.0.1.9 {initial release}
    ]

    if _build [
        unless silent [
            ?? >builds
        ]
        return >builds
    ]

    ;--- requires
    .redlang [files get-folder]

    ;--- if no file
    switch/default type?/word get/any '>file-or-folder [
        unset! [
            >file-or-folder: clean-path %./
        ]
    ][
        if (form >file-or-folder) = "." [
            >file-or-folder: %.
        ]
    ]
    ?? >file-or-folder

    ;--- get folder and file if any
    file-or-folder:  to-red-file form :>file-or-folder
    .folder: clean-path .get-folder file-or-folder

    .filename: get-short-filename file-or-folder

    .local-folder: to-local-file .folder
    
    replace .local-folder "\\" "\"

    ;--- call explorer
    
    either .filename [ ; 0.0.0.1.1.13
        either ((dir? .filename) or (none? file-or-folder)) [ ; 0.0.0.1.02.4
            command: rejoin [{explorer.exe} { } {"} .local-folder {"}]
        ][
            command: rejoin [{explorer.exe} { } {/select,} { } {"} to-local-file clean-path file-or-folder {"}]
        ]
    ][
        command: rejoin [{explorer.exe} { } {"} .local-folder {"}]
    ]

    

    if _debug [
        ?? command
    ]
    call/show command

    ;start explorer.exe -ArgumentList "/select, `"$demofolder\$demo.red`""
]

explorer: :.explorer
