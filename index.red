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
		"git" [
			load-git ; will load powershell-profile function if not already loaded
			git ; will call powershell function
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

load-git: function [][
	unless value? 'npm [
		do https://quickrun.red/tools/git/index.red
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
				["git^/" | "git" end] (new: "lazy-load git")
            ] e: (s: change/part s new e) :s
            | skip
        ]
    ]
]


