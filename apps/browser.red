Red [
    Title: "chrome"
]

__BROWSER_CONFIG_FILE_NAME__: %quickrun.browser.config.red 
__CONFIG_EDITOR__: %notepad.exe ; in 06.edit-config-browser.red
if not value? '.redlang [
    do https://redlang.red
]
.redlang [files get-folder ]
do https://quickrun.red/libs/readable-to-favorites
do https://quickrun.red/res/default-favorites


create-keyword: function [
    keyword /url >url
    /force 
][
    keyword: to-word keyword

    not-value-keyword: not value? keyword

    either not-value-keyword or force [ ; 0.0.0.1.5
        if not  url [
            >url: keyword ; 0.0.0.16
        ]

        func-body: compose/deep/only [ ; 0.0.0.1.4
                go (>url) ; 0.0.0.16 
        ]
        set keyword does func-body
    ][
        ; keyword already
    ]
    return keyword
]

.browser.context: context [
    config-directory: get-folder (system/options/boot)
    config-filename: __BROWSER_CONFIG_FILE_NAME__ 

    get-config-file: function [][
        return rejoin [config-directory config-filename]
    ]

    ; config-browser-filename: .browser.context/config-filename
    ; config-browser-directory: .browser.context/config-directory

    set in system/words 'config-browser-file rejoin [config-directory config-filename]

    unless exists? system/words/config-browser-file [

        if not value? in system/words 'favorites [
            
            ;set in system/words 'Favorites .readable-to-favorites >default-favorites

            ; set in system/words 'Favorites context [

            ;     .favorites: .readable-to-favorites >default-favorites
                
            ;     return .favorites
            ; ]          
            set in system/words 'Favorites  .readable-to-favorites >default-favorites
         
        ]
    ]    

]

; config-browser-filename: .browser.context/config-filename
; config-browser-directory: .browser.context/config-directory

; config-browser-file: rejoin [config-browser-directory config-browser-filename]

; unless exists? config-browser-file [

;     if not value? 'Favorites [
;         Favorites: readable-to-favorites >default-favorites
;     ]
; ]
.load-config-browser: does [

    if not exists? config-browser-file [
        write/lines/append config-browser-file rejoin [
            {Favorites: } mold >default-favorites
        ]        
    ]
    Favorites: load config-browser-file ; 0.0.0.3.01: changed data format
    Favorites: readable-to-favorites Favorites ; 0.0.0.2.04: bug todo: none
    foreach [keyword url] favorites/main [
        create-keyword/url/force keyword url
    ]     
]

alias .load-config-browser [.reload-config-browser reload-config-browser load-config-browser 
.refresh-config-browser resfresh-config-browser 
.reload-favorites reload-favorites
]

.load-config-browser

.edit-config-browser: function [
    /section '>section
][
    either section [
        
    ][
        command: rejoin [__CONFIG_EDITOR__ { } {"} to-local-file config-browser-file {"}]
        call/show command
    ]

]

alias .edit-config-browser [
    edit-config-browser 
    .edit-browser-config 
    edit-browser-config
    .edit-favorites
    edit-favorites
    edit-bookmarks
    .edit-bookmarks
]


.save-config-browser: function [][

    if not value? '.redlang [
        do https://redlang.red
    ]
    .redlang [get-system-folder git-commit]

    system-folder: .get-system-folder
    memo-dir: what-dir
    .cd (system-folder)
    .git-commit
    cd (memo-dir)
    
]

alias .save-config-browser [
    save-config-browser
    save-browser-config
    .save-browser-config
]
.list-favorites: function [/section >section][

    if not value? '.read-readable [
        do https://readable.red/read-readable
    ]
    block: .read-readable config-browser-file
    ; obj: context block
    ; sections: words-of obj

    sections: .read-readable/list-sections config-browser-file

    either section [
        if number? >section [
            print >section: sections/:>section
        ]
        print >section
        section-content: select block to-word form >section
        print mold section-content        
    ][
        forall sections [
            i: index? sections
            print [i "." sections/1]
        ]
    ]

]

list-favorites: :.list-favorites

.delete-config-browser: function [][
    redlang [confirm]
    if confirm rejoin ["delete " config-browser-file][
        delete config-browser-file
    ]
]

alias .delete-config-browser [.delete-browser-config delete-config-browser delete-browser-config ]

.chrome: func [
    '.urls [string! word! url! unset! block! path!]
    /_build
    /silent
][   

    if _build [
        >builds: [
            0.0.0.4.6 {Default-Favorites online}
            0.0.0.4.4 {Readable Human Format}
            0.0.0.3.10 {Refresh favorites for keywords}
            0.0.0.3.9 {Browser Config}
            0.0.0.3.3 {Create keywords from favorite/main}
            0.0.0.2.13
        ]
        unless silent [
            ?? >builds
        ]
        return _build
    ]

    switch/default type?/word get/any '.urls [
        unset! [
            print {
                Examples:
                Go https://github.com
                Go github.com
                Go github
                Go https://github.com/lepinekong?tab=repositories
                Go favorites/Daily
            }
        ]
        word! string! url![

            url: form .urls

                to-keyword: function [url][

                    rule: [
                        "https://" copy keyword to "."
                        |
                        "http://" copy keyword to "."
                        |
                        copy keyword to "."
                        |
                        copy keyword to end  
                    ]
                    parse url rule
                    return keyword
                ]

            either suffix? url [ ; github.com

                unless (copy/part url 4) = "http" [
                    url: rejoin ["https://" url] ; https://github.com
                ]
                keyword: (to-keyword url)
                keyword: create-keyword keyword ; create-keyword 'github

            ][

                if error? try [
                    keyword: create-keyword to-word url ; 0.0.0.1.16 fix bug no keyword
                    url: rejoin ["https://" url ".com"]
                ][
                    keyword: create-keyword/url (to-keyword url) (url) ; 0.0.0.1.10
                ]
            ]
            call rejoin [{start chrome} { } url]
        ]
        path! [
            .urls: (.urls)
            block: reduce (.urls)
            go (block)
        ]
        block! [
            
            block: :.urls

            forall block [
                if url? block/1 [
                    go (block/1)
                ]
                
            ]
            
        ]    
    ][
        throw-error 'script 'expect-arg .urls
    ]
]

chrome: :.chrome
goto: :.chrome
go: :.chrome
browse: :.chrome



if not value? '.add-readable [
    do https://readable.red/add-readable
]

if not value? '.save-readable [
    do https://readable.red/save-readable
]


.to-post: function [>url][
    .add-readable favorites 'to-post reduce [>url]   
    .save-readable (config-browser-file) (favorites)
]

