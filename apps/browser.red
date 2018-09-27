Red [
    Title: "chrome"
]

__BROWSER_CONFIG_FILE_NAME__: %quickrun.browser.config.red 
__CONFIG_EDITOR__: %notepad.exe ; in 06.edit-config-browser.red
if not value? '.redlang [
    do https://redlang.red
]
.redlang [files get-folder ]
do https://quickrun.red/libs/readable-to-favorites
do https://quickrun.red/res/default-favorites


create-keyword: function [
    keyword /url >url
    /force 
][
    keyword: to-word keyword

    not-value-keyword: not value? keyword

    either not-value-keyword or force [ ; 0.0.0.1.5
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

.browser.context: context [
    config-directory: get-folder (system/options/boot)
    config-filename: __BROWSER_CONFIG_FILE_NAME__ 

    get-config-file: function [][
        return rejoin [config-directory config-filename]
    ]
]

config-browser-filename: .browser.context/config-filename
config-browser-directory: .browser.context/config-directory

config-browser-file: rejoin [config-browser-directory config-browser-filename]

unless exists? config-browser-file [

    if not value? 'Favorites [
        Favorites: readable-to-favorites >default-favorites
    ]
]
.load-config-browser: does [

    if not exists? config-browser-file [
        write/lines/append config-browser-file rejoin [
            {Favorites: } mold >default-favorites
        ]        
    ]
    Favorites: load config-browser-file ; 0.0.0.3.01: changed data format
    Favorites: readable-to-favorites Favorites ; 0.0.0.2.04: bug todo: none
    foreach [keyword url] favorites/main [
        create-keyword/url/force keyword url
    ]     
]

alias .load-config-browser [.reload-config-browser reload-config-browser load-config-browser 
.refresh-config-browser resfresh-config-browser 
.reload-favorites reload-favorites
]

.load-config-browser

.edit-config-browser: function [
    /section '>section
][
    either section [
        
    ][
        command: rejoin [__CONFIG_EDITOR__ { } {"} to-local-file config-browser-file {"}]
        call/show command
    ]

]

alias .edit-config-browser [
    edit-config-browser 
    .edit-browser-config 
    edit-browser-config
    .edit-favorites
    edit-favorites
    edit-bookmarks
    .edit-bookmarks
]

.delete-config-browser: function [][
    redlang [confirm]
    if confirm rejoin ["delete " config-browser-file][
        delete config-browser-file
    ]
]

alias .delete-config-browser [.delete-browser-config delete-config-browser delete-browser-config ]

.chrome: func [
    '.urls [string! word! url! unset! block! path!]
    /_build
    /silent
][   

    if _build [
        >builds: [
            0.0.0.4.6 {Default-Favorites online}
            0.0.0.4.4 {Readable Human Format}
            0.0.0.3.10 {Refresh favorites for keywords}
            0.0.0.3.9 {Browser Config}
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



.list-favorites: function [/section >section][

    if not value? '.read-readable [
        do https://readable.red/read-readable
    ]
    block: .read-readable config-browser-file
    ; obj: context block
    ; sections: words-of obj

    sections: .read-readable/list-sections config-browser-file

    either section [
        if number? >section [
            print >section: sections/:>section
        ]
        print >section
        section-content: select block to-word form >section
        print mold section-content        
    ][
        forall sections [
            i: index? sections
            print [i "." sections/1]
        ]
    ]

]

list-favorites: :.list-favorites


.save-config-browser: function [][

    if not value? '.redlang [
        do https://redlang.red
    ]
    .redlang [get-system-folder git-commit]

    system-folder: .get-system-folder
    memo-dir: what-dir
    .cd (system-folder)
    .git-commit
    cd (memo-dir)
    
]

alias .save-config-browser [
    save-config-browser
    save-browser-config
    .save-browser-config
]
