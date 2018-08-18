Red [
    Title: "git-clone.red"
    .links: [
        https://haacked.com/archive/2014/07/28/github-flow-aliases/
    ]
]


unless value? '.call-powershell [
    do https://redlang.red/call-powershell.red
]

unless value? '.string-expand [
    do https://redlang.red/string-expand
]

; .git-checkout: function ['>branch][

;     branch: form >branch
;     command-template: {git checkout <%branch%>}
;     command: .expand command-template [
;         branch: (branch)
;     ]

;     print "starting..."
;     unless error? try [
;         .call-powershell/out command
;     ] [
;         print ["done"]
;         return true
;     ]
;     return false
; ]

; git-checkout: :.git-checkout
; checkout: :.git-checkout
; co: :.git-checkout

