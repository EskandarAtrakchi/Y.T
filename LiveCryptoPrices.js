<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Live prices</title>
        <!-- inspired from here https://co-in.io/crypto-price-widget/-->
    </head>
    <style>
        body {
            width: 50%;
            height: 100%;
            margin: 0 auto;
            background-color: white;
            padding: 7px;
        }
    </style>
    <body>
        <script>
            !(function () {
                var e = document.getElementsByTagName("script"),
                    t = e[e.length - 1],
                    n = document.createElement("script");
                function r() {
                    var e = crCryptocoinPriceWidget.init({
                        base: "USD,EUR,IQD,EGP",
                        items: "PRQ,BTC,ETH,XRP,LTC,MCONTENT,BNB,ADA,SOL,AVAX,LUNA,DOT,DOGE,SHIB,CROATOM,LINK,TRX,NEAR,BCH,XLM,FTM,UNI,HBAR,MANA,GLQ,SAND,ICP,CELR,VET,XMR,GRT,HNT,CAKE,ONE,ENJ,KSM,BAT,MINA,ZIL,KEEP",
                        backgroundColor: "E0E0D9",
                        streaming: "1",
                        rounded: "1",
                        boxShadow: "9",
                        border: "5",
                    });
                    t.parentNode.insertBefore(e, t);
                }
                (n.src = "https://co-in.io/widget/pricelist.js?items=BTC%2CETH%2CLTC%2CXMR%2CDASH"),
                    (n.async = !0),
                    n.readyState
                        ? (n.onreadystatechange = function () {
                              ("loaded" != n.readyState && "complete" != n.readyState) || ((n.onreadystatechange = null), r());
                          })
                        : (n.onload = function () {
                              r();
                          }),
                    t.parentNode.insertBefore(n, null);
            })();
        </script>
        <p>
            <a href="#top">
                <strong><h1 style="margin: 0%; text-align: center;">🔝</h1></strong>
            </a>
        </p>
        <h2>&nbsp;</h2>
    </body>
</html>
