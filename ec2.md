# EC2 instances (virtuális gépek)

Néhány hasznos parancs, vagy segédlet.

## Egyedi képfájl létrehozása CloudShell-ből: https://github.com/cloudsteak/cloud-custom-images

## Linux szerver web kiszolgálóként

1. Nyissuk meg az EC2 dashboard-ot: https://eu-central-1.console.aws.amazon.com/ec2/home
2. Kattintsunk a [`Lunch instance`](https://eu-central-1.console.aws.amazon.com/ec2/home#LaunchInstanceWizard:) gombra
3. Name: AWS-Web
4. Amazom Machine Image: Amazon Linux
5. Instance type: t2.micro
6. Key pair name: 
    - Ha van már létező kulcs párunk, akkor válasszuk azt
    - Ha még nincs, akkor kattintsunk a `Create new key pair` linkre
7. A `Network settings` részben pipáljuk be az `Allow HTTP traffic from internet` lehetőséget
8. `Advanced details` részt nyissuk le és görgessünk az oldal aljára
9. A `User data` mezőbe illeszkük bele az alábbi kódot:

```bash
#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
echo "<html><head><style>body{font-family: Verdana, Geneva, Tahoma, sans-serif;background-image: url('https://github.com/cloudsteak/azurestaticwebsite/blob/main/assets/images/laptop-gf2f68ed68_1920.jpg?raw=true');background-repeat: no-repeat;background-size: cover; background-position: center;color: whitesmoke;}</style></head><body><h1>Szerver neve: $(hostname -f)</h1>" > /var/www/html/index.html
```

10. Végül kattintsunk a `Launch instance` gombra

11. Pár másodperc múlva el is készül a gép. Ha az alábbi üzenetet látjuk, kattintsunk az `i-**********` linkre
```html
Success
Successfully initiated launch of instance (i-**********)
```

12. Várjuk meg, amíg a `Status check` mező értéke `2/2` értéket mutat
13. Kattintsunk a gép nevére (`AWS-Web`), majd a lap alján keressük meg a `Public IPv4 DNS` értékét. (`ec2-***-***-***-***.eu-central-1.compute.amazonaws.com`) Ezt másoljuk ki.
14. A kimásolt DNS nevet illeszük be egy új böngésző fülbe, az alábbi formátumban: `http://ec2-***-***-***-***.eu-central-1.compute.amazonaws.com`
15. Megnyílik a webszerverünk a szerver nevével.