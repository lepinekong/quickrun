Red [
    Title: "quickrun"
]

do https://redlang.red
.redlang [cd]

index: function [
	/build
][
	if build [
		>build: 0.0.0.1.15
		print >build
		return >build
	]
]

..lazy-load: function ['>function][

	.function: form >function

	switch .function [	
		"powershell" [
			..load-powershell ; will load powershell function if not already loaded
			powershell ; will call powershell function
		]			
		"git" [
			..load-git ; will load git function if not already loaded
			git ; will call git function
		]	
	]
]

..load-powershell: function [][
	unless value? 'powershell [
		do https://quickrun.red/powershell
		return true
	]
	return false
]

..load-git: function [][
	unless value? 'git [
		do https://quickrun.red/git
		return true
	]
	return false
]


system/lexer/pre-load: func [src part][
    parse src [
        any [
            s: [
				["powershell^/" | "powershell" end] (new: "..lazy-load powershell")
				|
				["git^/" | "git" end] (new: "..lazy-load git")
            ] e: (s: change/part s new e) :s
            | skip
        ]
    ]
]


