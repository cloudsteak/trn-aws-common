# Kiszolgáló nélküli megoldások (Serverless)

## Lambda

Egy alap demó Lamda kapcsán.

1.  Nyissuk meg az Lambda dashboard-ot: https://eu-central-1.console.aws.amazon.com/lambda/home
2.  `Create a function` gomb
3.  Válasszuk a `Use a blueprint` lehetőséget, hiszen egy már előre megírt alapot szeretnánkl csupán létrehozni.
4.  Blueprint name: `Getting started with Lambda HTTP`
5.  Function name: `Lambda-Web`
6.  Lap alján pipáljuk be a `Acknowledgment` jelölőnégyzetet
7.  Kattintsunk a `Create function` gombra és elindul a Lambda alkalmazásunk létrehozása
8.  Pár másodperc és el is készül
9.  Görgessünk lejjebb és keressük meg a `Function URL` feliratot, majd nyissuk meg az ott található linket
10. Menjümnk vissza az AWS konzolra és keressük meg a `Code source` részt
11. Duplán kattintsunka az `index.html` fájlra.
12. Cseréljük ki a fájl tartalmát erre:

```html
<html>
  <head>
    <style>
      body {
        font-family: Verdana, Geneva, Tahoma, sans-serif;
        background-image: url("https://github.com/cloudsteak/azurestaticwebsite/blob/main/assets/images/laptop-gf2f68ed68_1920.jpg?raw=true");
        background-repeat: no-repeat;
        background-size: cover;
        background-position: center;
        color: whitesmoke;
      }
    </style>
  </head>
  <body>
    <h1>AWS Lambda</h1>
  </body>
</html>
```

13. Kattintsunk a `Deploy` gombra, majd frissítsük a böngésző lapot amit a 9-es lépésben nyitottunk.

Habár nem kódoltunk semmit, egy rövid példa volt arra, hogy akár weboldalnak is megfelelő a Lambda

## Amazon Lightsail

### WordPress létrehozás

Hozzunk gyorsan létre egy WordPress oldalt.

1. Nyissuk meg a Lightsail oldalát: https://lightsail.aws.amazon.com/ls/webapp/home
2. Hozzunk létre egy szolgáltatást a `Create instance` gombra kattintva
3. Válasszuk ki a régót, a platformot (linux)
4. Select Blueprint: `WordPress`
5. Válasszuk ki. a megfelelő erőforrás méretet a `Choose your instance plan` részben.
6. Identify your instance: `AWS-WP-01`
7. `Create instance` gombra kattintva elindul a WordPress alkalmazásunk létrehozása

1-2 perc múlva már működik is az weboldalunk. :-)

A bejelentkezéshez szükség lesz pár extra lépésre!

### WordPress használatának megkezdése

Hivatalos segítlet, hogyan lehet bejelentkezni a WordPress-re: https://lightsail.aws.amazon.com/ls/docs/en_us/articles/amazon-lightsail-quick-start-guide-wordpress

1. A létrehozott `AWS-WP-01` WordPressnél kattintsunk a 3 pöttyre (menü)
2. Válasszuk a `Manage` lehetőséget
3. Görgessünk le és keressük meg az IPv4-es címet a `CONNECT TO` felirat alatt
4. Másoljuk ki és nyissunk egy új böngésző lapot
5. Írjuk be a böngésző címsorába az alábbit: `http://<public-ip-address>/wp-admin/` (pl.: http://3.70.201.72/wp-admin)
6. A WordPress oldalunk megnyílt.
7. Menjünk vissza a `Lightsail`-re és az `AWS-WP-01`-re
8. Keressük meg a narancssárga `Connect using SSH` gombot és kattintsunk rá.
9. A felugró ablakba (fekete háttér, parancssor) illesszük be majd futtassuk le az alábbi parancsot: `cat bitnami_application_password`
10. A megjelenő jelszót másoljuk ki
11. menjünk vissza a WordPress oldalunkhoz
12. Username: `user`
13. Password pedig az amit kimásoltunk a parancssorból
14. `Log In` gombra kattintve beléptünk a WordPress oldalunkra és el is kezdhetjük használni
