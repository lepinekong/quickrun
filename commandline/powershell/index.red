Red [
    Title: "powershell.red"
]

; if not value? '.redlang [
;     do https://redlang.red
; ]
;.redlang [alias]

.powershell: function [
	/startup-dir >startup-directory 
	/startup-command >startup-command
	/as-admin ; https://serverfault.com/questions/464018/run-elevated-powershell-prompt-from-command-line 
	; powershell -Command "Start-Process PowerShell -Verb RunAs"
][


	unless startup-dir [
		>startup-directory: to-local-file what-dir
	]

	either as-admin [
		command: rejoin [{start powershell -NoProfile -Command "Start-Process PowerShell -Verb RunAs"}]
	][
		command: rejoin [{start powershell -NoExit -Command "Set-Location '} replace/all >startup-directory "\" "\\"]
		
		either startup-command [
			startup-command: form >startup-command
			replace/all startup-command "\" "\\" 
			command: rejoin [command ";" >startup-command {'}]
		][
			command: rejoin [command {'}]
		]
	]

	print command
	call command	
]

;.alias .powershell [powershell]

lazy-load-powershell: function ['>function][

	.function: form >function

	switch .function [		
		"profile" [
			load-powershell-profile ; will load powershell-profile function if not already loaded
			powershell-profile ; will call powershell function
		]	
	]
]

load-powershell-profile: function [][
	unless value? 'powershell-profile [
		do https://quickrun.red/commandline/powershell/profile.red
		return true
	]
	return false
]

system/lexer/pre-load: func [src part][
    parse src [
        any [
            s: [
                ["powershell-profile^/" | "powershell-profile" end] (new: "lazy-load-powershell profile")
				| ["powershell profile^/" | "powershell profile" end] (new: "lazy-load-powershell profile")
				| ["npm^/" | "npm" end] (new: "lazy-load npm")
            ] e: (s: change/part s new e) :s
            | skip
        ]
    ]
]

powershell: :.powershell