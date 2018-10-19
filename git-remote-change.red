Red [
    File: "get-remote-change"
    Title: "get-remote-change"
    Html-Proxy: 
    Description: {
cd existing_repo
git remote rename origin old-origin
git remote add origin https://gitlab.com/quickrun/release.git
git push -u origin --all
git push -u origin --tags        
    }
    Features: [
        
    ]
    Builds:[
        [0.0.0.1.01.1 {  }]
    ]
    TODO: [
        1 {allow todo: 1.}
        2 {...}
    ]
    Links: [
        https://git-scm.com/docs/git-remote
        https://gitlab.com
        https://help.github.com/articles/changing-a-remote-s-url/
    ]
]

unless value? '.redlang [
    do https://redlang.red
]
.redlang [call-powershell string-expand confirm alias]

.git-remote-change: function [
    param>new-url [string! file! url! path! paren!] 
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

    switch/default type?/word get/any 'param>new-url [

        url! [
            .call-powershell/out {git remote rename origin old-origin}     
            .call-powershell/out rejoin [{git remote add origin } (:param>new-url)] 
            .call-powershell/out {git push -u origin --all}
            .call-powershell/out {git push -u origin --tags}
            return true
        ]
    ] [
        throw error 'script 'expect-arg param>new-url
    ]
]

git-remote-change: function [
    'param>new-url [string! file! url! path! paren! unset!] 
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

    switch/default type?/word get/any 'param>new-url [
        unset! [
            param>new-url: ask "new remote url: "
            if not confirm (param>new-url) [
                print "abort git-remote-change"
                return false
            ]
        ]
        string! file! url! path! paren! [
            .git-remote-change (:param>new-url)
            return true
        ]
    ] [
        throw error 'script 'expect-arg param>new-url
    ]
]

