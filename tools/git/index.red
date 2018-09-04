Red [
    Title: ""
    Needs: 'View
]

deactivate-lexer: does [
    system/lexer/pre-load: func [src part][]
]

deactivate-lexer
do https://quickrun.red/git-commit
activate-lexer

git: function [][
    deactivate-lexer
    print {
        git commands examples:

        - commit <msg>

    }
    activate-lexer
]

activate-lexer: does [
    system/lexer/pre-load: func [src part][
        parse src [
            any [
                s: [
                    ["powershell^/" | "powershell" end] (new: "lazy-load powershell")
                ] e: (s: change/part s new e) :s
                | skip
            ]
        ]
    ]
]




