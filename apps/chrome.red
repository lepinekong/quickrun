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
            0.0.0.1.6 {fix automatic keyword part 2}
            0.0.0.1.5 {automatic keyword part 2}
            0.0.0.1.4 {automatic keyword}
            0.0.0.1.3.2 {case: word! and no extension}
        ]
        unless silent [
            ?? >builds
        ]
        return _build
    ]

    create-keyword: function [keyword][
        keyword: to-word keyword
        either not value? keyword [ ; 0.0.0.1.5
            set keyword does compose/deep/only [ ; 0.0.0.1.4
                go (keyword)
            ]
        ][
            ;print [{You can also just type: } keyword] ; 0.0.0.1.6:  BUG 0.0.0.1.5 should not be there
        ]
    ]

    switch/default type?/word get/any '.urls [
        unset! [
            print {
                Examples:
                Chrome https://github.com
                Chrome github.com
                Chrome github
            }
        ]
        word! string! url![                  
            url: form .urls
            either suffix? url [
                unless (copy/part url 4) = "http" [
                    url: rejoin ["https://" url]
                ]
                domain: get-folder url
                domain: pick (split domain "/") 4
                keyword: first split domain "."
                create-keyword keyword
            ][
                keyword: to-word url
                url: rejoin ["https://" url ".com"]
                either not value? keyword [ ; 0.0.0.1.5
                    set keyword does compose/deep/only [ ; 0.0.0.1.4
                        go (keyword)
                    ]
                ][
                    ;print [{You can also just type: } keyword] ; 0.0.0.1.6:  BUG 0.0.0.1.5 should not be there
                ]
            ]
            call rejoin [{start chrome} { } url] 
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