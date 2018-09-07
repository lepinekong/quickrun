Red [
    Title: "chrome"
]

.chrome: func ['.urls [string! word! url! unset! block! path!]][   

    switch/default type?/word get/any '.urls [
        unset! [
            print {
                Examples:
                Chrome https://github.com
            }
        ]
        string! url![                  
            urls: form .urls
            if suffix? urls [
                unless (copy/part urls 4) = "http" [
                    urls: rejoin ["https://" urls]
                ]
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