Red [
    Title: "browser"
    Description: {}
    Builds: [
        0.0.0.4.5 {Bookmarking: todo, to-learn, bookmark,... keywords}
    ]
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

    ; config-browser-filename: .browser.context/config-filename
    ; config-browser-directory: .browser.context/config-directory

    set in system/words 'config-browser-file rejoin [config-directory config-filename]

    unless exists? system/words/config-browser-file [

        if not value? in system/words 'favorites [
                    
            set in system/words 'Favorites  .readable-to-favorites >default-favorites
         
        ]
    ]    

]


.restore-favorites: function [][
    if not value? '.confirm [
        do https://redlang.red/confirm
    ]
    either confirm {restore favorites from backup? } [
        do https://redlang.red/get-system-folder
        system-folder: .get-system-folder
        set in system/words 'Favorites read rejoin [system-folder %quickrun.browser.config.backup.red]
        if error? try [
            write (config-browser-file) (Favorites)
        ][
            print {test mode}
            write %../temp.red (Favorites)
        ]
        return true
    ][
        return false
    ]
    
]

restore-favorites: :.restore-favorites
restore-fav: :.restore-favorites
rf: :.restore-favorites


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


if error? try [
    .load-config-browser
][
    print {error loading favorites}
    if .restore-favorites [
        .load-config-browser
    ]

]


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



if not value? '.add-readable [
    do https://readable.red/add-readable
]

if not value? '.save-readable [
    do https://readable.red/save-readable
]


.to-post: function [>url][
    either block? >url [
        .add-readable favorites 'to-post reduce [>url] 
    ][
        .add-readable favorites 'to-post (>url)  
    ]
    .save-readable (config-browser-file) (favorites)
]

to-post: :.to-post



.bookmarks: function [>url][

    reload-favorites
    
    ..add-bookmark: does [
        .add-readable favorites 'bookmarks reduce [>url]
    ]

    either block? >url [

        category: >url/1
        either set-word? category [

            favorite-bookmarks: favorites/bookmarks
            existing-category: select (favorite-bookmarks) (category)
            either existing-category [
                print [category "already exists: adding its content:"] 
                content: select >url (category)

                sub-category: content/1
                either set-word? sub-category [
                    
                    ;existing-sub-category: select (favorite-bookmarks) (sub-category) ; bug: favorites-bookmarks instead of favorite-bookmarks
                    existing-sub-category: select (existing-category) (sub-category) ; 0.0.0.5.02.5
                  
                    
                    either existing-sub-category [

                        print [sub-category "already exists, adding its content:"] 
                        print mold existing-sub-category
                        key-string: rejoin ["favorites/bookmarks" "/" category "/" sub-category]
                        ;.add-readable favorites key-string (existing-sub-category)
                        sub-category-content: select content (sub-category)
                        ?? sub-category-content
                        ask "360"
                        .add-readable favorites key-string (sub-category-content) ;0.0.0.5.01.7 
 
                    ][
 
                        print [sub-category "doesn't exist"] 
                        sub-category-content: select content (sub-category)
                        print mold sub-category-content
                        key-string: rejoin ["favorites/bookmarks" "/" category "/" sub-category]

                        .add-readable (favorite-bookmarks) (to-word category) reduce [content] ; 0.0.0.4.08.9: OK
 
                    ]
                ][
                    print mold content
                    .add-readable (favorite-bookmarks) (to-word category) reduce [content]
                ]

            ][
                ..add-bookmark
            ]
            
        ][
            .add-readable favorites 'bookmarks reduce [>url] 
        ]
    ][
        .add-readable favorites 'bookmarks (>url)  
    ] 
    .save-readable (config-browser-file) (favorites)
]

bookmarks: :.bookmarks
bookmark: :.bookmarks


.to-learn: function [>url][
    section: 'to-learn
    either block? >url [
        .add-readable favorites (section) reduce [>url] 
    ][
        .add-readable favorites (section) (>url)  
    ] 
    .save-readable (config-browser-file) (favorites)
]

to-learn: :.to-learn


.documentaires: function [>url][
    section: 'documentaires
    either block? >url [
        .add-readable favorites (section) reduce [>url] 
    ][
        .add-readable favorites (section) (>url)  
    ]  
    .save-readable (config-browser-file) (favorites)
]

documentaires: :.documentaires


.jobs: function [>url][
    either block? >url [
        .add-readable favorites 'jobs reduce [>url] 
    ][
        .add-readable favorites 'jobs (>url)  
    ]
    .save-readable (config-browser-file) (favorites)
]

jobs: :.jobs



.to-do: function [>url][
    section: 'todo
    either block? >url [
        .add-readable favorites (section) reduce [>url] 
    ][
        .add-readable favorites (section) (>url)  
    ] 
    .save-readable (config-browser-file) (favorites)
]

to-do: :.to-do
todo: :.to-do
.todo: :.to-do



