Red [
    Title: ""
]

if not value? '.redlang [
    do https://redlang.red
]
.redlang [cd alias]
;.quickrun [vscode npm git powershell]

lazy-load: function ['>function][

	.function: form >function

	switch .function [		
		"powershell" [
			load-powershell ; will load powershell-profile function if not already loaded
			powershell ; will call powershell function
		]	
	]
]

load-powershell: function [][
	unless value? 'powershell [
		do https://quickrun.red/commandline/powershell/temp.red
		print {loading powershell: TODO}
		return true
	]
	return false
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

