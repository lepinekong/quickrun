Red [
    Title: "chrome"
]

if not value? '.redlang [
    do https://redlang.red
]
.redlang [files get-folder]

.chrome: func [
    '.urls [string! word! url! unset! block! path!]
    /_build
    /silent
][   

    if _build [
        >builds: [
            0.0.0.1.15 {Fix attempt for Error: duplicate variable specified: /local caused by files lib}
            0.0.0.1.14 {Release Bug fix attempt for keyword with full url.}
            0.0.0.1.9 {Bug fix attempt for keyword with full url.}
            0.0.0.1.7 {Bug keyword for full url}
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

    create-keyword: function [keyword /url >url][
        keyword: to-word keyword
        either not value? keyword [ ; 0.0.0.1.5
            func-body: compose/deep/only [ ; 0.0.0.1.4
                either url [
                    go (>url) ; 0.0.0.1.12: fix stupid 0.0.0.1.11 bug : url instead of >url
                ][
                    go (keyword)
                ]
                
            ]
            ?? func-body
            set keyword does func-body
        ][
            ; keyword already
        ]
        return keyword
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

            to-keyword: function [url][
                domain: get-folder (url) ; 0.0.0.1.9 fixed 0.0.0.1.8 BUG missing ()
                domain: pick (split domain "/") 4
                keyword: to-word form first split domain "."                 
            ]

            either suffix? url [ ; github.com
                unless (copy/part url 4) = "http" [
                    url: rejoin ["https://" url] ; https://github.com
                ]

                keyword: create-keyword (to-keyword url) ; create-keyword 'github
            ][

                if error? try [
                    keyword: to-word url
                    url: rejoin ["https://" url ".com"]
                ][
                    keyword: create-keyword/url (to-keyword url) (url) ; 0.0.0.1.10
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