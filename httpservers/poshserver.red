Red [
    Title: "poshserver"
]

Memento: [
    
    Title: {PoshServer: light-weight opensource http server in Powershell}

    Source: [
        .title: {ReAdABLE Source [(What is the ReAdABLE Human Format?)](http://readablehumanformat.com)}
        .text: {[http://quickrun.red/httpservers/poshserver.red](https://github.com/lepinekong/mymementos/blob/master/httpservers/poshserver.red)
        }
        .Published-Url: http://quickrun.red/httpservers/poshserver
    ]      

    Step-0: [
        .title: {Pre-Requisites}
        .text: {For PHP test, you should have PHP server installed.}
    ]     

    Download: [
        .text: {Goto:}
        .links: [
            http://www.poshserver.net/
        ]
        .image: https://i.imgur.com/ViFrpIV.png
        .text: {Download:}
        .quote: {PoSH Server Standalone}
        .links: [
            http://www.poshserver.net/files/PoSHServer-Standalone.v3.7.zip
        ]
    ]

    Install: [
        .title: {Install}
        .text: {Unzip the download}
        .image: https://i.imgur.com/0FGYGTI.png
        .text: {Run with Admin Right:}
        .quote: {PoSHServer-Standalone.exe}
        .image: https://i.imgur.com/2OwcCOi.png
        .text: {Browse to:}
        .links: [
            http://localhost:8080/
        ]
        .text: {Your server should be ready:}
        .image: https://i.imgur.com/ACj4LPw.png
    ]

    PHP: [
        .title: {Test PHP CGI Server}
        .text: {Create info.php in sub-folder:}
        .quote: {http}
        .text: {with this code snippet:}
        .code/php: {
<?PHP
    phpinfo();
?>
        }
        .image: https://i.imgur.com/jRfHwvh.png
        .text: {browse to:}
        .links: [
            http://localhost:8080/info.php
        ]
        .text: {You should see this php info page:}
        .image: https://i.imgur.com/q4YoKny.png
        .text: {Warning: currently only get requests are supported in this early version, post requests are not yet.}
    ]

    Config: [
        .title: {Configuration}
        .text: {Configuration file is available in:}
        .quote: {config.ps1}
        .image: https://i.imgur.com/dGjz9WX.png
    ]
    
]


do read http://readablehumanformat.com/lib.red
markdown-gen