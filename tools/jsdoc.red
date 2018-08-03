Red [
    Title: ""
]

out: copy "jsdoc.red"
call/wait/output {powershell -Command "npm install -g jsdoc"} out
print out