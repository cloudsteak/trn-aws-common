
# AWS Cloud tudástár
AWS Általános segédletek

## Tartalomjegyzék

- [Hasznos linkek](#hasznos-linkek) 
- [AWS Cli](#aws-cli)
- [Virtuálisgépek](#virtual-machines)
- [Hálózat](#network)
- [Kiszolgáló mentes megoldások](#serverless)
- [Tárolás és fájlok](#storage)
- [Docker & K8s](#docker--k8s)


## Hasznos linkek

- Szótár: https://cloudsteak-gmk-shared.s3.eu-central-1.amazonaws.com/all-cloud-glossary.png 
- AWS szójegyzék: https://docs.aws.amazon.com/general/latest/gr/glos-chap.html 
- Felhők összehasonlítása: https://lucid.app/lucidchart/13fde51a-271f-456a-b2b3-ef6869f9ee6a/view?page=GiFLkXTb1E1J
- Ár kalkulátor: https://calculator.aws 
- Reserved instances árak összehasonlítása: https://instances.vantage.sh  
- Szolgáltatás korlátok: https://docs.aws.amazon.com/general/latest/gr/aws_service_limits.html 
- AWS dokumentáció: https://aws.amazon.com
- AWS CLI: https://aws.amazon.com/cli/
- Elastic Beanstalk CLI: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html
- EKS CTL: https://eksctl.io


## AWS Cli
**Parancssoros eszköz az AWS kezeléséhez.**

Parancssoros eszköz az AWS kezeléséhez.

[AWS Cli](./cli.md)

## Virtual Machines
**Virtuális gépek**

Minden ami az AWS virtuálisgépek kapcsán hasznos lehet. EC2, Elastic Beanstalk.

[Virtuális gépek (Compute)](./ec2.md)


## Network
**Hálózat**


VPC, Subnet, Route Table, Security Group, NACL, Internet Gateway, NAT Gateway, VPC Endpoint, VPC Peering, Site-to-Site VPN, Direct Connect és hasonlók.

[Hálózat (Networking)](./network.md)


## Serverless
**Kiszolgáló mentes megoldások**

Lambda

[Kiszolgáló nélküli megoldások (Serverless)](./serverless.md)

## Storage
**Tárolás és fájlok**

S3 tároló

[Tárolás és fájlok (Storage)](./storage.md)

## Docker & K8s
**Konténerek és Kubernetes**

EKS cluster és ECR

[Konténerek és Kubernetes (Docker & K8s)](./containers.md)
