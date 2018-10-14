Red [
    File: "terminal"
    Title: "terminal"
    Html-Proxy: https://https://quickrun.red/terminal
    Description: {
        open terminal
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

unless value? '.redlang [
    do https://redlang.red
]
.redlang [alias]

.terminal: function [
    'param>arg [word! string! file! url! block! unset!] 
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

    switch/default type?/word get/any 'param>arg [
        unset! [
            call {start cmd}
        ]
        word! string! file! url! block! [
            param>arg: form param>arg
        ]
    ] [
        throw error 'script 'expect-arg param>arg
    ]
]

.alias .terminal [terminal]
