# Hálózat (Network)

## Tartalomjegyzék

- [VPC létrehozása](#vpc-l%C3%A9trehoz%C3%A1sa)
- [Subnet](#subnet)
- [Internet Gateway](#internet-gateway)
- [NAT Gateway](#nat-gateway)
- [VPC Peering](#vpc-peering)
- [Route Table](#route-table)
- [VPN (Virtual Private Network)](#vpn-virtual-private-network)
  - [A. Linux és MacOS](#a-linux-%C3%A9s-macos)
  - [B. Windows](#b-windows)
  - [AWS-Cli beállítása](#aws-cli-be%C3%A1ll%C3%ADt%C3%A1sa)
  - [Tanúsítvány importálás](#tan%C3%BAs%C3%ADtv%C3%A1ny-import%C3%A1l%C3%A1s)
  - [CloudWatch beállítás](#cloudwatch-be%C3%A1ll%C3%ADt%C3%A1s)
  - [Client VPN](#client-vpn)

## VPC létrehozása

Két VPC-t hozunk létre. Azért, hogy a VPC peerig működését is tudjuk gyakorolni.

### VPC 1

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateVpc:createMode=vpcOnly
2. VPC létrehozása
   - Name tag: VPC1
   - IPv4 CIDR block: 91.20.0.0/16
   - Tenancy: Default
3. Create VPC gombra kattintással létrehozzuk a VPC-t.

### VPC 2

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateVpc:createMode=vpcOnly
2. VPC létrehozása
   - Name tag: VPC2
   - IPv4 CIDR block: 50.10.0.0/16
   - Tenancy: Default
3. Create VPC gombra kattintással létrehozzuk a VPC-t.

## Subnet

### 1. VPC 1 publikus subnet (Subnet1)

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateSubnet
   - Name tag: VPC1-Subnet1-Public-Subnet
   - VPC: VPC1
   - Availability Zone: eu-central-1a
   - IPv4 subnet CIDR block: 91.20.30.0/24
2. Create subnet gombra kattintással létrehozzuk a subnet-et.

### 2. VPC 1 privát subnet (Subnet2)

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateSubnet
   - Name tag: VPN1-Subnet2-Private-Subnet
   - VPC: VPC1
   - Availability Zone: eu-central-1b
   - IPv4 subnet CIDR block: 91.20.40.0/24

### 3. VPC 2 private subnet (Subnet3)

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateSubnet
   - Name tag: VPC2-Subnet3-Private-Subnet
   - VPC: VPC2
   - Availability Zone: eu-central-1a
   - IPv4 subnet CIDR block: 50.10.50.0/24
2. Create subnet gombra kattintással létrehozzuk a subnet-et.

### 4. VPC 2 private subnet (Subnet4)

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateSubnet
   - Name tag: VPC2-Subnet4-Private-Subnet
   - VPC: VPC2
   - Availability Zone: eu-central-1b
   - IPv4 subnet CIDR block: 50.10.60.0/24
2. Create subnet gombra kattintással létrehozzuk a subnet-et.

## Internet Gateway

Internet Gateway-t csak a VPC1-hez csatoljuk.

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateInternetGateway:
   - Name tag: VPC1-Internet-Gateway
2. Create internet gateway gombra kattintással létrehozzuk az internet gateway-t.
3. Actions > Attach to VPC
   - VPC: VPC1
4. Attach gombra kattintással csatoljuk az internet gateway-t a VPC1-hez.

## NAT Gateway

NAT Gateway-t a VPC1-ben hozzuk létre, hogy majd a privát subnet-ek is tudjanak internetezni.

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateNatGateway:
   - Name tag: VPC1-NAT-Gateway
   - Subnet: VPC1-Subnet1-Public-Subnet
2. Allocate elastic IP address gombra kattintással létrehozzuk egy nyílvános IP címet rendelünk a NAT Gateway-hez.
3. Create NAT Gateway gombra kattintással létrehozzuk a NAT Gateway-t.
4. Várjunk kb 5 percet amíg létrejön a NAT Gateway.

## VPC Peering

A VPC-k között létrehozunk egy VPC Peering-et, hogy a két VPC között tudjunk kommunikálni.

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreatePeeringConnection:
   - Name: Peering-VPC1-VPC2
   - VPC ID (Requester): VPC1
   - VPC ID (Accepter): VPC2
2. Create peering connection gombra kattintással létrehozzuk a VPC Peering-et.
3. Actions > Accept request
4. Accept request gombra kattintással elfogadjuk a VPC Peering-et.

## Route Table

Route table feladata, hogy a forgalmat a megfelelő helyre irányítsa.

Nekünk kettő Route Table-re lesz szükségünk. Az egyik a publikus subnet-hez, a másik pedig a privát subnet-hez.

### 1. VPC1 publikus Route Table (RouteTable1)

Ez a Route table fogja irányítani a publikus subnet forgalmát. Többek között a privát subnet-ből érkező forgalmat is ez fogja az internet felé továbbítani.

**Route Table létrehozás**

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateRouteTable:
   - Name tag: VPC1-RouteTable1-Public-RouteTable
   - VPC: VPC1
2. Create route table gombra kattintással létrehozzuk a Route Table-t.

**Route szabályok hozzáadása**

1. Route table-n belül válasszuk a Routes fület.
2. Edit routes gombra kattintással szerkesztjük a Route szabályokat.
3. Add route gombra kattintással hozzáadjuk a következő szabályt:
   - Destination: 50.10.0.0/16
   - Target: pcx-xxxxxxxxxxxxxxxxx (Peering Connection)
4. Add route gombra kattintással hozzáadjuk a következő szabályt:
   - Destination: 0.0.0.0/0
   - Target: igw-xxxxxxxxxxxxxxxxx (Internet Gateway)
5. Save changess gombra kattintással elmentjük a Route szabályokat.

**Subnet hozzárendelése**

1. Route table-n belül válasszuk a Subnet associations fület.
2. Edit subnet associations gombra kattintással szerkesztjük a Subnet hozzárendeléseket.
3. Add subnet association gombra kattintással hozzáadjuk a következő subnet-eket:
   - VPC1-Subnet1-Public-Subnet
4. Save associations gombra kattintással elmentjük a Subnet hozzárendeléseket.

### 2. VPC1 privát Route Table (RouteTable2)

Ez a Route table fogja irányítani a privát subnet forgalmát. A privát subnet-ben lévő erőforrások forgalmát a publikus subnet-ben lévő NAT Gateway felé fogja irányítani.

**Route Table létrehozás**

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateRouteTable:
   - Name tag: VPC1-RouteTable2-Private-RouteTable
   - VPC: VPC1
2. Create route table gombra kattintással létrehozzuk a Route Table-t.

**Route szabályok hozzáadása**

1. Route table-n belül válasszuk a Routes fület.
2. Edit routes gombra kattintással szerkesztjük a Route szabályokat.
3. Add route gombra kattintással hozzáadjuk a következő szabályt:
   - Destination: 0.0.0.0/0
   - Target: nat-xxxxxxxxxxxxxxxxx (NAT Gateway)
4. Save changess gombra kattintással elmentjük a Route szabályokat.

**Subnet hozzárendelése**

1. Route table-n belül válasszuk a Subnet associations fület.
2. Edit subnet associations gombra kattintással szerkesztjük a Subnet hozzárendeléseket.
3. Add subnet association gombra kattintással hozzáadjuk a következő subnet-eket:
   - VPC1-Subnet2-Private-Subnet
4. Save associations gombra kattintással elmentjük a Subnet hozzárendeléseket.

### 3. VPC2 Route Table (RouteTable3)

Ez a Route table fogja irányítani a VPC 2 forgalmát a VPC 1 felé.

**Route Table létrehozás**

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateRouteTable:
   - Name tag: VPC2-RouteTable3-RouteTable
   - VPC: VPC2
2. Create route table gombra kattintással létrehozzuk a Route Table-t.

**Route szabályok hozzáadása**

1. Route table-n belül válasszuk a Routes fület.
2. Edit routes gombra kattintással szerkesztjük a Route szabályokat.
3. Add route gombra kattintással hozzáadjuk a következő szabályt:
   - Destination: 0.0.0.0/0
   - Target: pcx-xxxxxxxxxxxxxxxxx (Peering Connection)
4. Save changess gombra kattintással elmentjük a Route szabályokat.

**Subnet hozzárendelése**

1. Route table-n belül válasszuk a Subnet associations fület.
2. Edit subnet associations gombra kattintással szerkesztjük a Subnet hozzárendeléseket.
3. Add subnet association gombra kattintással hozzáadjuk a következő subnet-eket:
   - VPC2-Subnet3-Private-Subnet
   - VPC2-Subnet4-Private-Subnet
4. Save associations gombra kattintással elmentjük a Subnet hozzárendeléseket.

## Security Group

A Security Group-ok feladata, hogy a forgalmat szűrjék. Mindkét VPC-hez létrehozunk egy-egy Security Group-ot. A gyakorlás kedvéért minden forgalmat átengedünk. Ezt azonban éles környezetben nem szabad megtenni.

### 1. VPC1 Security Group (SecurityGroup1)

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateSecurityGroup:
   - Name tag: VPC1-SecurityGroup1
   - Description: VPC1-SecurityGroup1
   - VPC: VPC1
2. Add inbound rule gombra kattintással hozzáadjuk a következő szabályt:
   - Type: All traffic
   - Protocol: All
   - Port range: All
   - Source: Anywhere IPv4
3. Add outbound rule gombra kattintással hozzáadjuk a következő szabályt:
   - Type: All traffic
   - Protocol: All
   - Port range: All
   - Destination: Anywhere IPv4
4. Create security group gombra kattintással létrehozzuk a Security Group-ot.
5. Nyissuk meg a Security Groups fület: https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#SecurityGroups:
6. Válasszuk ki a VPC1-SecurityGroup1-et.
7. A Name tag oszlopban találakató ceruza ikonra kattintva szerkesszük a Security Group nevét: VPC1-SecurityGroup1

### 2. VPC2 Security Group (SecurityGroup2)

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateSecurityGroup:
   - Name tag: VPC2-SecurityGroup2
   - Description: VPC2-SecurityGroup2
   - VPC: VPC2
2. Add inbound rule gombra kattintással hozzáadjuk a következő szabályt:
   - Type: All traffic
   - Protocol: All
   - Port range: All
   - Source: Anywhere IPv4
3. Add outbound rule gombra kattintással hozzáadjuk a következő szabályt:
   - Type: All traffic
   - Protocol: All
   - Port range: All
   - Destination: Anywhere IPv4
4. Create security group gombra kattintással létrehozzuk a Security Group-ot.
5. Nyissuk meg a Security Groups fület: https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#SecurityGroups:
6. Válasszuk ki a VPC2-SecurityGroup2-et.
7. A Name tag oszlopban találakató ceruza ikonra kattintva szerkesszük a Security Group nevét: VPC2-SecurityGroup2

## Network Access Control List (NACL)

NACL feladata, hogy a forgalmat szűrje. Mindkét VPC-hez létrehozunk egy-egy NACL-t. A gyakorlás kedvéért minden forgalmat átengedünk. Ezt azonban éles környezetben nem szabad megtenni.

### 1. VPC1 NACL Public subnet (NACL1)

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateNetworkAcl:
   - Name tag: VPC1-Subnet1-NACL1
   - VPC: VPC1
2. Create network ACL gombra kattintással létrehozzuk a NACL-t.
3. Az Inbound Rules fülön kattintsunk az Edit inbound rules gombra.
4. Add new inbound rule gombra kattintással hozzáadjuk a következő szabályt:
   - Rule number: 300
   - Type: All traffic
   - Protocol: All
   - Port range: All
   - Source: 0.0.0.0/0
   - Allow/Deny: ALLOW
5. Save chnages gombra kattintással elmentjük a szabályokat.
6. Az Outbound Rules fülön kattintsunk az Edit outbound rules gombra.
7. Add new outbound rule gombra kattintással hozzáadjuk a következő szabályt:
   - Rule number: 300
   - Type: All traffic
   - Protocol: All
   - Port range: All
   - Destination: 0.0.0.0/0
   - Allow/Deny: ALLOW
8. Save chnages gombra kattintással elmentjük a szabályokat.
9. Subnet associations fülön kattintsunk az Edit subnet associations gombra.
10. Add subnet association gombra kattintással hozzáadjuk a következő subnet-eket:
    - VPC1-Subnet1-Public-Subnet
11. Save changes gombra kattintással elmentjük a subnet hozzárendeléseket.

### 2. VPC1 NACL Private subnet (NACL2)

Ezze lszűrjük a privát subnet forgalmát. Csak a szükséges portokat engedjük át. Ilyen pldául az SSH, HTTP, HTTPS, RDP, stb. Illetve engedélyezzük a magas portokat, hogy az internettel való kommunikáció zavartalan legyen.

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreateNetworkAcl:
   - Name tag: VPC1-Subnet2-NACL2
   - VPC: VPC1
2. Create network ACL gombra kattintással létrehozzuk a NACL-t.
3. Az Inbound Rules fülön kattintsunk az Edit inbound rules gombra.
4. Add new inbound rule gombra kattintással hozzáadjuk a következő szabályt:
   - Rule number: 300
   - Type: Custom TCP
   - Protocol: TCP (6)
   - Port range: 10000-65535
   - Source: 0.0.0.0/0
   - Allow/Deny: ALLOW
5. Add new inbound rule gombra kattintással hozzáadjuk a következő szabályt:
   - Rule number: 310
   - Type: SSH (22)
   - Protocol: TCP (6)
   - Port range: 22
   - Source: 91.20.30.0/24
   - Allow/Deny: ALLOW
6. Add new inbound rule gombra kattintással hozzáadjuk a következő szabályt:
   - Rule number: 320
   - Type: HTTP (80)
   - Protocol: TCP (6)
   - Port range: 80
   - Source: 91.20.30.0/24
   - Allow/Deny: ALLOW
7. Add new inbound rule gombra kattintással hozzáadjuk a következő szabályt:
   - Rule number: 330
   - Type: HTTPS (443)
   - Protocol: TCP (6)
   - Port range: 443
   - Source: 91.20.30.0/24
   - Allow/Deny: ALLOW
8. Add new inbound rule gombra kattintással hozzáadjuk a következő szabályt:
   - Rule number: 340
   - Type: RDP (3389)
   - Protocol: TCP (6)
   - Port range: All
   - Source: 91.20.30.0/24
   - Allow/Deny: ALLOW
9. Save chnages gombra kattintással elmentjük a szabályokat.
10. Az Outbound Rules fülön kattintsunk az Edit outbound rules gombra.
11. Add new outbound rule gombra kattintással hozzáadjuk a következő szabályt:
   - Rule number: 300
   - Type: All traffic
   - Protocol: All
   - Port range: All
   - Destination: 0.0.0.0/0
   - Allow/Deny: ALLOW
12. Save chnages gombra kattintással elmentjük a szabályokat.
13. Subnet associations fülön kattintsunk az Edit subnet associations gombra.
14. Add subnet association gombra kattintással hozzáadjuk a következő subnet-eket:
    - VPC1-Subnet2-Private-Subnet
15. Save changes gombra kattintással elmentjük a subnet hozzárendeléseket.

## VPN (Virtual Private Network)

### A. Linux és MacOS

```bash
chmod +x scripts/vpn_certificates.sh
```

```bash
./scripts/vpn_certificates.sh
```

- Adjunk meg egy mappa nevet a felhasználók mappájában, amiben létrejönnek majd a tanúsítvámnyok
- Tanúsítvány neve
- yes
- yes

### B. Windows

1. Nyiss egy powershell-t és futtasd le a következő parancsot:

```powershell
.\scripts\easyrsa_shell.ps1
```

2. Inítsd el EasyRSA-t a következő parancsokkal:

```powershell
.\EasyRSA-Start.bat
```

![EasyRSA-Start](./images/easyrsa-shell.png)

3. Miután megnyílik a shell, futtasd le a következő parancsokat a shell-ben:

3.1.

```bash
./easyrsa init-pki
```

3.2.

```bash
./easyrsa build-ca nopass
```

Megjegyzés: Add meg a felhasználóneved vagy a cég nevét. (ékezet nékül)

3.3.

```bash
./easyrsa build-server-full server nopass
```

Megjegyzés:

- phrase: `Üresen hagyható`
- Ha megkérdezi `yes`-el kell válaszolni a kérdésre.

  3.4.

```bash
./easyrsa build-client-full client1.domain.tld nopass
```

Megjegyzés: `yes`-el kell válaszolni a kérdésre.

3.5.

```bash
exit
```

4. Ezzel készen vannak a tanúsítványok. Most helyezzük át őket a saját Desktopunkra. Ehhez futtassuk le a következő parancsot a powershell-ben (easyrsa mappában):

```powershell
..\scripts\vpn_cert_copy.ps1
```

Megjegyzés: Bekéri a mappa nevét amit a Desktop-on szeretnénk létrehozni. Pl: `vpncert`

### AWS-Cli beállítása

AWS Cli telepítésének és beállításának lépéseit megtalálod [itt](./cli.md).

### Tanúsítvány importálás

1. Lépjünk be abba a mappába ahol a tanúsítványok vannak. Pl.: `Desktop\awscert`

2. Szerver tanúsítvány importálás

```bash
aws acm import-certificate --certificate fileb://server.crt --private-key fileb://server.key --certificate-chain fileb://ca.crt
```

Eredmény:

```json
{
  "CertificateArn": "arn:aws:acm:eu-central-1:xxxxxxxxxxxx:certificate/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
```

3. Kliens tanúsítvány importálás

```bash
aws acm import-certificate --certificate fileb://client1.domain.tld.crt --private-key fileb://client1.domain.tld.key --certificate-chain fileb://ca.crt
```

Eredmény:

```json
{
  "CertificateArn": "arn:aws:acm:eu-central-1:xxxxxxxxxxxx:certificate/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
```

### CloudWatch beállítás (Opcionális)

Csak akkor szükséges ha szeretnénk naplózni a VPN kapcsolatokat.

1. https://eu-central-1.console.aws.amazon.com/cloudwatch/home?region=eu-central-1
2. Logs > Log Groups > Create log group
3. Adatok:
   - Name: Point-To-Site-VPN
   - Retention setting: 1 week
   - Log class: Standard
4. Create
5. Válasszuk ki az új Log Group-ot (lépjünk bele)
6. Create log stream
7. Log stream name: VPN1

### Client VPN

https://eu-central-1.console.aws.amazon.com/vpc/home?region=eu-central-1#ClientVPNEndpoints:

1. Create client VPN endpoint

   - Name tag: point-to-site-vpn
   - Description: Point to Site VPN
   - Client IPv4 CIDR: 192.168.200.0/22
   - Server certificate ARN a Szerver tanúsítvány ARN-je (Server)
   - Use mutual authentication
   - Client certificate ARN a Kliens tanúsítvány ARN-je (client1.domain.tld)
   - Enable log details on client connections
   - CloudWatch logs log group name: Point-To-Site-VPN
   - CloudWatch logs log stream name: VPN1
   - Enable split-tunnel (Hogy ne minden forgalom menjen a VPN-en keresztül)
   - VPC ID: A VPC ahová szeretnénk hogx csatlakozzon a VPN
   - Security group IDs: Egyik biztonsági csoport ami a VPC-hez tartozik és amin keresztül szeretnénk hogy a VPN kapcsolatok menjenek.
   - Enable client login banner:

   ```
   Sikeres csatlakozás!

   Üdvözlünk az AWS VPN felhasználói között. :-)

   Üdv:
   CloudSteak
   ```

2. Create client VPN endpoint
3. Amint létrejött a kapcsolat állapota `Pending-associate`. Kattintsunk az azonosítójára (lépjünk bele)
4. Target network associations részben kattintsunk a `Associate target network`-re
5. Adjuk hozzá a VPC-t és a hozzá tartozó alhálózatot.
6. Várjunk kb 15 percet
7. Authorization rules fül: Add authorization rule

- Destination network to enable access: 91.20.0.0/16
- Allow access to all users

8. Add authorization rule
9. Várjunk pár percet
10. Download client configuration
11. Nyissuk meg szerkesztésre a letöltött fájlt (downloaded-client-config) és adjuk hozzá a Szerver és a Kliens tanúsítvány fájlok tartalmát az alábbiak szerint:

```bash
...
</ca>

<cert>
A kliens tanúsítvány tartalma (client1.domain.tld.crt).
</cert>

<key>
A Szerver tanúsítvány tartalma (client1.domain.tld.key).
</key>
...

reneg-sec 0

verify-x509-name server name
```

Pl:

```bash
client
dev tun
proto udp
remote cvpn-endpoint-0266eaa80b45fe8ad.prod.clientvpn.eu-central-1.amazonaws.com 443
remote-random-hostname
resolv-retry infinite
nobind
remote-cert-tls server
cipher AES-256-GCM
verb 3
<ca>
-----BEGIN CERTIFICATE-----
...
-----END CERTIFICATE-----

</ca>

<cert>
Certificate:
    Data:
        Version: 3 (0x2)
        ...
        Validity
            ...
        Subject: CN=client1.domain.tld
        Subject Public Key Info:
            Public Key Algorithm: rsaEncryption
                Public-Key: (2048 bit)
                Modulus:
                    ...
                Exponent: 65537 (0x10001)
        X509v3 extensions:
            X509v3 Basic Constraints:
                CA:FALSE
            X509v3 Subject Key Identifier:
                ...
            X509v3 Authority Key Identifier:
                ...
            X509v3 Extended Key Usage:
                TLS Web Client Authentication
            X509v3 Key Usage:
                Digital Signature
    Signature Algorithm: sha256WithRSAEncryption
    Signature Value:
        ...
-----BEGIN CERTIFICATE-----
...
-----END CERTIFICATE-----

</cert>

<key>
-----BEGIN PRIVATE KEY-----
...
-----END PRIVATE KEY-----
</key>

reneg-sec 0

verify-x509-name server name
```

12. Töltsük le a legújabb AWS VPN programot: [Minden Opeerációs rendszer](https://aws.amazon.com/vpn/client-vpn-download/)
    - [Windows](https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-connect-windows.html)
    - [MacOS](https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-connect-macos.html)
    - [Linux](https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-connect-linux.html)
13. Telepítsük fel és nyissuk meg
14. Hozzunk létre egy profilt a VPN-hez

![AWS VPN Profile](./images/aws-vpn-profile.png)

15. Adjunk egy nevet a profilnak és töltsük bele a fájlt

![AWS VPN Profile](./images/aws-vpn-profile-2.png)

16. Kapcsolódáshoz kattintsunk a Connect-re
17. Megjelenik az üdvözlő üzenetünk. Sikeresen csatlakoztunk.

![AWS VPN Profile](./images/aws-vpn-connect.png)
````
