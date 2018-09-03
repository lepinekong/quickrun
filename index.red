Red [
    Title: "powershell.red"
]

if not value? '.redlang [
	do https://redlang.red
]
.redlang [alias]

.lazy-load: function ['>function][

	.function: form >function

	switch .function [	
		"powershell" [
			load-powershell ; will load powershell-profile function if not already loaded
			powershell ; will call powershell function
		]			
		"npm" [
			load-npm ; will load powershell-profile function if not already loaded
			npm ; will call powershell function
		]	
	]
]
.alias .lazy-load [lazy-load]

load-powershell: function [][
	unless value? 'powershell [
		do https://quickrun.red/commandline/powershell/index.red
		return true
	]
	return false
]

load-npm: function [][
	unless value? 'npm [
		do https://quickrun.red/commandline/npm.red
		return true
	]
	return false
]


system/lexer/pre-load: func [src part][
    parse src [
        any [
            s: [
				["powershell^/" | "powershell" end] (new: "lazy-load powershell")
				|
				["npm^/" | "npm" end] (new: "lazy-load npm")
            ] e: (s: change/part s new e) :s
            | skip
        ]
    ]
]


