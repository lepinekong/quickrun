Red [
    Title: "vscode.red"
]

.VSCode:  function['.file.or.folder [word! string! file! url! block! unset!] /local ][
    switch/default type?/word get/any '.file.or.folder [
        unset! [
            .sysVSCode
            exit
        ]
        word! [
            ;value? get in system/words '.system.user.path
            if value? get in system/words .file.or.folder [
                file.or.folder: get in system/words .file.or.folder
                either exists? red-file: to-red-file form .file.or.folder [
                    file.or.folder: to-local-file red-file
                ][
                    ;VSCode MyMementos
                    body: body-of :file.or.folder

                    ;%/C/rebol/system/.activities/MyMementos
                    domain-path: to-file (rejoin body/paths) 
                    file.or.folder: to-local-file domain-path

                ]
            ]
        ]
        string! file! url! block! [
            either exists? red-file: to-red-file form .file.or.folder [
                file.or.folder: to-local-file red-file
            ][
                .sysVSCode .file.or.folder
            ]
        ]
    ] [
        throw error 'script 'expect-arg .file.or.folder
    ]
    call/show rejoin ["code" { } {"} file.or.folder {"}]
]

VSCode: :.VSCode
