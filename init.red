Red [
    Title: "init.red"
]

unless exists? config-file: %config/quickrun.config.red [
    make-dir %config
    write %config/quickrun.config.red read https://quickrun.red/config/quickrun.config.red
]

do read config-file
>curl-folder: curl-folder
>download-folder: download-folder

curl-folder: to-red-file >curl-folder
curl-local-folder: to-local-file curl-folder
download-folder: to-red-file >download-folder
download-local-folder: to-local-file download-folder

curl-exe: to-red-file rejoin [curl-folder %curl.exe]
curl-zip: to-red-file rejoin [curl-folder %curl.zip]

unless exists? curl-folder [
    make-dir/deep curl-folder
    print [curl-folder "created"]
]

unless exists? %curl.exe [
    ; download curl
    print "downloading curl..."
    write/binary curl-zip read/binary https://curl.haxx.se/download/curl-7.60.0.zip
    print ["finished downloading" curl-zip]

    ;unzip https://stackoverflow.com/questions/27768303/how-to-unzip-a-file-in-powershell
    ; [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
    powershell-command: {[System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)}
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