Red [
    Title: ""
    Needs: 'View
]

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



