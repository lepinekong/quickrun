Red [
    Title: "chrome"
]

.chrome: func ['.urls [string! word! url! unset! block! path!]][   

    switch/default type?/word get/any '.urls [
        unset! [
        ]
        string! url![                  
            urls: form .urls
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