# Hálózat (Network)

## Tartalomjegyzék

- [VPC](#vpc)
  - [VPC létrehozása](#vpc-l%C3%A9trehoz%C3%A1sa)
  - [Subnet](#subnet)
  - [Route Table](#route-table)
  - [Internet Gateway](#internet-gateway)
  - [NAT Gateway](#nat-gateway)
  - [VPC Endpoint](#vpc-endpoint)
  - [VPC Peering](#vpc-peering)
- [VPN (Virtual Private Network)](#vpn-virtual-private-network)
  - [A. Linux és MacOS](#a-linux-%C3%A9s-macos)
  - [B. Windows](#b-windows)
  - [AWS-Cli beállítása](#aws-cli-be%C3%A1ll%C3%ADt%C3%A1sa)
  - [Tanúsítvány importálás](#tan%C3%BAs%C3%ADtv%C3%A1ny-import%C3%A1l%C3%A1s)
  - [CloudWatch beállítás](#cloudwatch-be%C3%A1ll%C3%ADt%C3%A1s)
  - [Client VPN](#client-vpn)

## VPC Peering

1. https://eu-central-1.console.aws.amazon.com/vpcconsole/home?region=eu-central-1#CreatePeeringConnection:
   - Name: Peering-VPC1-VPC2
   - VPC ID (Requester): VPC1
   - VPC ID (Accepter): VPC2
2. Create peering connection
3. Actions > Accept request

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

3. Miután megnyílik a shell, futtasd le a következő parancsokat a shell-ben:

3.1.

```bash
echo -e "./easyrsa init-pki"
./easyrsa init-pki
```

3.2.

```bash
echo -e "./easyrsa build-ca nopass"
./easyrsa build-ca nopass
```

Megjegyzés: Add meg a felhasználóneved vagy a cég nevét. (ékezet nékül)

3.3.

```bash
echo -e "./easyrsa build-server-full server nopass"
./easyrsa build-server-full server nopas
```

Megjegyzés:

- phrase: `Üresen hagyható`
- Ha megkérdezi `yes`-el kell válaszolni a kérdésre.

  3.4.

```bash
echo -e "./easyrsa build-client-full client1.domain.tld nopass"
./easyrsa build-client-full client1.domain.tld nopass
```

Megjegyzés: `yes`-el kell válaszolni a kérdésre.

3.5.

```bash
exit
```

4. Ezzel készen vannak a tanúsítványok. Most helyezzük át őket a saját Desktopunkra. Ehhez futtassuk le a következő parancsot a powershell-ben:

```powershell
.\scripts\vpn_cert_copy.ps1
```

Megjegyzés: Bekéri a mappa nevét amit a Desktop-on szeretnénk létrehozni. Pl: `vpncert`

### AWS-Cli beállítása

https://docs.aws.amazon.com/cli/latest/userguide/cli-authentication-user.html

```bash
aws configure
```

Adjuk meg a megfelelő adatokat. Ellenőrzés: `cat ~/.aws/credentials` és `cat ~/.aws/config`

### Tanúsítvány importálás

1. Lépjünk be abba a mappába ahol a tanúsítványok vannak

```bash
cd vpn_cert
```

2. Szerver tanúsítvány importálás

```bash
aws acm import-certificate --certificate fileb://server.crt --private-key fileb://server.key --certificate-chain fileb://ca.crt
```

3. Kliens tanúsítvány importálás

```bash
aws acm import-certificate --certificate fileb://client1.domain.tld.crt --private-key fileb://client1.domain.tld.key --certificate-chain fileb://ca.crt
```

### CloudWatch beállítás

1. https://eu-central-1.console.aws.amazon.com/cloudwatch/home?region=eu-central-1
2. Logs > Log Groups > Create log group
3. Adatok:
   - Name: /vpn/p2s
   - Retention setting: 1 week
   - Log class: Standard
4. Create
5. Válasszuk ki az új Log Group-ot (lépjünk bele)
6. Create log stream
7. Log stream name: VPN1

### Client VPN

https://eu-central-1.console.aws.amazon.com/vpc/home?region=eu-central-1#ClientVPNEndpoints:

1. Create client VPN endpoint
   - Name tag: p2s-vpn-01
   - Client IPv4 CIDR: 21.0.0.0/22
   - Server certificate ARN a Szerver tanúsítvány ARN-je (Server)
   - Use mutual authentication
   - Client certificate ARN a Kliens tanúsítvány ARN-je (client1.domain.tld)
   - Enable log details on client connections
   - CloudWatch logs log group name: /vpn/p2s
   - CloudWatch logs log stream name: VPN1
   - Enable split-tunnel
   - VPC ID: A VPC ahová szeretnénk hogx csatlakozzon a VPN
   - Enable client login banner:
   ```
   Sikeres csatlakozás! Üdvözlünk az AWS VPN felhasználói között. :-)
   ```
2. Create client VPN endpoint
3. Amint létrejött a kapcsolat állapota `Pending-associate`. Kattintsunk az azonosítójára (lépjünk bele)
4. Target network associations részben kattintsunk a `Associate target network`-re
5. Adjuk hozzá a VPC-nketr és a hozzá tartozó alhálózatot.
6. Várjunk kb 30 percet
7. Authorization rules fül: Add authorization rule
   - Destination network to enable access: 20.0.0.0/16
   - Allow access to all users
8. Add authorization rule
9. Várjunk pár percet
10. Download client configuration
11. Nyissuk meg szerkesztésre a letöltött fájlt és adjuk hozzá a Szerver és a Kliens tanúsítvány fájlok tartalmát az alábbiak szerint:

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

````

Pl:

```txt
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
````

12. Töltsük le a legújabb AWS VPN programot: [Minden Opeerációs rendszer](https://aws.amazon.com/vpn/client-vpn-download/)
    - [Windows](https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-connect-windows.html)
    - [MacOS](https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-connect-macos.html)
    - [Linux](https://docs.aws.amazon.com/vpn/latest/clientvpn-user/client-vpn-connect-linux.html)
13. Telepítsük fel és nyissuk meg
14. Töltsük bele a fájlt
15. Kapcsolódás.
16. Megjelenik az üdvözlő üzenetünk. Sikeresen csatlakoztunk.
