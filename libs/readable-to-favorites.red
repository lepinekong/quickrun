Red [
    Title: ""
]

.readable-to-favorites: function [>readable-data][

    block>: copy []

    .readable-data: >readable-data

    title: select .readable-data 'Title ; extract title from .readable-data
    Sub-title: select .readable-data 'Sub-Title ; extract sub-title from .readable-data
    Paragraphs: select .readable-data 'Paragraphs ; extract all paragraphs from .readable-datas


    if none? Paragraphs [
        Paragraphs: copy []
        forall .readable-data [

            label: .readable-data/1
            value: .readable-data/2

            if block? value [
                if set-word? label [
                    append Paragraphs label
                    append/only Paragraphs value
                ]
            ]
        ]
    ]

    foreach [label content] Paragraphs [
        append block> label
        links: select content '.links
        either not none? links [
            append/only block> links
        ][
            append/only block> content
        ]
        
    ]
    return  block>

]

readable-to-favorites: :.readable-to-favorites
