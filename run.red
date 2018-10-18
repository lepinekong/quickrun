Red [
    File: ".run"
    Title: ".run"
    Html-Proxy: https://quickrun.red/run.html
    Description: {
        run an exe or msi file
    }
    Features: [
        
    ]
    Builds:[
        0.0.0.1.1.2 {run red}
    ]
    TODO: [
        1 {allow todo: 1.}
        2 {...}
    ]
]

unless value?  '.get-short-filename [
    do https://redlang.red
]
.redlang [alias]

.run: function [
    'param>executable-file [word! string! file! url! block! unset!] 
    /parallel ; TODO: see example .system\.code\.core\.facilities\.system.facilities.backup.red
    /_build {Build number for developer}
    /silent {don't print message on console}   
    /_debug {debug mode} 
][

    >builds: 0.0.0.0.1.1

    if _build [
        unless silent [
            print >builds
        ]
        return >builds
    ]

    ;TODO: if Red Chrome, Explorer, Powershell, DOS, WSL,...


    switch/default type?/word get/any 'param>executable-file [
        unset! [
            print {TODO:}
        ]
        word! [
            if param>executable-file = 'red [
                param>executable-file: SYSTEM/OPTIONS/BOOT
                .run (param>executable-file)
            ]
        ]
        string! file! url! [
            param>executable-file: form param>executable-file
            local>exe-file: to-local-file to-red-file param>executable-file
            ext: suffix? local>exe-file
             switch/default ext [
                 %.exe [
                     call/show rejoin ["cmd /c " {"} local>exe-file {"}]
                 ]
                 %.msi [
                     call/show rejoin [{msiexec "} local>exe-file {"}]
                 ]
                 %.bat [
                     
                     print {TODO:
        template: {<%CompSpec%> /c <%local.system.path%>.System.bat ".backup/parallel {<%message%>}"}
        cmd: build-markup/bind template context compose [
            CompSpec: (select LIST-ENV "ComSpec")
            local.system.path: (to-local-file .system.path)
            message: (message)
        ]

        replace/all cmd "^/" ""
        call cmd
                     }

                     call/show rejoin [
                         (select LIST-ENV "ComSpec") ; "C:\WINDOWS\system32\cmd.exe"
                         { /c } 
                         {"} local>exe-file {"}
                    ]
                 ]                 
             ][
                 print [ext "unknown."]
             ]
        ]
        block! [
            print [{TODO:}]
        ]
    ] [
        throw error 'script 'expect-arg param>executable-file
    ]
]

.alias .run [run]
