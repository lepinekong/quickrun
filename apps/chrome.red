Red [
    Title: "chrome"
]

if not value? '.redlang [
    do https://redlang.red
]
.redlang [files get-folder]

config-filename: %quickrun.browser.config.red 
config-directory: get-folder (system/options/boot)

config-file: rejoin [config-directory config-filename]

unless exists? config-file [

    redlang [request-dir]

    if not value? 'Favorites [
        Favorites: [
            Main: [
                github: https://github.com/lepinekong?tab=repositories
                twitter: https://twitter.com
                gitter: https://gitter.im/red/help
            ]    
            Daily: [
                pragmatists: https://blog.pragmatists.com
                Dzone: https://dzone.com
                Devto: https://dev.to/
                Redlang: https://gitter.im/red/help
                dormoshe: https://dormoshe.io/daily-news
                futurism: https://futurism.com/
            ]
            Weekly: [
                JSWeekly: https://javascriptweekly.com
                MyBridge: https://medium.mybridge.co/@Mybridge
            ]    

            Monthly: [
                Codemag: http://www.codemag.com/Magazine/AllIssues
                VSMag: https://visualstudiomagazine.com/Home.aspx
                MSDN: https://msdn.microsoft.com/en-us/magazine/msdn-magazine-issues.aspx
            ]
        ]
    ]

    write/lines/append config-file rejoin [
        {Favorites: } Favorites
    ] 
]

do load config-file

.edit-config-browser: function [][
    command: rejoin [{notepad.exe } {"} to-local-file config-file {"}]
    call/show command
]

alias .edit-config-browser [edit-config-browser .edit-browser-config edit-browser-config]


.delete-config-browser: function [][
    redlang [confirm]
    if confirm rejoin ["delete " config-file][
        delete config-file
    ]
]

alias .delete-config-browser [.delete-browser-config delete-config-browser delete-browser-config ]


create-keyword: function [keyword /url >url][
    keyword: to-word keyword
    either not value? keyword [ ; 0.0.0.1.5
        if not  url [
            >url: keyword ; 0.0.0.16
        ]

        func-body: compose/deep/only [ ; 0.0.0.1.4
                go (>url) ; 0.0.0.16 
        ]
        set keyword does func-body
    ][
        ; keyword already
    ]
    return keyword
]

foreach [keyword url] favorites/main [
    create-keyword/url keyword url
] 

.chrome: func [
    '.urls [string! word! url! unset! block! path!]
    /_build
    /silent
][   

    if _build [
        >builds: [
            0.0.0.3.3 {Create keywords from favorite/main}
            0.0.0.2.13
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

chrome: :.chrome
goto: :.chrome
go: :.chrome
browse: :.chrome