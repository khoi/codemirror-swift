//
//  EditorViewController.swift
//  Examples
//
//  Created by khoi on 16/06/2022.
//

import AppKit
import CodeMirror
import Combine

class EditorViewController: NSViewController, CodeMirrorWebViewDelegate {
    @IBOutlet weak var languagePopupButton: NSPopUpButton!
    @IBOutlet weak var codeMirrorView: CodeMirrorWebView!

    private var darkmode = true

    override func viewDidLoad() {
        super.viewDidLoad()
        codeMirrorView.getSupportedLanguages { [weak self] result in
            switch result {
            case let .success(value):
                self?.setupLanguageButton(langs: value as! [String])
            case let .failure(err):
                fatalError(err.localizedDescription)
            }
        }

        codeMirrorView.delegate = self
    }

    @IBAction func toggleDarkMode(_ sender: Any) {
        darkmode.toggle()
        codeMirrorView.setDarkMode(on: darkmode)
    }

    @IBAction func languageChanged(_ sender: Any) {

        guard let lang = languagePopupButton.titleOfSelectedItem else {
            return
        }

        codeMirrorView.setLanguage(lang)
    }

    private func setupLanguageButton(langs: [String]) {
        languagePopupButton.removeAllItems()
        langs.forEach(languagePopupButton.addItem(withTitle:))
        languagePopupButton.selectItem(at: 0)
        languageChanged(self)
    }

    @IBAction func fillWithTextPressed(_ sender: Any) {
        let text = exampleTexts[languagePopupButton.titleOfSelectedItem ?? ""]
        codeMirrorView.setContent(text ?? "\(languagePopupButton.titleOfSelectedItem ?? "nothing")")
    }

    func codeMirrorViewDidLoadSuccess(_ sender: CodeMirrorWebView) {

    }

    func codeMirrorViewDidLoadError(_ sender: CodeMirrorWebView, error: Error) {

    }

    func codeMirrorViewDidChangeContent(_ sender: CodeMirrorWebView, content: String) {
        //        print(content) # print can be costly if document is huge
    }
}

