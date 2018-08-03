Red [
    Title: "jsdoc.red"
]

out: copy "jsdoc.red"
call/wait/output {powershell -Command "npm install -g jsdoc"} out
print out