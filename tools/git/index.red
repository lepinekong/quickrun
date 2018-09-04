Red [
    Title: ""
    Needs: 'View
]

system/lexer/pre-load: func [src part][
]

do https://quickrun.red/git-commit

git: function [][
    print {
        git commands examples:

        - commit <msg>

    }
]

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



