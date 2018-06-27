Red [
    Title: "live-share"
]

Memento: [
    
    Title: {VSCode live-share}

    Source: [
        .title: {ReAdABLE Source [(What is the ReAdABLE Human Format?)](http://readablehumanformat.com)}
        .text: {[http://quickrun.red/editors/vscode/live-share.red](https://github.com/lepinekong/mymementos/blob/master/editors/vscode/live-share.red)
        }
        .Published-Url: http://quickrun.red/editors/vscode/live-share
    ]      

    Step-0: [
        .title: {Pre-Requisites}
        .text: {You must have a browser installed (Chrome, Firefox, Internet Explorer,...)}
    ]     

    Install: [
        .title: {Install VSCode extension}
        .text: {Goto:}
        .links: [
            https://marketplace.visualstudio.com/items?itemName=MS-vsliveshare.vsliveshare
        ]
        .image: https://i.imgur.com/5NYH1mw.png
        .text: {Click on:}
        .quote: {install}
        .text: {After a few moment, click on:}
        .quote: {reload}
        .image: https://i.imgur.com/BpGLkFA.png
    ]

    Sign-in: [
        .title: {Sign-in}
        .text: {At the bottom of VSCode, click on:}
        .quote: {Sign-in}
        .text: {Select Github:}
        .image: https://i.imgur.com/aXT6ZfJ.png
        .text: {Click on:}
        .quote: {Green Button "Authorize"}
        .image: https://i.imgur.com/e91s2XS.png
        .text: {If success, you should see:}
        .quote: {Ready to collaborate!}
        .image: https://i.imgur.com/CGY977A.png
    ]

    Share: [
        .title: {Share}
        .text: {At the bottom of VSCode, click on:}
        .quote: {Share}
        .text: {Authorize the firewall:}
        .image: https://i.imgur.com/P7At55d.png
        .text: {On the bottom right, click on button:}
        .quote: {Copy}
        .image: https://i.imgur.com/YzIoRfj.png
        .text: {Remark the icon changed with your name, in the example:}
        .quote: {Lépine}
        .text: {You can consult security info at:}
        .links: [
            https://docs.microsoft.com/en-us/visualstudio/liveshare/reference/security
        ]
    ]

    Join: [
        .title: {Join Collaboration Session}
        .text: {Open a new VSCode Workspace, Activate command and type/choose:}
        .quote: {Live Share: Join Collaboration Session}
        .image: https://i.imgur.com/TCW6e7P.png
        .text: {the link should be pasted automatically, so just validate:}
        .image: https://i.imgur.com/6Bl4HVz.png
        .text: {After a few seconds, you should see a live screen, for example:}
        .image: https://i.imgur.com/ImFpWwW.png
        .text: {On the previous vscode screen, a popup notifies you of the person who joins:}
        .image: https://i.imgur.com/4cOcmUA.png

    ]

    Caveats: [
        .title: {Caveats}
        .text: {Terminal Window seems not be sharable:}
        .image: https://i.imgur.com/tI5JW1h.png
        .text: {as it doesn't appear on the peer screen:}
        .image: https://i.imgur.com/CZu0luy.png
        .text: {If master vscode reopens a workbench, session will be closed:}
        .image: https://i.imgur.com/anonIIy.png
    ]

    References: [
        .title: {References:}
        .links: [
            https://docs.microsoft.com/en-us/visualstudio/liveshare/reference/manual-join
        ]
    ]
]


do read http://readablehumanformat.com/lib.red
markdown-gen