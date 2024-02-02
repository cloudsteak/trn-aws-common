
# AWS Cloud tudástár
AWS Általános segédletek

## Tartalomjegyzék

- [Hasznos linkek](#hasznos-linkek) 
- [AWS Cli](#aws-cli)
- [Virtuális gépek (Compute)](#virtuális-gépek-compute)
- [Hálózat (Networking)](#hálózat-networking)
- [Kiszolgáló nélküli megoldások (Serverless)](#kiszolgáló-nélküli-megoldások-serverless)
- [Tárolás és fájlok (Storage)](#tárolás-és-fájlok-storage)
- [Konténerek és Kubernetes (Docker & K8s)](#konténerek-és-kubernetes-docker--k8s)


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

Parancssoros eszköz az AWS kezeléséhez.

[AWS Cli](./cli.md)

## Virtuális gépek

Minden ami az AWS virtuálisgépek kapcsán hasznos lehet. EC2, Elastic Beanstalk.

[Virtuális gépek (Compute)](./ec2.md)


## Hálózat

VPC, Subnet, Route Table, Security Group, NACL, Internet Gateway, NAT Gateway, VPC Endpoint, VPC Peering, Site-to-Site VPN, Direct Connect és hasonlók.

[Hálózat (Networking)](./network.md)


## Kiszolgáló mentes megoldások

Lambda

[Kiszolgáló nélküli megoldások (Serverless)](./serverless.md)

## Tárolás és fájlok (Storage)

S3 tároló

[Tárolás és fájlok (Storage)](./storage.md)

## Konténerek és Kubernetes (Docker & K8s)

EKS cluster és ECR

[Konténerek és Kubernetes (Docker & K8s)](./containers.md)
