# Kiszolgáló nélküli megoldások (Serverless)

## Lambda

Egy alap demó Lamda kapcsán.

1.  Nyissuk meg az Lambda dashboard-ot: https://eu-central-1.console.aws.amazon.com/lambda/home/begin
2. [Create a function](https://eu-central-1.console.aws.amazon.com/lambda/home/create/function?firstrun=true)
3. Válasszuk a `Use a blueprint` lehetőséget, hiszen egy már előre megírt alapot szeretnánkl csupán létrehozni.
4. Blueprint name: `Getting started with Lambda HTTP`
5. Function name: `Lambda-Web`
6. Lap alján pipáljuk be a `Acknowledgment` jelölőnégyzetet
7. Kattintsunk a `Create function` gombra és elindul a Lambda alkalmazásunk létrehozása
8. Pár másodperc és el is készül
9. Görgessünk lejjebb és keressük meg a `Function URL` feliratot, majd nyissuk meg az ott található linket
10. Menjümnk vissza az AWS konzolra és keressük meg a `Code source` részt
11. Duplán kattintsunka az `index.html` fájlra.
12. Cseréljük ki a fájl tartalmát erre:
```html
<html><head><style>body{font-family: Verdana, Geneva, Tahoma, sans-serif;background-image: url('https://github.com/cloudsteak/azurestaticwebsite/blob/main/assets/images/laptop-gf2f68ed68_1920.jpg?raw=true');background-repeat: no-repeat;background-size: cover; background-position: center;color: whitesmoke;}</style></head><body><h1>AWS Lambda</h1></body></html>
```
13. Kattintsunk a `Deploy` gombra, majd frissítsük a böngésző lapot amit a 9-es lépésben nyitottunk.

Habár nem kódoltunk semmit, egy rövid példa volt arra, hogy akár weboldalnak is megfelelő a Lambda