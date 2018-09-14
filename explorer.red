Red [
    Title: "explorer.red"
]

if not value? '.redlang [
    do https://redlang.red
]

explorer: function [
    '>file-or-folder [any-type! unset!]
    /_build
    /silent
][

    >builds: [
        0.0.0.1.9 {initial release}
    ]

    ;--- requires
    .redlang [files get-folder]

    ;--- if no file
    switch type?/word get/any '>file-or-folder [
        unset! [
            >file-or-folder: clean-path %./
        ]
    ]

    ;--- get folder and file if any
    file-or-folder:  to-red-file form :>file-or-folder
    .folder: clean-path .get-folder file-or-folder

    .filename: get-short-filename file-or-folder

    .local-folder: to-local-file .folder


    ;--- call explorer
    

    either dir? .filename  [
        command: rejoin [{explorer.exe} { } {"} .local-folder {"}]
    ][
        command: rejoin [{explorer.exe} { } {/select,} { } {"} to-local-file clean-path file-or-folder {"}]
    ]
    

    unless silent [
        ?? command
    ]
    call/show command

    ;start explorer.exe -ArgumentList "/select, `"$demofolder\$demo.red`""
]


