Red [
    Title: "explorer.red"
    Origin: "redlang.red\build\debug\download.red\0.0.0.1\01\cache\explorer.4.red"
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
        0.0.0.2.5 {alpha version}
        0.0.0.1.9 {initial release}
    ]

    if _build [
        unless silent [
            ?? >builds
        ]
        return >builds
    ]

    if _debug [
        .redlang [do-trace]
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

    while [find >file-or-folder "\\"][replace >file-or-folder "\\" "\"]

    ;--- get folder and file if any
    file-or-folder:  to-red-file form :>file-or-folder
    .folder: clean-path .get-folder file-or-folder

    .filename: get-short-filename file-or-folder

    .local-folder: to-local-file .folder

    ;--- call explorer
    
    either .filename [ ; 0.0.0.1.1.13

        either ((dir? .filename) or (none? file-or-folder))  [
            command: rejoin [{explorer.exe} { } {"} .local-folder {"}]
        ][
            command: rejoin [{explorer.exe} { } {/select,} { } {"} to-local-file clean-path file-or-folder {"}]
        ]
    ][

        command: rejoin [{explorer.exe} { } {"} .local-folder {"}]
    ]

    

    if _debug [

        do-trace 75 [
            ?? command
        ] %explorer.5.red

        ;start explorer.exe -ArgumentList "/select, `"$demofolder\$demo.red`""
    ]
    call/show command
    
]

explorer: :.explorer
