Red [
    Title: "init.red"
]

unless exists? %config/quickrun.config.red [
    
]

; if error? try [
;     ;.do %config/.system.apps.installers.config.red
; ][
    ; print "executing remote lib..."
    ; do read http://redlang.red/lib-debug.red
    ; do read http://redlang.red/lib.red
    ; do read http://redlang.red/lib-ext.red
    ; do read http://redlang.red/lib-files.red
    ; do read http://redlang.red/lib-powershell.red
    ; do read http://redlang.red/lib-string.red
    ; print "end executing remote lib."
                
    ;.do %config/.system.apps.installers.config.red
; ]


.download: function[.url [url!] /download-directory .download-directory][

    ; example
    ; .download https://binaries.mpc-hc.org/MPC%20HomeCinema%20-%20x64/MPC-HC_v1.7.13_x64/MPC-HC.1.7.13.x64.exe    

    ; external inputs
    <=url: .url

    either download-directory [
        <=system.download.directory: .download-directory
    ][
        ; do-trace 29 [
        ;     ;print "line 29"
        ;     ?? system/options/path
        ;     ?? system/script/path
        ; ] %.system.apps.downloader.red

        <=system.download.directory: .system.download-directory
    ]

    ; internal variables
    download-directory: <=system.download.directory
    url: <=url

    short-filename: get-short-filename url
    target: .to-file rejoin [download-directory short-filename]
    local-target: to-local-file target

    ext: suffix? url
    switch/default ext [
        %.exe %.msi %.jar %.zip %.red [
            ;.curl.download url download-directory short-filename

            powershell.command: {[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12;$exeurl='';$target='';$Webcli=New-Object System.Net.WebClient;$Webcli.DownloadFile($exeurl,$target)}
            parse powershell.command [
                thru {$exeurl='} start: (insert start url)
                thru {$target='} start: (insert start local-target)
                to end
            ]
            write-clipboard powershell.command  
            out: .call-powershell/out powershell.command 
            print out         
        ]
    ][
        print "TODO: parse the page"
    ]
]