private let exampleTexts: [String: String] = [
    "html": """
        <!DOCTYPE html>
        <html lang="en">
          <head>
            <meta charset="utf-8">
            <title>title</title>
            <link rel="stylesheet" href="style.css">
            <script src="script.js"></script>
          </head>
          <body>
            <!-- page content -->
          </body>
        </html>
        """,
    "json": """
        {
          "glossary": {
            "title": "example glossary",
            "GlossDiv": {
              "title": "S",
              "GlossList": {
                "GlossEntry": {
                  "ID": "SGML",
                  "SortAs": "SGML",
                  "GlossTerm": "Standard Generalized Markup Language",
                  "Acronym": "SGML",
                  "Abbrev": "ISO 8879:1986",
                  "GlossDef": {
                    "para": "A meta-markup language, used to create markup languages such as DocBook.",
                    "GlossSeeAlso": ["GML", "XML"]
                  },
                  "GlossSee": "markup"
                }
              }
            }
          }
        }
        """,
    "javascript": """
        for(B=i=y=u=b=i=5-5,x=10,I=[],l=[];B++<304;I[B-1]=B%x?B/x%x<2|B%x<2?7:B/x&4?0:l[i++]="ECDFBDCEAAAAAAAAIIIIIIIIMKLNJLKM@G@TSb~?A6J57IKJT576,+-48HLSUmgukgg OJNMLK  IDHGFE".charCodeAt(y++)-64:7);function X(c,h,e,s){c^=8;for(var o,S,C,A,R,T,G,d=e&&X(c,0)>1e4,n,N=-1e8,O=20,K=78-h<<9;++O<99;)if((o=I[T=O])&&(G=o^c)<7){A=G--&2?8:4;C=o-9?l[61+G]:49;do if(!(R=I[T+=l[C]])&&!!G|A<3||(R+1^c)>9&&G|A>2){if(!(R-2&7))return K;n=G|(c?T>29:T<91)?o:6^c;S=(R&&l[R&7|32]*2-h-G)+(n-o?110:!G&&(A<2)+1);if(e>h||1<e&e==h&&S>2|d){I[T]=n;I[O]=0;S-=X(c,h+1,e,S-N);if(!(h||e-1|B-O|T-b|S<-1e4))return W(),c&&setTimeout("X(8,0,2),X(8,0,1)",75);I[O]=o;I[T]=R}if(S>N||!h&S==N&&Math.random()<.5)if(N=S,e>1)if(h?s-S<0:(B=O,b=T,0))break}while(!R&G>2||(T=O,(G||A>2|(c?O>78:O<41)&!R)&&++C*--A))}return-K+768<N|d&&N}function W(){i="<table>";for(u=18;u<99;document.body.innerHTML=i+=++u%x-9?"<th width=60 height=60 onclick='I[b="+u+"]>8?W():X(0,0,1)'style='font-size:50px'bgcolor=#"+(u-B?u*.9&1||9:"d")+"0f0e0>&#"+(I[u]?9808+l[67+I[u]]:160):u++&&"<tr>")B=b}W()
        """,
    "css": """
        body{background-color:#fff;color:#404040;display:block;font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;font-size:13px;font-weight:400;line-height:18px;margin:0;padding:0}#container{margin-left:auto;margin-right:auto;width:980px}#top{box-shadow:#eee 0 0 8px 0;border-radius:6px;height:128px;margin-bottom:20px;padding:15px 60px 45px 60px;position:relative;text-align:center;top:-8px;width:820px}#top>a>img{position:absolute;top:25px;left:30px;width:150px;height:150px;border:0;margin:0;padding:0}#top>h1{font-size:18px;margin:25px 0 8px 0;padding:0;border:0;font-weight:200}#top>h2{font-size:20px;margin:16px 0;padding:0;border:0}.menu-button{font-size:15px;line-height:normal;padding:9px 14px 9px;display:inline-block;text-decoration:none;font-weight:700;margin:0;color:#333;border:1px solid #ccc;border-bottom-color:#bbb;-webkit-border-radius:2px;-moz-border-radius:2px;border-radius:2px;background-color:#e6e6e6;background-repeat:no-repeat;background-image:-webkit-gradient(linear,0 0,0 100%,from(#fff),color-stop(25%,#fff),to(#e6e6e6));background-image:-webkit-linear-gradient(#fff,#fff 25%,#e6e6e6);background-image:-moz-linear-gradient(top,#fff,#fff 25%,#e6e6e6);background-image:-ms-linear-gradient(#fff,#fff 25%,#e6e6e6);background-image:-o-linear-gradient(#fff,#fff 25%,#e6e6e6);background-image:linear-gradient(#fff,#fff 25%,#e6e6e6);text-shadow:0 1px 1px rgba(255,255,255,.75);-webkit-box-shadow:inset 0 1px 0 rgba(255,255,255,.2),0 1px 2px rgba(0,0,0,.05);-moz-box-shadow:inset 0 1px 0 rgba(255,255,255,.2),0 1px 2px rgba(0,0,0,.05);box-shadow:inset 0 1px 0 rgba(255,255,255,.2),0 1px 2px rgba(0,0,0,.05);-webkit-transition:.1s linear all;-moz-transition:.1s linear all;-ms-transition:.1s linear all;-o-transition:.1s linear all;transition:.1s linear all}.menu-button:hover{background-position:0 -15px;color:#333;text-decoration:none}.menu-button.disabled{cursor:default;background-image:none;-khtml-opacity:0.65;-moz-opacity:0.65;opacity:.65;-webkit-box-shadow:none;-moz-box-shadow:none;box-shadow:none;pointer-events:none;color:#bbb}.menu-button.current{color:#777}.mailing,.updator{text-align:center}.updator{margin-bottom:20px}#root .updator{clear:left}#root img{float:left;width:319px;height:321px}#root h1{text-align:center;padding-top:70px}#root menu{margin-top:50px}#root menu div{text-align:center;margin:20px 0}#root footer p{float:right;margin-right:20px}#root aside{text-align:center}#root .menu-button.now{background:linear-gradient(to right,red,#ff0,green,#0ff,#00f,violet);text-shadow:-2px 0 #000,0 2px #000,2px 0 #000,0 -2px #000;color:#fff;font-size:20px}#root .menu-button.now:hover{background:linear-gradient(to right,violet,#00f,#0ff,green,#ff0,red)}@media (max-width:1000px){#root #container{width:auto}}@media (max-width:900px){#root h1{line-height:30px}#root img{max-width:90%;margin-left:5%}#root #container{width:350px}#root .menu-button{margin:0 0 20px 0}#root menu div{margin:0;padding:0}#root menu{padding:0;margin:0}}section>div>h3{font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;font-size:18px;font-style:normal;font-weight:700;line-height:20px;margin:0 0 8px 0;padding:0;overflow:hidden;white-space:nowrap;text-overflow:ellipsis}section>div>p{margin-left:80px;margin-bottom:9px;padding:0}p+a,p+a+a{float:right;clear:right}section.demos>div>h3{margin:0 0 3px 0;padding:0;font-size:16px}section.demos>div>menu{margin:5px 0 0 0;padding:0;min-height:10px}section.demos>div>p{margin-left:60px}.links>b,.links>span{margin-right:10px}.demos .bgi-demo{width:50px;height:50px;float:left;margin-right:10px;margin-top:5px;border:1px solid #000}#home section>header{margin:0 0 40px 0}#home section>header>h2{font-size:24px;font-weight:700;height:36px;line-height:36px;margin:0;padding:0}#home .bgi-front{float:left;width:50px;height:50px;margin:0 8px;padding:0;border-radius:99em;border:0}#home [href="https://twitter.com/"]{display:none}#home [href="https://twitter.com/"]{display:none}#home [style="background-position: -px -px;"]{display:none}#demos section>div>p{margin-left:0}#demos .mailing,#demos .updator{text-align:left}section{float:left;margin:0 20px 20px 0;width:300px}section>div{margin:0;overflow:auto;width:300px}section>hr:last-child{display:none}#rules>#container>ol{counter-reset:rules;margin-top:30px}#rules>#container>ol>li{counter-increment:rules}#rules>#container>ol ol>li:before{content:counter(rules) ".";margin-left:-35px;margin-right:30px}code{font-family:monospace;background-color:#fff6eb;color:rgba(0,0,0,.75);padding:1px 3px 1px 5px;line-height:1;-ms-tab-size:2;-webkit-tab-size:2;-moz-tab-size:2;-o-tab-size:2;tab-size:2}#submit .after-contest{opacity:.3}#submit .hidden{display:none}form>header{border-bottom:1px solid #eee;padding:5px 15px;margin-bottom:30px}.form-item{color:grey;clear:left;margin:10px;overflow:auto}.bots{visibility:hidden;height:0;margin:0;padding:0}#submit .form-item.with-check>div{padding-top:6px}.form-item>label,.submit-part>label{padding-top:6px;font-size:13px;float:left;width:130px;text-align:right;color:#404040;margin-right:10px}label.checkbox{height:50px;line-height:50px}label.radio{padding:0;margin:6px 0 0 0;width:125px;height:30px;text-align:center}input,textarea{width:210px;height:18px;padding:4px;font-size:13px;line-height:18px;color:#404040;border:1px solid #ccc;-webkit-border-radius:3px;-moz-border-radius:3px;border-radius:3px;margin:0;-webkit-transition:border linear .2s,box-shadow linear .2s;-moz-transition:border linear .2s,box-shadow linear .2s;-ms-transition:border linear .2s,box-shadow linear .2s;-o-transition:border linear .2s,box-shadow linear .2s;transition:border linear .2s,box-shadow linear .2s;-webkit-box-shadow:inset 0 1px 3px rgba(0,0,0,.1);-moz-box-shadow:inset 0 1px 3px rgba(0,0,0,.1);box-shadow:inset 0 1px 3px rgba(0,0,0,.1)}#submit .short{width:50px}#submit .wide{width:550px}textarea{width:400px;height:auto}input:focus,textarea:focus{outline:0;border-color:rgba(82,168,236,.8);-webkit-box-shadow:inset 0 1px 3px rgba(0,0,0,.1),0 0 8px rgba(82,168,236,.6);-moz-box-shadow:inset 0 1px 3px rgba(0,0,0,.1),0 0 8px rgba(82,168,236,.6);box-shadow:inset 0 1px 3px rgba(0,0,0,.1),0 0 8px rgba(82,168,236,.6)}input[type=checkbox],input[type=radio]{width:auto;height:auto;padding:0;margin:3px 0 0 5px;cursor:pointer}input[type=radio]{vertical-align:sub;margin-right:5px}input[type=checkbox]:focus,input[type=radio]:focus{outline:1px dotted #666}input:focus,textarea:focus{outline:0;border-color:rgba(82,168,236,.8);-webkit-box-shadow:inset 0 1px 3px rgba(0,0,0,.1),0 0 8px rgba(82,168,236,.6);-moz-box-shadow:inset 0 1px 3px rgba(0,0,0,.1),0 0 8px rgba(82,168,236,.6);box-shadow:inset 0 1px 3px rgba(0,0,0,.1),0 0 8px rgba(82,168,236,.6)}.canvas-element-settings{border-color:rgba(255,255,255,.3);background-color:#fff;border-radius:5px;width:540px;margin-left:148px}.canvas-element-settings>legend{padding:0 10px;font-size:18px;color:#888}.canvas-element-settings label{text-align:left}.canvas-element-settings .with-check label{width:155px}.canvas-element-settings .with-check input{float:right}.submit-part{background-color:#f5f5f5;padding:0 15px 15px;border-top:1px solid #ddd;-webkit-border-radius:0 0 6px 6px;-moz-border-radius:0 0 6px 6px;border-radius:0 0 6px 6px;-webkit-box-shadow:inset 0 1px 0 #fff;-moz-box-shadow:inset 0 1px 0 #fff;box-shadow:inset 0 1px 0 #fff;margin-bottom:0;overflow:auto}#submit .submit-part>input{clear:left}#submit .submit-part>label{height:30px;line-height:30px;width:auto;clear:left}input.menu-button{height:40px;float:left;margin-top:20px}a{color:#890000;text-decoration:none;font-weight:700}a:hover{text-decoration:underline}a:active,a:hover{outline:0}a:focus{outline:0}hr{margin:20px 0 19px;border:0;border-bottom:1px solid #eee}footer{margin-top:17px;padding-top:17px;border-top:1px solid #eee;clear:left}#details dd{white-space:pre-line;max-width:800px}#details .modal-header{max-width:600px;max-width:80ch;font-family:monospace}#details .modal-header h2,#details .modal-header p{font-family:'Helvetica Neue',Helvetica,Arial,sans-serif}#details .modal-header h2{font-size:25px}#details .modal-header p{font-size:16px}#details dd>pre{max-width:600px;max-width:80ch;word-break:break-all;white-space:pre-wrap;text-align:left;margin:0;padding:0;background-color:#fff6eb}#details dd>pre>code{margin:0;padding:0;border:0;font-size:13px}#details code>span{color:#6034a0}#details dt{margin-bottom:5px;clear:left}#details dd:last-child,#details dd:last-child code,#details dd:last-child pre{white-space:pre-wrap;max-width:900px;word-break:normal;background:#fff6eb;background-image:-ms-linear-gradient(left,#fff6eb 75%,#fff 100%);background-image:-moz-linear-gradient(left,#fff6eb 75%,#fff 100%);background-image:-o-linear-gradient(left,#fff6eb 75%,#fff 100%);background-image:-webkit-gradient(linear,left top,right top,color-stop(.75,#fff6eb),color-stop(1,#fff));background-image:-webkit-linear-gradient(left,#fff6eb 75%,#fff 100%);background-image:linear-gradient(to right,#fff6eb 75%,#fff 100%)}#details dd:last-child code{background:0 0}#details .thumb{width:50px;height:50px;border:1px solid #000;float:right;margin:-7px 0 5px 5px}#details dd{margin-top:20px;margin-bottom:20px}#details dt.one-line{float:left;margin:0 5px 0 0;padding:0;width:70px}#details dt.one-line+dd{margin:0;padding:0}#details dt.newline,#details dt.newline+dd{margin-bottom:15px}#details dt.empty,#details dt.empty+dd{display:none}#details dt.link+dd,#details dt.links+dd{overflow:hidden}#details dt.link+dd>a,#details dt.link+dd>span{font-family:monospace;margin-left:-7ch;margin-left:calc(.5px - 7ch)}#details dt.links+dd>a,#details dt.links+dd>span{font-family:monospace;margin-left:-8ch;margin-left:calc(.5px - 8ch)}#details nav>a[href=""]{text-decoration:line-through;pointer-events:none;color:#ccc}
        """,
    "xml": """
        <?xml version="1.0" encoding="UTF-8"?><CATALOG><CD><TITLE>Empire Burlesque</TITLE><ARTIST>Bob Dylan</ARTIST><COUNTRY>USA</COUNTRY><COMPANY>Columbia</COMPANY><PRICE>10.90</PRICE><YEAR>1985</YEAR></CD><CD><TITLE>Hide your heart</TITLE><ARTIST>Bonnie Tyler</ARTIST><COUNTRY>UK</COUNTRY><COMPANY>CBS Records</COMPANY><PRICE>9.90</PRICE><YEAR>1988</YEAR></CD><CD><TITLE>Greatest Hits</TITLE><ARTIST>Dolly Parton</ARTIST><COUNTRY>USA</COUNTRY><COMPANY>RCA</COMPANY><PRICE>9.90</PRICE><YEAR>1982</YEAR></CD><CD><TITLE>Still got the blues</TITLE><ARTIST>Gary Moore</ARTIST><COUNTRY>UK</COUNTRY><COMPANY>Virgin records</COMPANY><PRICE>10.20</PRICE><YEAR>1990</YEAR></CD><CD><TITLE>Eros</TITLE><ARTIST>Eros Ramazzotti</ARTIST><COUNTRY>EU</COUNTRY><COMPANY>BMG</COMPANY><PRICE>9.90</PRICE><YEAR>1997</YEAR></CD><CD><TITLE>One night only</TITLE><ARTIST>Bee Gees</ARTIST><COUNTRY>UK</COUNTRY><COMPANY>Polydor</COMPANY><PRICE>10.90</PRICE><YEAR>1998</YEAR></CD><CD><TITLE>Sylvias Mother</TITLE><ARTIST>Dr.Hook</ARTIST><COUNTRY>UK</COUNTRY><COMPANY>CBS</COMPANY><PRICE>8.10</PRICE><YEAR>1973</YEAR></CD><CD><TITLE>Maggie May</TITLE><ARTIST>Rod Stewart</ARTIST><COUNTRY>UK</COUNTRY><COMPANY>Pickwick</COMPANY><PRICE>8.50</PRICE><YEAR>1990</YEAR></CD><CD><TITLE>Romanza</TITLE><ARTIST>Andrea Bocelli</ARTIST><COUNTRY>EU</COUNTRY><COMPANY>Polydor</COMPANY><PRICE>10.80</PRICE><YEAR>1996</YEAR></CD><CD><TITLE>When a man loves a woman</TITLE><ARTIST>Percy Sledge</ARTIST><COUNTRY>USA</COUNTRY><COMPANY>Atlantic</COMPANY><PRICE>8.70</PRICE><YEAR>1987</YEAR></CD><CD><TITLE>Black angel</TITLE><ARTIST>Savage Rose</ARTIST><COUNTRY>EU</COUNTRY><COMPANY>Mega</COMPANY><PRICE>10.90</PRICE><YEAR>1995</YEAR></CD><CD><TITLE>1999 Grammy Nominees</TITLE><ARTIST>Many</ARTIST><COUNTRY>USA</COUNTRY><COMPANY>Grammy</COMPANY><PRICE>10.20</PRICE><YEAR>1999</YEAR></CD><CD><TITLE>For the good times</TITLE><ARTIST>Kenny Rogers</ARTIST><COUNTRY>UK</COUNTRY><COMPANY>Mucik Master</COMPANY><PRICE>8.70</PRICE><YEAR>1995</YEAR></CD><CD><TITLE>Big Willie style</TITLE><ARTIST>Will Smith</ARTIST><COUNTRY>USA</COUNTRY><COMPANY>Columbia</COMPANY><PRICE>9.90</PRICE><YEAR>1997</YEAR></CD><CD><TITLE>Tupelo Honey</TITLE><ARTIST>Van Morrison</ARTIST><COUNTRY>UK</COUNTRY><COMPANY>Polydor</COMPANY><PRICE>8.20</PRICE><YEAR>1971</YEAR></CD><CD><TITLE>Soulsville</TITLE><ARTIST>Jorn Hoel</ARTIST><COUNTRY>Norway</COUNTRY><COMPANY>WEA</COMPANY><PRICE>7.90</PRICE><YEAR>1996</YEAR></CD><CD><TITLE>The very best of</TITLE><ARTIST>Cat Stevens</ARTIST><COUNTRY>UK</COUNTRY><COMPANY>Island</COMPANY><PRICE>8.90</PRICE><YEAR>1990</YEAR></CD><CD><TITLE>Stop</TITLE><ARTIST>Sam Brown</ARTIST><COUNTRY>UK</COUNTRY><COMPANY>A and M</COMPANY><PRICE>8.90</PRICE><YEAR>1988</YEAR></CD><CD><TITLE>Bridge of Spies</TITLE><ARTIST>T'Pau</ARTIST><COUNTRY>UK</COUNTRY><COMPANY>Siren</COMPANY><PRICE>7.90</PRICE><YEAR>1987</YEAR></CD><CD><TITLE>Private Dancer</TITLE><ARTIST>Tina Turner</ARTIST><COUNTRY>UK</COUNTRY><COMPANY>Capitol</COMPANY><PRICE>8.90</PRICE><YEAR>1983</YEAR></CD><CD><TITLE>Midt om natten</TITLE><ARTIST>Kim Larsen</ARTIST><COUNTRY>EU</COUNTRY><COMPANY>Medley</COMPANY><PRICE>7.80</PRICE><YEAR>1983</YEAR></CD><CD><TITLE>Pavarotti Gala Concert</TITLE><ARTIST>Luciano Pavarotti</ARTIST><COUNTRY>UK</COUNTRY><COMPANY>DECCA</COMPANY><PRICE>9.90</PRICE><YEAR>1991</YEAR></CD><CD><TITLE>The dock of the bay</TITLE><ARTIST>Otis Redding</ARTIST><COUNTRY>USA</COUNTRY><COMPANY>Stax Records</COMPANY><PRICE>7.90</PRICE><YEAR>1968</YEAR></CD><CD><TITLE>Picture book</TITLE><ARTIST>Simply Red</ARTIST><COUNTRY>EU</COUNTRY><COMPANY>Elektra</COMPANY><PRICE>7.20</PRICE><YEAR>1985</YEAR></CD><CD><TITLE>Red</TITLE><ARTIST>The Communards</ARTIST><COUNTRY>UK</COUNTRY><COMPANY>London</COMPANY><PRICE>7.80</PRICE><YEAR>1987</YEAR></CD><CD><TITLE>Unchain my heart</TITLE><ARTIST>Joe Cocker</ARTIST><COUNTRY>USA</COUNTRY><COMPANY>EMI</COMPANY><PRICE>8.20</PRICE><YEAR>1987</YEAR></CD></CATALOG>

        """,
]
