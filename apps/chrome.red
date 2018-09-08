Red [
    Title: "chrome"
]

.chrome: func [
    '.urls [string! word! url! unset! block! path!]
    /_build
    /silent
][   

    if _build [
        >builds: [
            0.0.0.1.3 {case: word! and no extension}
        ]
        unless silent [
            ?? >builds
        ]
        return _build
    ]

    switch/default type?/word get/any '.urls [
        unset! [
            print {
                Examples:
                Chrome https://github.com
            }
        ]
        word! string! url![                  
            url: form .urls
            either suffix? urls [
                unless (copy/part url 4) = "http" [
                    url: rejoin ["https://" url]
                ]
            ][
                url: rejoin ["https://" url ".com"]
            ]
            call rejoin [{start chrome} { } urls] 
        ]
        path! [
            if not value? 'favorites [
                .do %.system.apps.internet.favorites.red
            ]
            block: reduce .urls
            go (block)
        ]
        block! [
            block: :.urls
            foreach [title url] block [
                url: form url
                url: to-url
                go (url)
            ]
        ]    
    ][
        throw-error 'script 'expect-arg .urls
    ]

]

chrome: :.chrome
goto: :.chrome
go: :.chrome
browse: :.chrome