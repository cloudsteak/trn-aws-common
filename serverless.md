# Kiszolgáló nélküli megoldások (Serverless)

## Lambda

### Webalkalmazás BluePrint alapon

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


## Eseményvezéretl alkalmazás (S3 - Lambda - SNS)

Ebben a megoldásban egy fájl feltöltésekor egy Lambda függvény fut le, ami egy SNS témára küld egy üzenetet. Ez egy alapvető felhasználása lehet a Lambda-nak. Ráadásul olyan felhasználási esetet szemléltet, amikor a Lambda függvényeket eseményvezérelt módon használjuk.

*** 1. S3 tároló létrehozása ***

1. Nyissuk meg az S3 felületét: https://s3.console.aws.amazon.com/s3/home
2. Kattintsunk a `Create bucket` gombra
3. Adjunk nevet a tárolónak: `esemenyvezetett-feltoltes`
4. Kattintsunk a `Create bucket` gombra

*** 2. SNS témája létrehozása ***

1. Nyissuk meg az SNS felületét: https://eu-central-1.console.aws.amazon.com/sns/v3/home
2. Kattintsunk a `Create topic` gombra
3. Adjunk meg a fonrtos adatokat
    - Name: `esemenyvezetett-feltoltes`
    - Display name: `Eseményvezérelt fájlfeltöltés`
    - Type: `Standard`
4. Kattintsunk a `Create topic` gombra
5. A témánál kattintsunk a `Create subscription` gombra
6. Válasszuk ki a `Email` lehetőséget a Protocol legördülő menüből
7. Adjuk meg az email címünket
8. Kattintsunk a `Create subscription` gombra
9. A megadott email címre érkezett egy megerősítő email, amit ki kell nyitni és a benne található linkre kattintani
10. A felugró ablakban kattintsunk a `Confirm subscription` gombra
11. `Subscription confirmed!`. Ezzel érvényesítettük a feliratkozást a témára.


*** 3. Lambda függvény létrehozása ***

1. Nyissuk meg az Lambda dashboard-ot: https://eu-central-1.console.aws.amazon.com/lambda/home
2. `Create a function` gomb
3. Válasszuk a `Author from scratch` lehetőséget
4. Function name: `EsemenyvezereltFeltoltes`
5. Runtime: `Python 3.x`
6. Kattintsunk a `Create function` gombra
7. A megjelenő oldalon a `Function code` részben írjuk át a kódot erre:

```python
import json

def lambda_handler(event, context):
    print("Lamba függvény vagyok!")
```

8. Kattintsunk a `Deploy` gombra, majd a `Test` gombra
9. Válasszuk a `Monitor` fület és kattintsunk a `View CloudWatch logs` gombra
10. A megnyíló ablakban kattintsunk a Log stream nevére. Itt láthatjuk a függvényünk logjait.

```bash
...
2024-....	Lamba függvény vagyok!
...
```

*** 4. Lambda és S3 összekapcsolása ***

1. Menjünk vissza az Lambda függvényünkhöz
2. A `Designer` részben kattintsunk a `Add trigger` gombra
3. Trigger configuration:
    - Trigger: `S3`
    - Bucket: `esemenyvezetett-feltoltes`
    - Event type: `PUT`
    - Prefix: ``
    - Suffix: ``
    - Enable trigger: `Yes`
4. Kattintsunk az `Add` gombra

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
