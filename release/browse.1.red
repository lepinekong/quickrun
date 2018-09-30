Red [
    Title: ""
]

.browse: func [
    '.urls [string! word! url! unset! block! path!]
    /_build
    /silent
][   

    if _build [
        >builds: [
            0.0.0.1 {Initial version}
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
                Go https://github.com
                Go github.com
                Go github
                Go https://github.com/lepinekong?tab=repositories
                Go favorites/Daily
            }
        ]
        word! string! url![

            url: form .urls

                to-keyword: function [url][

                    rule: [
                        "https://" copy keyword to "."
                        |
                        "http://" copy keyword to "."
                        |
                        copy keyword to "."
                        |
                        copy keyword to end  
                    ]
                    parse url rule
                    return keyword
                ]

            either suffix? url [ ; github.com

                unless (copy/part url 4) = "http" [
                    url: rejoin ["https://" url] ; https://github.com
                ]
                keyword: (to-keyword url)
                keyword: create-keyword keyword ; create-keyword 'github

            ][

                if error? try [
                    keyword: create-keyword to-word url ; 0.0.0.1.16 fix bug no keyword
                    url: rejoin ["https://" url ".com"]
                ][
                    keyword: create-keyword/url (to-keyword url) (url) ; 0.0.0.1.10
                ]
            ]
            call rejoin [{start chrome} { } url]
        ]
        path! [
            .urls: (.urls)
            block: reduce (.urls)
            go (block)
        ]
        block! [
            
            block: :.urls

            forall block [
                if url? block/1 [
                    go (block/1)
                ]
                
            ]
            
        ]    
    ][
        throw-error 'script 'expect-arg .urls
    ]
]

goto: :.browse
go: :.browse
browse: :.browse
