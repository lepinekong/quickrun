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
        0.0.0.1.1.1
    ]
    TODO: [
        1 {allow todo: 1.}
        2 {...}
    ]
]

; unless value?  '.get-short-filename [
;     do https://redlang.red
; ]

.run: function [
    'param>executable-file [word! string! file! url! block! unset!] 
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

    ;TODO: if Chrome, Explorer, Powershell, DOS, WSL,...

    switch/default type?/word get/any 'param>executable-file [
        unset! [
            print {TODO:}
        ]
        word! string! file! url! block! [
            param>executable-file: form param>executable-file
            local>exe-file: to-local-file to-red-file param>executable-file
            ext: suffix? local>exe-file
             switch/default ext [
                 %.exe [
                     call/show rejoin [{"} local>exe-file {"}]
                 ]
                 %.msi [
                     call/show rejoin [{msiexec "} local>exe-file {"}]
                 ]
                 %.bat [
                     print {TODO:}
                 ]                 
             ][
                 print [ext "unknown."]
             ]
        ]
    ] [
        throw error 'script 'expect-arg param>executable-file
    ]
]
