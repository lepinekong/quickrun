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
		"powershell-profile" [
			load-powershell-profile ; will load powershell-profile function if not already loaded
			powershell-profile ; will call powershell function
		]	
	]
]
.alias .lazy-load [lazy-load]

load-powershell: function [][
	unless value? 'powershell [
		do https://quickrun.red/tests/powershell.red
		return true
	]
	return false
]

load-powershell-profile: function [][
	unless value? 'powershell-profile [
		do https://redlang.red/powershell/powershell-profile.red
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
                ["powershell-profile^/" | "powershell-profile" end] (new: "lazy-load powershell-profile")
				| ["powershell profile^/" | "powershell profile" end] (new: "lazy-load powershell-profile")
            ] e: (s: change/part s new e) :s
            | skip
        ]
    ]
]