to-post: :.to-post



.bookmarks: function [>url][
    .add-readable favorites 'bookmarks reduce [>url]   
    .save-readable (config-browser-file) (favorites)
]

bookmark: :.bookmarks


.to-learn: function [>url][
    .add-readable favorites 'to-learn reduce [>url]   
    .save-readable (config-browser-file) (favorites)
]

to-learn: :.to-learn


.documentaires: function [>url][
    .add-readable favorites 'documentaires reduce [>url]   
    .save-readable (config-browser-file) (favorites)
]

documentaires: :.documentaires


.jobs: function [>url][
    .add-readable favorites 'jobs reduce [>url]   
    .save-readable (config-browser-file) (favorites)
]

jobs: :.jobs



.to-do: function [>url][
    .add-readable favorites 'todo reduce [>url]   
    .save-readable (config-browser-file) (favorites)
]

to-do: :.to-do
todo: :.to-do
.todo: :.to-do




.restore-favorites: function [][
    if not value? '.confirm [
        do https://redlang.red/confirm
    ]
    if confirm {restore favorites from backup? } [
        do https://redlang.red/get-system-folder
        system-folder: .get-system-folder
        set in system/words 'Favorites read rejoin [system-folder %quickrun.browser.config.backup.red]
        if error? try [
            write (config-browser-file) (Favorites)
        ][
            print {test mode}
            write %temp.red (Favorites)
        ]
        
    ]
]

