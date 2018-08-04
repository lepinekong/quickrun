Red [
    Title: "npm.red"
]

npm: function [short-command /no-confirmation][
    npm-command: rejoin [{npm } short-command] 
    powershell-command: rejoin [{powershell -Command } {"} npm-command {"}]
    unless no-confirmation [
        ans: ask rejoin [{Confirm: } npm-command { (Y="Yes" O="Options" else = Cancel)}] 
        either ans <> "Y" [
            return ans
        ][
            call/wait/output powershell-command out 
        ]
    ]
]