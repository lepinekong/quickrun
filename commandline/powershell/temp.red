Red [
    Title: "powershell.red"
]

if not value? '.redlang [
    do https://redlang.red
]
.redlang [alias]

.powershell: function [/startup-dir >startup-directory /startup-command >startup-command][

	unless startup-dir [
		>startup-directory: to-local-file what-dir
	]


	command: rejoin [{start powershell -NoExit -Command "Set-Location '} replace/all >startup-directory "\" "\\"]
	either startup-command [
		startup-command: form >startup-command
		replace/all startup-command "\" "\\" 
		command: rejoin [command ";" >startup-command {'}]
	][
		command: rejoin [command {'}]
	]
	print command
	call command	
]

powershell: :.powershell