restore-favorites: :.restore-favorites
restore-fav: :.restore-favorites
rf: :.restore-favorites


    Main: [
        .title: "Main"
        .links: [
			github github
			webflow https://webflow.com/dashboard
			mygitlab https://gitlab.com/dashboard/groups
            mygithub https://github.com/lepinekong?tab=repositories 
            mygist https://gist.github.com/lepinekong
	    mycodesnippets mycodesnippets.space
	    mymementos mymementos.space
            forsysops https://4sysops.com/archives/
            gitter https://gitter.im/red/help
            ;--- social networks
            twitter twitter
            twittersearch https://twitter.com/search-advanced?lang=en&lang=en
            mytwitter https://twitter.com/lepinekong
            agile https://twitter.com/search?q=agile&src=typd 
            nodejs https://twitter.com/search?q=nodejs&src=typd
            js https://twitter.com/search?q=javascript&src=typd
            freecodecampforum forum.freecodecamp.org    
            ;---
            Medium medium 
            freeudemy https://medium.com/100-free-udemy-coupons
            ourcodeworld ourcodeworld
            kees https://keestalkstech.com/
            edjin https://blogs.endjin.com/
            stack stackoverflow 
            freecodecamp https://learn.freecodecamp.org/
            smashingmagazine smashingmagazine
            jug http://www.jugsummercamp.org/edition/9
            informatiquenews https://www.informatiquenews.fr/
            joecolantonio https://www.joecolantonio.com/tribute-gerald-weinberg/
            creativebloq creativebloq
            
            redbyexample http://www.red-by-example.org/
            helpin helpin.red
            mycode4fun http://www.mycode4fun.co.uk/red-beginners-reference-guide
            redgithub https://github.com/red/red            
            ;--- tools
            codesandbox https://codesandbox.io/s/cli
		word-to-markdown https://word-to-markdown.herokuapp.com/
            virustotal https://www.virustotal.com/#/home/upload       
            ;--- email
            email https://mail.yahoo.com/?.intl=fr&.lang=fr-FR&.partner=none&.src=fp
            namecheap namecheap
            namesilo namesilo
            myo2switch lepkon.odns.fr:2082
            o2switchaccount https://clients.o2switch.fr/client.php
            youtube youtube
            canva canva
            snappa snappa
            Dzone dzone 
            Devto dev.to
            Codeburst codeburst.io
            fullstackradio fullstackradio

            
            ;---
            codecanyon https://codecanyon.net/search/nodejs
            
            bonsplans [https://www.plusdebonsplans.com/ https://www.mavieencouleurs.fr/bons-de-reduction]
            packt https://www.packtpub.com/packt/offers/free-learning
            vscodeext https://marketplace.visualstudio.com/vscode
            amazon amazon.fr
            pharmacie lasante.net
            nickel https://mon.compte-nickel.fr/identifiez-vous
            myorders https://www.amazon.fr/gp/css/order-history/ref=nav_youraccount_orders 
            ;--- news
            bfm https://bfmbusiness.bfmtv.com
            nikkeiasia https://asia.nikkei.com/
            ;--- free images
            pixabay https://pixabay.com/
            ;--- entreprenariat
            alternance mon-alternance.fr
            ;--- administration
            impots https://cfspart.impots.gouv.fr/LoginMDP
        ]
    ]
    
    Todo: [
		Sucrédulcor: [
			3.60 [https://www.parapharmacie-et-medicament.com/SUCREDULCOR-Edulcorant-a-la-saccharine-/p/4/698/24479/]
			3.70 [
				https://www.parapharmacie-naocia.com/sucredulcor-edulcorant-table-saccharine,fr,4,acl-7296920.cfm
			]
			3.96 [https://lasante.net/espace-para/bien-etre-et-minceur/minceur/destockage-des-sucres/sucredulcor-edulcorant-de-table-x-260.html]
			6.55 [
				http://www.doctipharma.fr/p/21948-pierre-fabre-sucredulcor-comprimes-effervescent-boite-de-600
			]
				
		]

		Read: [
			https://medium.com/blockchain-education-network/viva-la-generation-blockchain-971b4df7209f
			https://twitter.com/sbmeunier/status/1044532858621243392
		]

		Meetup: [
			https://events-emea1.adobeconnect.com/content/connect/c1/1266246463/en/events/event/shared/default_template_simple/event_registration.html?sco-id=3145518654&_charset_=utf-8
		]

		Marketing: [
			Creer-comptes-twitter: [fragment-learning]
			http://www.gautier-girard.com/site-partenaire/
			https://www.petite-entreprise.net/R-13-H1-0-repertoire-national-des-professionnels-du-conseil.html?sort=geolocation&connecte-tchat=1&typeAff=1
		]
		

		Blogging: [
			FragmentLearning: [
				{CS vs Bootcamp} https://www.whatsthehost.com/coding-bootcamp-vs-cs-degree/
				{Créer un projet pour apprendre} https://nexten.io/fr/
			]
		]

		Co-working: [
			https://www.workuper.com/articles/10-lieux-et-espaces-de-coworking-gratuits-ou-presque-a-paris-pour-chercher-un-job-a-paris
		]
		Creer-entreprise: [

			https://consignations.caissedesdepots.fr/particulier/deposer-votre-capital-social/deposez-votre-capital-social-pour-creer-votre-societe			


			http://www.jurismatic.com/pacte-associes-fondateurs/

			https://www.appvizer.fr/magazine/services/centre-formation/devenir-organisme-de-formation#le-referencement-des-organismes-de-formation-chez-les-financeurs
			http://idf.direccte.gouv.fr/Vous-etes-un-organisme-de-formation-ou-vous-souhaitez-le-devenir-Ces

			http://www.aidentreprise.fr/article-sasu-modele-statuts-gratuits-118768200.html
			https://business.lesechos.fr/outils-et-services/modeles-de-documents/modeles-creation-d-entreprise/357-acte-de-nomination-du-president-sasu-26802.php
			
			https://www.lecoindesentrepreneurs.fr/creer-sa-sas-en-10-etapes/
			https://www.service-public.fr/professionnels-entreprises/recherche?keyword=SASU
			https://www.guichet-entreprises.fr/fr/comment-creer-une-entreprise/
			
			Statuts
			http://www.aidentreprise.fr/article-sasu-modele-statuts-gratuits-118768200.html
			https://www.creerentreprise.fr/plusieurs-activites-dans-une-entreprise/
			https://www.lecoindesentrepreneurs.fr/rediger-les-statuts-de-l-entreprise/
			https://www.service-public.fr/professionnels-entreprises/vosdroits/R39954
			https://www.service-public.fr/professionnels-entreprises/vosdroits/F32886
			https://www.jesuisentrepreneur.fr/statut-juridique/comment-rediger-vos-statuts-d-entreprise.html
			
			Impots
			https://www.creerentreprise.fr/impot-sur-les-societes-definition-calcul/
			
		]


		Docker-vscode: [
			http://blog.ctaggart.com/2016/05/visual-studio-code-served-from-docker.html
		]
		
		Webdesign: [
			Redlang.red [
				https://imgur.com/YwIKz9W
				https://i.imgur.com/YWafKCT.png
				{New-Item -ItemType Directory -Force -Path C:\red;(New-Object System.Net.WebClient).DownloadFile('https://static.red-lang.org/dl/win/red-063.exe','c:\red\red.exe');Start-Process -Filepath 'c:\red\red.exe'}
			]
		]
		
		Trading: [
			https://deangrant.wordpress.com/2015/10/03/generating-log-output-using-windows-powershell/
		]
		
		Buy: [
			https://www.amazon.com/Slack-Bot-Development-Tutorial-PaizaCloud-ebook/dp/B07BFQ93YX
		]

		Assurance-vie: [
			https://monfric.com/comment-savoir-si-je-suis-beneficiaire-dune-assurance-vie/
		]

		To-read: [
			https://www.reikiforum.com/4-articles-sur-le-reiki/63-anciens-articles/560-une-etude-scientifique-des-effets-du-reiki-sur-le-cerveau-humain/
		]
		
    ]
    
	Bookmarks: [

		WebdesignInspirations: [
			http://manhattanjs.com/
		]

		Programmationpourenfant: [
			https://sparse-dense.blogspot.com/2018/06/microbittwo-layer-perceptronxor.html
		]

		business-ideas: [
			https://www.social-hire.com/blog/candidate/hidden-figures-how-far-have-women-come-in-the-tech-industry/
		]

		Alternance: [
			https://www.alternance.emploi.gouv.fr/portail_alternance/
			https://www.alternance.emploi.gouv.fr/portail_alternance/
			https://www.alternance.emploi.gouv.fr/portail_alternance/jcms/recleader_6525/apprentissage-faites-votre-demande-d-aide-tpe-jeunes-apprentis-en-ligne?portal=gc_5228
			https://www.alternance.emploi.gouv.fr/portail_alternance/jcms/recleader_6591/apprentissage-decouvrez-les-primes-et-les-aides-financieres-en-infographie?portal=gc_5228
			https://www.alternance.emploi.gouv.fr/portail_alternance/jcms/gc_5064/vos-aides
			https://les-aides.fr/focus/bpFl/les-aides-pour-une-embauche-en-contrat-d-alternance-du-cap-au-doctorat.html
			https://www.alternance.fr/infos-conseils/l-alternance-a-l-etranger-est-ce-une-bonne-idee-745.php
			https://www.alternance.fr/infos-conseils/remuneration-apprentissage-contrat-professionnalisation-188.php
		]
	
		AI: [
			https://bitnewstoday.com/market/technology/neural-networks-in-trading-goldman-sachs-has-fired-99-of-traders-replacing-them-with-robots/
		]
	
		Learningpaths: [
			https://github.com/web-padawan/awesome-lit-html
		]

		Dotsystem.red: [
			https://bizfluent.com/info-8078360-differences-stream-mapping-process-mapping.html
			https://metaexperts.com/the-art-of-mapping-process-vs-value-stream/
			https://www.cloudbees.com/blog/real-time-visualization-value-streams-cloudbees-devoptics-deliver
			https://www.ibm.com/developerworks/rational/library/10/howandwhytocreatevaluestreammapsforswengineerprojects/index.html
			http://www.kanbanway.com/the-value-of-value-stream-mapping-in-software-engineering
			https://xebia.com/blog/how-to-create-a-value-stream-map/
		]
		
		Dotnet: [
			https://csharp.christiannagel.com/2018/09/19/dependency-injection-code-samples-updated/
		]	
		
		Rasberrypi: [
			https://dev.to/shosta/do-you-care-about-your-privacy-maybe-it-is-time-to-set-up-your-own-dropbox-ncf
		]
		
		Electronjs: [
			https://dev.to/vuevixens/building-a-desktop-app-with-vue-electron-3pl
		]

	    Readable.red: [
			https://korben.info/word2markdown.html
			https://www.makeuseof.com/tag/microsoft-word-can-favorite-markdown-editor/
			https://dzone.com/articles/jenkins-configuration-as-code-documentation
   		]

		Wellexplained: [
			https://hackernoon.com/machine-learning-is-the-emperor-wearing-clothes-59933d12a3cc
		]
		
		Webmarketing: [
			https://www.toprankblog.com/2015/05/influencer-participation-marketing/
		]

		Macron: [
			https://twitter.com/kelpo1002/status/1042029354656641024
			Loi-travail: [
				https://www.youtube.com/watch?v=tp3TduDI0Is
			]
		]

		Banksters: [
			https://www.youtube.com/watch?v=JHFgtzvfH-Y
			http://finance-krach-survivor.com/bankster-vol-au-dessus-tout-soupcon/
			https://www.amazon.fr/Banksters-Voyage-chez-amis-capitalistes-ebook/dp/B00MTUZ3WE/ref=sr_1_1
		]

		Veilleit: [
			https://fintech-mag.com/tendances-fintech-2019-alain-clot-france-fintech/
		]
		
		ReactJs: [
			https://cosmicjs.com/articles/how-to-build-a-simple-blog-using-react-and-graphql-j8ouwjvh?ref=search
		]

		Crisis: [
			{Costs of the Financial Crisis, 10 Years Later} https://hbr.org/2018/09/the-social-and-political-costs-of-the-financial-crisis-10-years-later
		]

		Documentaires: [
			{Inside Lehman Brothers} https://www.youtube.com/watch?v=KbOmomWq9tA
			{L'argent du sucre - Histoire de l'esclavage} https://www.youtube.com/watch?v=sBzDpRW96uQ
			{De Gaulle Notre President} https://www.youtube.com/watch?v=eUbJDaEFtwI
			{De Gaulle et ses gorilles} https://www.youtube.com/watch?v=Ys6Br3wQyJ0
			{Guerres Saintes : des Omeyyades, des Croisades aux Ottomans} https://www.youtube.com/watch?v=d3IuzUTRXQ0
			{Relativité} https://www.youtube.com/watch?v=UFX9yF5lwfA
			{Hitler sur table d'écoute} https://www.france.tv/documentaires/histoire/720801-hitler-sur-table-d-ecoute.html
			{"Hitler sur écoute"} https://www.youtube.com/watch?v=EaP-q2gn1OA
			{Collaborations} https://www.youtube.com/watch?v=DWYAiMmtdHQ
			{La cagoule , enquête sur une conspiration d'extrème droite} https://www.youtube.com/watch?v=A5J__4qtJ5s
			{La grande conspiration de la Cagoule} https://www.youtube.com/watch?v=qqRe-Sb_jjU
			{Corée du Nord, la dictature de la bombe} https://www.youtube.com/watch?v=isQnnIJxDcU
			{Un Jour, Un Destin : Georges Marchais} https://www.youtube.com/watch?v=iGnH2U7bxJA
			{Brigitte Macron, un roman français. Portrait de la Première Dame de France} https://www.youtube.com/watch?v=eAmeOp1IoMw
			{Où va l'argent de l'Elysée ?} https://www.youtube.com/watch?v=nLcIGsUfcMo
			{Walmart : Le géant de la distribution} https://www.youtube.com/watch?v=F2TQmv_fqFQ
			{La guerre des télécoms - Free Bouygues Télécom SFR et Numéricable} https://www.youtube.com/watch?v=aTBYBmXfdXI
		]
	]

    
    mementos: [
    
		security: [
			https://dev.to/dotnetcoreblog/three-steps-for-increasing-the-security-of-your-web-apps-3clg
		]

		vscode: [
			https://github.com/Microsoft/vscode/issues/12006
		]

		pandoc: [
			word-to-markdown https://mrjoe.uk/convert-markdown-to-word-document/
		]

		Curl: [
			https://www.codediesel.com/tools/6-essential-curl-commands/
			https://sites.tufts.edu/liam/2014/01/26/cur/
		]
    
		css: [
			https://www.creativebloq.com/css3/advanced-rwd-layout-techniques-71412175
		]
    
		Agile: [
			https://www.ibm.com/developerworks/rational/library/10/howandwhytocreatevaluestreammapsforswengineerprojects/index.html
		]
    
		Red: [
			https://www.red-lang.org/2013/11/041-introducing-parse.html
		]
		
		Testing: [
			http://fr.viadeo.com/fr/groups/detaildiscussion/?containerId=002tvfm3u237xwq&forumId=0021u707p1pnupgo&action=messageDetail&messageId=0027df8jl5tjvde
			https://www.techopedia.com/definition/21178/operational-testing
			https://wiki.en.it-processmaps.com/index.php/File:Itil-service-validation.jpg
			http://www.itilnews.com/index.php?pagename=Service_Validation_and_Testing
			https://www.slideshare.net/RenaudBrosse/introduction-itil-v3-en-1heure-timspirit-v11
			http://blog.timoxley.com/post/20772365842/node-js-npm-reducing-dependency-overheads
		]
		
		XPath: [
			https://trevorsullivan.net/2011/06/29/microsoft-xml-notepad-2007-xpath/
		]
		
		Hosting: [
			https://blog.patricktriest.com/host-webapps-free/
		]
		Windows: [
			https://www.drivereasy.com/knowledge/how-to-stop-windows-10-update/
			https://www.easeus.com/todo-backup-resource/free-windows-10-backup-system-image.html
			https://www.easeus.com/backup-recovery/factory-reset-windows-10.html
		]
	]
    
    to-learn: [
		title: {to learn}

		SEO: [
			https://backlinko.com/seo-strategy
		]

		Optimisation: [
			https://dev.to/pldg/lazy-load-images-with-webpack-5e80
		]

		Angularjs: [
			https://blog.angularindepth.com/what-is-forwardref-in-angular-and-why-we-need-it-6ecefb417d48
		]

		Python: [
			https://blog.patricktriest.com/analyzing-cryptocurrencies-python/
		]

		Docker: [
			https://blog.patricktriest.com/text-search-docker-elasticsearch/
		]

		Rmarkdown: [
			https://data.hypotheses.org/1144
			http://davidbosman.fr/blog/2011/08/08/markdown-et-word/
		]
		aws: [
			https://egghead.io/courses/develop-a-serverless-backend-using-node-js-on-aws-lambda
			https://github.com/dabit3/gatsby-auth-starter-aws-amplify
		]
		
		
		Nodejs: [
			https://stackoverflow.com/questions/10680601/nodejs-event-loop
		]
		
		Snipcart: [
			https://itnext.io/yes-i-created-an-e-commerce-shop-with-no-backend-serverless-html-css-js-only-d62df47f4d99
		]
		
		Json: [
			https://www.codewall.co.uk/the-complete-json-tutorial-quickly-learn-json/
		]
		
		Glitch: [
			https://blog.bitsrc.io/introduction-to-glitch-for-node-js-apps-in-the-cloud-cd263de5683f
			https://www.youtube.com/watch?v=TlB_eWDSMt4
			https://medium.com/glitch/teaching-coding-with-glitch-bb71b879194f
		]
		
		Frameworks: [
			openfin openfin.co
		]
		
		
		Webflow: [
			https://www.youtube.com/watch?v=fy07HYm-geM&app=desktop
		]
		
		Wordpress-Theme: [
			http://www.designmarketingadvertising.com/freetips/lesson-resources/create-your-very-own-wordpress-theme-with-these-great-tutorials
		]
		
		Gitlab: [
			Gitlab-API: [
				https://docs.gitlab.com/ee/api/
			]
		]
		
		npm: [
			https://medium.freecodecamp.org/javascript-package-managers-101-9afd926add0a
			https://www.toptal.com/javascript/a-guide-to-npm-the-node-package-manager
		]
		
		Electronjs: [
			https://maxogden.com/electron-fundamentals.html
			https://www.smashingmagazine.com/2017/03/beyond-browser-web-desktop-apps/
		]
		
		Typescript: [
			Metaprogramming: [
				http://jonnyreeves.co.uk/2015/basic-typescript-dependency-injection-with-decorators/
			]
		]
		
		Redux: [
			http://jonnyreeves.co.uk/2016/redux-middleware/#redux-middleware
		]
		
		Yarn: [
			https://geeklearning.io/npm-install-drives-you-crazy-yarn-and-chill/
			https://www.youtube.com/watch?v=6qibcuTeaG4
		]
		
		Slack-api: [
			https://www.pdq.com/blog/deploy-packages-using-slack/
		]
		
		Dependency-hell: [
		
			SemVer: [
				https://techinsight.com.vn/language/en/semver-escape-from-dependency-hell-part-1/
				https://nodesource.com/blog/semver-a-primer/
				http://krasimirtsonev.com/blog/article/thoughts-on-semantic-versioning-npm-and-JavaScript-ecosystem
				https://developer.telerik.com/featured/mystical-magical-semver-ranges-used-npm-bower/
			]
			http://krasimirtsonev.com/blog/article/thoughts-on-semantic-versioning-npm-and-JavaScript-ecosystem
			https://rants.broonix.ca/dependency-hell/
			
			https://news.ycombinator.com/item?id=8228537
			https://blog.softwaremill.com/it-depends-the-art-of-dependency-management-in-javascript-f1f9c3cde3f7

			https://snyk.io/blog/bower-is-dead
			https://developers.slashdot.org/story/16/03/23/0652204/how-one-dev-broke-node-and-thousands-of-projects-in-11-lines-of-javascript
			
			Solutions: [
				https://www.youtube.com/watch?v=6qibcuTeaG4
				https://stackoverflow.com/questions/51388190/how-to-resolve-dependency-hell-in-npm-with-peerdependencies
				https://snyk.io/blog/npm-shrinkwrap-reloaded
				https://medium.com/@andrerpena/a-trick-for-avoiding-dependency-hell-on-node-js-f6ff20a09578
				https://ponyfoo.com/articles/immutable-npm-dependencies				
			]
			
			Critics: [
				http://jonnyreeves.co.uk/2016/npm-shrinkwrap-sucks/
			]
			
		]

		
		
		Security: [
			https://snyk.io/blog/ten-git-hub-security-best-practices
		]
		
		Msbuild: [
			https://blogs.endjin.com/2016/10/how-to-package-a-web-project-for-deployment-from-the-command-line/
		]
		
		Swagger: [
			https://blogs.endjin.com/2018/05/openapi-document-converters-for-visual-studio-2017/
		]
		
		CPU: [
			https://blogs.endjin.com/2013/06/learning-to-program-a-beginners-guide-part-four-a-simple-model-of-a-computer/
		]
		
		ITIL: [
			http://www.timspirit.com/itil-v3-it-service-management-2017/
		]
		
		Git-Faq: [
			https://www.git-tower.com/learn/git/faq/difference-between-git-fetch-git-pull
			https://www.devroom.io/2009/10/26/how-to-create-and-apply-a-patch-with-git/
			https://dzone.com/articles/git-showing-file-modified-even
		]
		
		Git: [
			http://happygitwithr.com/big-picture.html
			https://doc.qt.io/qtcreator/creator-vcs-git.html
			https://hbs-rcs.github.io/versioning_data_scripts/02_GitKraken.html
			https://blog.satoripop.com/git-basics-using-cli-gitkraken-and-sourcetree-c44f8572e39d
			https://blog.axosoft.com/learning-git-with-gui/
			https://blog.axosoft.com/gitkraken-tips/
			https://blog.axosoft.com/gitkraken-tips-5/
			http://blog.backand.com/github-webhook-node/
			https://about.gitlab.com/2017/03/14/axosoft-launches-gitkraken-integration-with-gitlab/
		]
		
		AWS: [
			https://player.fm/series/series-1527787/227-migrating-from-the-aws-cli-to-windows-powershell
		]
		
		Amazon-Polly: [
			https://trevorsullivan.net/2016/12/01/amazon-aws-cloud-polly-nodejs/
		]
		Powershell: [
		
			VSCode: [
				https://blogs.technet.microsoft.com/heyscriptingguy/2016/12/07/make-visual-studio-code-more-like-the-integrated-scripting-environment/
			]
		
			Debugging: [
				https://blogs.technet.microsoft.com/heyscriptingguy/2017/02/13/debugging-powershell-script-in-visual-studio-code-part-2/
			]

			Advanced: [
				https://4sysops.com/archives/formatting-object-output-in-powershell-with-format-ps1xml-files/
				https://blogs.technet.microsoft.com/heyscriptingguy/2017/10/03/use-docker-to-automate-testing-of-powershell-core-scripts/
			]
			
			Syntax: [
				https://trevorsullivan.net/2016/07/20/powershell-quoting/
				https://trevorsullivan.net/2010/11/15/powershell-dynamic-parameters-and-parameter-validation/
			]
					
			Dotnet: [
				https://trevorsullivan.net/2014/10/25/implementing-a-net-class-in-powershell-v5/
			]

			
			VSCode: [
				https://trevorsullivan.net/2017/03/11/change-vscode-integrated-terminal-powershell/
				https://www.smashingmagazine.com/2016/08/contributing-open-source/
				https://code.visualstudio.com/docs/extensions/example-language-server
			]
			Linux: [
				Docker: [
					https://trevorsullivan.net/2016/08/18/powershell-core-native-linux-docker/
				]
			]
			Module: [
				https://trevorsullivan.net/2017/01/01/write-powershell-modules-not-scripts/
			]
			Async-event-hander: [
				https://blogs.technet.microsoft.com/heyscriptingguy/2011/06/16/use-asynchronous-event-handling-in-powershell/ < https://trevorsullivan.net/2017/11/29/powershell-intellisense-scriptblock-handler-parameters/
			]
			Data-stream: [
				https://trevorsullivan.net/2018/01/05/initialize-byte-array-powershell/
			]
		]
		Nodejs: [

			async-await: https://blog.patricktriest.com/what-is-async-await-why-should-you-care/

			encrypted-chat: https://blog.patricktriest.com/building-an-encrypted-messenger-with-javascript/
		
			streams: https://maxogden.com/node-streams.html
			
			debug: https://nitayneeman.com/posts/debugging-nodejs-application-in-chrome-devtools-using-ndb/
			
			https://blog.ghaiklor.com/how-to-start-contributing-in-nodejs-3b30209ba1c4
			https://blog.risingstack.com/contributing-to-the-node-js-core/
			https://blog.risingstack.com/node-js-development-tips-2018/
			https://blog.risingstack.com/free-local-api-server-nodejs/
			https://blog.risingstack.com/writing-native-node-js-modules/
			
		]
		ReactJs: [
			overview https://blog.bitsrc.io/how-to-write-better-code-in-react-best-practices-b8ca87d462b0
			beginner: https://medium.freecodecamp.org/a-complete-beginners-guide-to-react-4d490abc349c
			Stack: https://github.com/verekia/js-stack-from-scratch
			http://krasimirtsonev.com/blog/article/react-separation-of-concerns
			Server-Side: https://medium.com/airbnb-engineering/operationalizing-node-js-for-server-side-rendering-c5ba718acfc9
			Libraries: [
				https://dev.to/havardh/controlling-your-desktop-layout-with-react-1g0b
			]
			
		]
		
		Redux: [
			http://krasimirtsonev.com/blog/article/my-take-on-redux-architecture
			http://krasimirtsonev.com/blog/article/story-about-react-redux-server-side-rendering-ssr
		]
		
		ReactNative [
			Overview: https://hackernoon.com/just-completed-my-first-react-native-app-here-is-what-i-learnt-5ecb8a63b703
			https://levelup.gitconnected.com/how-i-ditched-expo-for-pure-react-native-fc0375361307
		]
		NativeScript: [
			Free-course https://courses.nativescripting.com/p/nativescript-enterprise-auth/?product_id=308158&coupon_code=AUTH101
			internals https://developer.telerik.com/featured/nativescript-works/
			setup https://www.nativescript.org/blog/setting-up-a-robust-nativescript-vue-development-environment
			authentication https://www.nativescript.org/blog/enterprise-authentication-made-easier-with-nativescript
		]
		Vscode-Extensibility: [
			Custom-icons https://code.visualstudio.com/blogs/2016/09/08/icon-themes
		]
		Deep-learning: [
			a-weird-introduction-to-deep-learning https://towardsdatascience.com/a-weird-introduction-to-deep-learning-7828803693b0
		]
		
		Docker: [
			Certificates: [
				https://trevorsullivan.net/2016/08/09/docker-login-error-x509-certificate-signed-unknown-authority/
			]
			Troubleshootings: [
				https://medium.com/@aguidrevitch/when-installation-of-global-package-using-npm-inside-docker-fails-b551b5dda389
			]
		]
		
		Kubernetes: [
			https://www.jamessturtevant.com/posts/Running-Kubernetes-Minikube-on-Windows-10-with-WSL/
		]
		
		Dotnet: [
			Fundamentals: [
				https://blogs.endjin.com/2018/06/garbage-collection-a-memorandum-on-memory-in-csharp/
			]
		]
    ]     
    
    Red-blogs: [
		mycode4fun http://www.mycode4fun.co.uk/example-scripts
    ]
    
    Registered: [
		genesis-mining https://www.genesis-mining.com/login-panel
		bitpanda https://www.bitpanda.com/en    
		amazondrive https://www.amazon.fr/clouddrive/folder/bgnL7anMR9a-OESoolqffQ?_encoding=UTF8&*Version*=1&*entries*=0&mgh=1
    ]
    
    To-post: [
		{cambodge} https://lepetitjournal.com/cambodge/actualites/cmk-le-retrait-discret-du-credit-mutuel-au-cambodge-240675
		{deming misunderstood} https://www.forbes.com/sites/henrydoss/2013/03/12/innovation-w-edwards-deming-and-john-keats-got-it-right/#608b96164791
		{sharing economy} https://medium.com/@shareablelife/airbnb-is-looking-to-offer-hosts-equity-the-evolution-of-the-sharing-economy-d4e6638d1fac
		{Parcoursup} https://twitter.com/jfreixas/status/1044264246010421249
		{mai 68} [http://www.lepoint.fr/actualites-societe/2009-04-02/les-archives-secretes-de-la-cia/920/0/331604]
		{probité} [https://www.youtube.com/watch?v=eUbJDaEFtwI]
		{inflation} [http://www.gaullisme.fr/2018/06/30/le-prix-du-gaz-va-augmenter-de-745-au-1er-juillet/]
		{degaulle et l'économie} [
			https://www.persee.fr/doc/ofce_0751-6614_1992_num_39_1_1260 
			http://www.trop-libre.fr/quand-de-gaulle-d%C3%A9fendait-un-sursaut-%C3%A9conomique-radical-la-r%C3%A9forme-lib%C3%A9rale-et-la-politique-de-rigueur/
		]
		{finance} [https://twitter.com/lepinekong/status/995937650279411712 https://www.youtube.com/watch?v=wcGgLXnBVLY]
		{privacy} https://twitter.com/Carnage4Life/status/1043646266142425089
		{Le commerce d'esclaves blancs chez les arabes et musulmans} [https://www.youtube.com/watch?v=2AcimRZlNX8]
		{education} [https://forums.futura-sciences.com/debats-scientifiques/829029-systeme-educatif-deconnecte-de-realite.html]
		{to post} http://www.scrumexpert.com/videos/death-by-user-stories/
		{Fraude fiscale} https://www.youtube.com/watch?v=7amgw038D5k
		{Financiarisation RéchauffementClimatique} https://www.youtube.com/watch?v=ychwDoh5GIo
		{Agile} http://doingthedishes.com/2008/05/12/maybe-developers-dont-even-know-what-they-want.html
		{Maryam Mirzakhani} [
			https://news.artnet.com/art-world/maryam-mirzakhani-fields-winner-doodler-79848
			https://culturess.com/2017/02/06/maryam-mirzakhani-busts-stereotypes-women-science/
			https://news.stanford.edu/2017/07/15/maryam-mirzakhani-stanford-mathematician-and-fields-medal-winner-dies/
		]
		{Barbara Oakley: "Learning How to Learn" | Talks at Google} https://www.youtube.com/watch?v=vd2dtkMINIw
		{Security} [https://snyk.io/blog/behind-the-disclosure-the-zip-slip-vulnerability https://www.bleepingcomputer.com/news/security/windows-systems-vulnerable-to-fragmentsmack-90s-like-dos-bug/]
		{magnetic field} https://www.youtube.com/watch?v=Dshhe7dt6Jg
		{geo-ingénierie} https://www.youtube.com/watch?v=NXGVtQYicpo
		your-web-app-is-bloated https://github.com/dominictarr/your-web-app-is-bloated
		{Systems Thinking Speech by Dr. Russell Ackoff} https://www.youtube.com/watch?v=EbLh7rZ3rhU
		{how-i-gained-commit-access-to-homebrew-in-30-minutes-2ae314df03ab} https://medium.com/@vesirin/how-i-gained-commit-access-to-homebrew-in-30-minutes-2ae314df03ab
		{Trepalium https://www.youtube.com/watch?v=6uRmfnFBbj4}
		http://blog.builtinnode.com/post/node-js-will-overtake-java-within-a-year-analysis
		;--- it rants
		https://stevebennett.me/2012/02/24/10-things-i-hate-about-git/
		;--- future
		codefuture: https://www.theatlantic.com/technology/archive/2017/09/saving-the-world-from-code/540393/
    ]

    VSCode-Extensions: [

        Command-Lines: [
            https://marketplace.visualstudio.com/items?itemName=odonno.new-cmd
        ]

        File-Templating: [
            .links [
                {New File with Language Mode} https://marketplace.visualstudio.com/items?itemName=hoovercj.vscode-newfile-languagemode
                {new file by type} https://marketplace.visualstudio.com/items?itemName=Rectcircle.new-file-by-type
                {vscTemplate} https://marketplace.visualstudio.com/items?itemName=daoye.vsctemplate
                {File Templates for VSCode} https://marketplace.visualstudio.com/items?itemName=bam.vscode-file-templates
                {VZ File Templates} https://marketplace.visualstudio.com/items?itemName=VisualZoran.vz-file-templates
                {Banxi File Templates} https://marketplace.visualstudio.com/items?itemName=banxi.banxi-file-templates
                {File Templates Manager} https://marketplace.visualstudio.com/items?itemName=3axap4eHko.file-templates-manager
                {File Templates} https://marketplace.visualstudio.com/items?itemName=brpaz.file-templates
                {Blueprint} https://marketplace.visualstudio.com/items?itemName=teamchilla.blueprint
                {code Template Replace} https://marketplace.visualstudio.com/items?itemName=heekei.code-template-replace
                {code-templates} https://marketplace.visualstudio.com/items?itemName=wooboo.code-templates
                {Code Template Tool} https://marketplace.visualstudio.com/items?itemName=yuanhjty.code-template-tool
                {Template Generator} https://marketplace.visualstudio.com/items?itemName=DengSir.template-generator-vscode
                {File Template } https://marketplace.visualstudio.com/items?itemName=RalfZhang.filetemplate
                {Ajuro Template Processor} https://github.com/profimedica/Templater/wiki/Ajuro-Template-Processor
                {docs-article-templates} https://marketplace.visualstudio.com/items?itemName=docsmsft.docs-article-templates
            ]
        ]
        
        Installed: [
			https://marketplace.visualstudio.com/items?itemName=lostfields.nodejs-repl
        ]
    
    ]
    
    Other-tools: [
		javareplit https://repl.it/repls/FrailOutlyingBackend
		codeenvy https://codenvy.com/f?id=h7yq7nqzfa7ghhqh
		syntaxdb https://syntaxdb.com/
		java-codegen-pojo http://pojo.sodhanalibrary.com/
		jsfiddle https://jsfiddle.net/
		youtubetime http://youtubetime.com/
		jsoneditor http://jeremydorn.com/json-editor/
		json-to-csv https://json-csv.com/c/usEt
		csv-to-json http://www.convertcsv.com/csv-to-json.htm
		twittimer https://twittimer.com
		vectormagic https://vectormagic.com/
		mockupdesigner http://fatiherikli.github.io/mockup-designer/
		url2png https://www.url2png.com
		snaggy https://snag.gy/
		summarizer http://www.junglekey.fr/resume.php
		wordpress-plugin-generator https://wppb.me/
		youtube-thumbnail http://www.get-youtube-thumbnail.com/
		pagepeeker-website-thumbnail http://pagepeeker.com/
		dirtymarkup https://www.10bestdesign.com/dirtymarkup/
		typescript http://www.typescriptlang.org/play/
		datecalc https://www.calculator.net/date-calculator.html?today2=01%2F30%2F2016&c2op=-&c2year=40&c2month=0&c2week=0&c2day=0&calctype=op&x=50&y=5
    ]
    
    Free-courses: [
		.resources-sites: [
			https://medium.com/100-free-udemy-coupons
			http://www.programmingbuddy.club
			https://www.freetutorials.us/
		]
    ]
    
    Guides: [
		authoring: [
			.links: [
				https://docs.pact.io/
			]
		]
		Others: [
			.links: [
				Github-Improve https://blog.github.com/2018-08-28-announcing-paper-cuts/
				unicode https://www.compart.com/en/unicode/U+0052
				vscodesnippets https://code.visualstudio.com/docs/editor/userdefinedsnippets
				webtools https://www.codewall.co.uk/best-online-web-tools-for-web-developers-and-programmers/
			]
		]
    ]
    
    Guide-Embauche: [
		alternance https://www.cidj.com/contrats-en-alternance-vous-etes-aide-pour-embaucher
		apprentissage [ http://www.proactiveacademy.fr/blog/recrutement/etapes-embaucher-jeune-contrat-apprentissage/
			https://www.legisocial.fr/contrat-de-travail/contrats-de-travail/comment-embaucher-jeune-contrat-apprentissage.html
		]
    ]
    
    Guide-Administratif: [
		Impots: [
			https://www.impots.gouv.fr/portail/particulier/jai-perdu-mon-emploi
		]
    ]
    
    Guide-Pedagogique: [
		Cuisine: [
			http://fabriqueaspecialites.free.fr/index.php/a-sabote-plat-chef/ < https://www.lepointdufle.net/penseigner/cuisine_gastronomie-fiches-pedagogiques.htm
		]
    ]
    
    Productivit�: [
		Planner-Prof: [
			http://carnetdeprof2018.strikingly.com
		]
    ]
    
    Jobs: [
		Javascript-paris: [
			{Lead d�veloppeur Exp�riement� Front/Back JAVASCRIP (H/F)} https://www.leboncoin.fr/offres_d_emploi/1487676820.htm/
		]
		
		Ind�pendant-Immobilier: [
			proprietes-privees https://www.proprietes-privees.org/contact9.php
		]
		
		apprentissage-dev: [
			PHP https://www.leboncoin.fr/offres_d_emploi/1466414231.htm/
			mon-alternance.fr http://mon-alternance.fr/offres-alternance-paris.php
		]
    ]
    
    
    Forex: [
		tickdata: https://pepperstone.com/uk/client-resources/historical-tick-data#
    ]

    to-try: [
    
		Cloud-IDE: [
			https://proxy-engineering-paiza-io.paiza.cloud/entry/paizacloud_app
			https://trevorsullivan.net/2018/07/13/aws-cloud9-ec2-powershell-dotnet-core/
		]
		
		API-services: [
			https://getsandbox.com/pricing
		]
    
		VSCode-extensibility: [
			https://stackoverflow.com/questions/41068197/vscode-create-unsaved-file-and-add-content
		]
    
		npm-alternative: [
			https://medium.com/@ericsimons/introducing-turbo-5x-faster-than-yarn-npm-and-runs-natively-in-browser-cc2c39715403
		]
    
		CI: [
			https://medium.com/@lionel.dupouy/déploiement-continue-avec-circleci-et-clever-cloud-9c756b291d8e
		]
		
		Editor: [
			https://medium.com/@ericsimons/stackblitz-online-vs-code-ide-for-angular-react-7d09348497f4
		]
		
		Youtube-live: [
			https://trevorsullivan.net/2015/08/27/getting-started-with-youtube-gaming/
		]
		git-client: [
			https://www.cycligent.com/git-tool < https://www.reddit.com/r/git/comments/6cu9w3/gitkraken_is_by_far_the_most_frustrating_git/
		]
		freewares: [
			https://trevorsullivan.net/2015/09/20/image-re-sizing-utility-for-windows/
		]
		nodegit: [
			https://blog.axosoft.com/cross-platform-nodegit-app/
			https://radek.io/2015/10/27/nodegit/
			https://gitlab.com/antora/antora/issues/264
			
		]
        ejs [http://ejs.co/ https://marketplace.visualstudio.com/items?itemName=kevgl.ejs-eval]
        VSCode-extensions [
            .links: [
                https://marketplace.visualstudio.com/items?itemName=mrluje.vscode-extensions-pack-builder
                https://marketplace.visualstudio.com/items?itemName=aisoftware.tt-processor
                https://marketplace.visualstudio.com/items?itemName=itslennysfault.scaffs-vscode
                https://marketplace.visualstudio.com/items?itemName=cg-cnu.vscode-codetags
                https://marketplace.visualstudio.com/items?itemName=jsTestGen.js-test-gen-vscode
                https://marketplace.visualstudio.com/items?itemName=yatki.vscode-surround
                https://marketplace.visualstudio.com/items?itemName=webreflection.literally-html
                https://marketplace.visualstudio.com/items?itemName=bierner.lit-html
                https://github.com/mydesireiscoma/es6-string-html
                https://marketplace.visualstudio.com/items?itemName=mscolnick.export-typescript
                ;--- java
                https://marketplace.visualstudio.com/items?itemName=mellena1.eclipse-new-java-project
            ]
            
        ]
            
    ]
    
    for-projects: [
		MyOpensource: [
			https://marketplace.visualstudio.com/items?itemName=sleistner.vscode-fileutils
		]
    ]
    
    Jobs: [
		reactjs.trading https://stackoverflow.com/jobs/201917/react-developer-itg
    ]
    
    Daily: [
        .title: "Daily" 
        .links: [
			Medium medium
            pragmatists https://blog.pragmatists.com 
            https://4sysops.com/archives/
            Dzone dzone
            Devto dev.to
            Redlang https://gitter.im/red/help 
            dormoshe https://dormoshe.io/daily-news 
            futurism https://futurism.com/
            freeudemy https://medium.com/100-free-udemy-coupons
        ]
    ] 
    Weekly: [
        .title: "Weekly" 
        .links: [
            JSWeekly javascriptweekly
            MyBridge https://medium.mybridge.co/@Mybridge
            tjvantoll https://www.tjvantoll.com/writing/
        ]
    ] 
    Monthly: [
        .title: "Monthly" 
        .links: [
            Codemag http://www.codemag.com/Magazine/AllIssues 
            VSMag https://visualstudiomagazine.com/Home.aspx 
            MSDN https://msdn.microsoft.com/en-us/magazine/msdn-magazine-issues.aspx
			Red-lang red-lang.org
        ]
    ]
    
	Jeux-de-cartes-personnalis?es: [

        title: {Jeux de cartes personnalis?es}
        
        Kits: [
            .links: [
                https://www.thegamecrafter.com/ < https://www.dealabs.com/discussions/jeu-de-carte-personnalise-1060125
                https://toutpourlejeu.com/fr/48-cartes-speciales-blanches
        https://toutpourlejeu.com/fr/rangement-pour-accessoires-jeux/516-boite-plastique-double-pour-2-jeux-54-cartes-a-jouer-transparentes-vide-4250267402321.html
            ]
        ]
        
        Tutoriels: [
            .links: [
                https://www.virtualmagie.com/articles/autres/trucs-du-metier/imprimer-ses-cartes-a-jouer/
            ]
        ]
        
        Machine-a-decoupe: [
            .links: [
                http://www.maitresseuh.fr/une-machine-a-decouper-pour-la-classe-utile-ou-pas-idees-d-utilisation-a135595862
                https://www.plastifieuses.fr/decoupeuse-cartes-de-visite/692-decoup-card-coupeuse-de-cartes-manuelle.html
                https://patricefau.jimdo.com/ressources-de-cr%C3%A9ation/
                https://forum.hardware.fr/hfr/Graphisme/PAO-Desktop-Publishing/imprimeur-cartes-tirage-sujet_34511_1.htm
            ]
        ]
        Imprimerie: [
            .links: [
                http://www.loiseauplume.fr/cartes-et-tuiles.html
                https://www.jeux-de-cartes-personnalises.fr/prix/
                https://www.printbasprix.com/Panier/Produit/jeudecarte
                https://www.makeplayingcards.com/design/personalized-tcg-cards.html
                https://www.liceografico.com/fr/jeux-de-cartes/3203-jeux-de-cartes-de-dessin-libre.html 
            ]
        ]    
    ]

    

