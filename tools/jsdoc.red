Red [
    Title: "jsdoc.red"
    .links: [
        https://stackoverflow.com/questions/35513712/is-npm-install-the-same-as-npm-install-save
    ]
]

do https://quickrun.red/npm
ans: npm "install -g jsdoc"

; out: copy ""

; npm-command: {npm install -g jsdoc}
; ans: ask rejoin [{Confirm: } npm-command { (Y="Yes" O="Options" else = Cancel): }]
; powershell-command: rejoin [{powershell -Command } {"} npm-command {"}]

; if ans = "Y" [
;     call/wait/output powershell-command out
;     print out
; ]

if ans = "O" [
    print {
        1. "npm install -g jsdoc" will install the package globally
        2. "npm install jsdoc --save" will install the package and add it to your package.json
    }
    ans: ask "Select Option number or else to Cancel: "
    if ans = "1" [
        npm "install -g jsdoc"
        ; call/wait/output powershell-command out
        ; print out        
    ]
    if ans = "2" [
        ; npm-command: {npm install jsdoc --save}
        ; powershell-command: rejoin [{powershell -Command } {"} npm-command {"}]
        ; call/wait/output powershell-command out
        npm {npm install jsdoc --save}
    ]
]
