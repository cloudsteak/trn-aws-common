# Konténerek és Kubernetes (Docker & K8s)

## App Runner

Az App Runner egy teljesen felügyelt szolgáltatás, amely lehetővé teszi a fejlesztők számára, hogy gyorsan és egyszerűen telepítsenek konténerizált webalkalmazásokat és API-kat anélkül, hogy kezelniük kellene az infrastruktúrát. Az App Runner automatikusan kezeli a skálázást, a terheléselosztást és a biztonsági frissítéseket, így a fejlesztők a kódjukra koncentrálhatnak.

### Példa alkalmazás

Az Amazon ECR Public Gallery-ból fogunk egy egyszerű alkalmazást telepíteni. Pl. Nginx webszerver vagy Apache

1. Nyissuk meg az App Runner kezelő felületét: https://eu-central-1.console.aws.amazon.com/apprunner/home
2. Kattintsunk a `Create an App Runner service` gombra
3. `Source` szekcióban válasszuk a `Container registry` lehetős
4. `Container registry` szekcióban válasszuk a `Public ECR image` lehetőséget
5. `Image identifier` mezőbe írjuk be a következőt: `public.ecr.aws/nginx/nginx:latest`
6. `Next` gomb
7. `Service name`: nginx-webszerver
8. `Instance configuration` szekcióban:
   - `vCPU`: 0.25
   - `Memory`: 0.5 GB
9. `Auto scaling` szekcióban hagyjuk az alapértelmezett értékeket
10. `Next` gomb
11. `Service settings` szekcióban hagyjuk az alapértelmezett értékeket
12. `Next` gomb
13. `Review` szekcióban ellenőrizzük az adatokat
14. `Create & deploy` gomb
15. Néhány perc múlva elkészül a szolgáltatásunk


## Kubernetes cluster (EKS) létrehozása EKSCTL-el

### EKSCTL Telepítése

https://github.com/weaveworks/eksctl

### Előfeltételek az EKS létrehozásához

Parancssorban bejelentkezve a megfeleő AWS fiókba

### Ceate EKS cluster

```bash
eksctl create cluster \
--name aws-eks-demo \
--version 1.27 \
--region eu-central-1 \
--nodegroup-name primary-nodes \
--node-type t3a.xlarge \
--nodes 2
```

Megjegyzés: Ez egy hosszú folyamat (kb. 15-20 perc)

### Kapcsolódás EKS-hez

```bash
# Helyi konfiguráció frissítése
aws eks --region eu-central-1 update-kubeconfig --name aws-eks-demo

# EKS node-ok lekérdezése
kubectl get nodes --kubeconfig ~/.kube/config
```

### ECR - konténer tároló létrehozás

Parancssorban futtasuk le a parancsot a megfeleő beálításokkal.

- Név: `docker-projekt`
- Régió: `eu-central-1`

```bash
aws ecr create-repository \
    --repository-name docker-projekt \
    --region eu-central-1
```

#### Policy, hogy az EKS hozzáférjen az ECR-hez

Jelenleg nem részletezem. :-)

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability"
      ],
      "Resource": "*"
    }
  ]
}
```

## Alkalmazás telepítése EKS-re

1. Létrehozunk egy névteret az EKS-en

```bash
kubectl create namespace node-demo
```

2. Létrehozzuk az alkalmazást és a hozzá tartozó erőforrásokat EKS-en belül

```bash
kubectl apply -f https://raw.githubusercontent.com/cloudsteak/trn-aws-common/main/eks-node-demo.yaml
```

3. Ellenőrizzük az eredményt

```bash
kubectl -n node-demo get deployment
kubectl -n node-demo get svc
```

4. Nézzük mit látunk a böngészőnkben

Másoljuk ki az `EXTERNAL-IP` értékét a. második parancs eredményéből. Majd másoljuk be egy új böngésző fülre az alábbi módon: `http://<EXTERNAL-IP>`

_Megjegyzés: Ha nem elérhető az alkalmazás, akkor keressük meg a `Cluster security group`-ot és adjuk hozzá azt a szabályt, ami beengedi a megfelelő portokat a `0.0.0.0/0` tartományból._

## Egyéb EKS

### Monitoring engedélyezése

Ha a következő hibaüzenetet kapjuk: `error: Metrics API not available`

```bash
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### Teljesítmény lekérdezések

```bash
# Node szerverek CPU és Memória használata
kubectl top nodes

# POD-ok CPU és Memória használata
kubectl top pods --all-namespaces
```

### POD-ok lekérdezése egy névtérből

```bash
kubectl -n node-demo get pods
```

### Skálázás

```bash
# Több POD manuálisan
kubectl -n node-demo scale --replicas=5 deployment node-demo

# Kevesebb POD manuálisan
kubectl -n node-demo scale --replicas=1 deployment node-demo
```

### Minden erőforrás egy névtéren belül

```bash
kubectl -n node-demo get all
```

### Névtér törlése (minden erőforrással együtt!)

```bash
kubectl delete ns node-demo
```

### EKS node szerverek skálázása

```bash
# Node group-ok lekérdezése
eksctl get nodegroup --cluster=aws-eks-demo
```

```bash
# Node-ok számának növelése
eksctl scale nodegroup --cluster=aws-eks-demo --nodes=3 --name=primary-nodes --nodes-min=1 --nodes-max=5 --wait
```

```bash
# Node-ok számának csökkentése
eksctl scale nodegroup --cluster=aws-eks-demo --nodes=1 --name=primary-nodes --nodes-min=1 --nodes-max=5 --wait
```

### EKS törlése

```bash
eksctl delete cluster --name aws-eks-demo
```


### Kubernetes Dashboard

1. Telepítés

```bash
export DASHBOARD_VERSION="v2.6.0"

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/${DASHBOARD_VERSION}/aio/deploy/recommended.yaml
```

2. Proxy

Külön parancssorban, mert futni fog

```bash
kubectl proxy --port=8080 --address=0.0.0.0 --disable-filter=true &
```

3. Dashboard kész

Böngészőben: http://localhost:8080/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

4. Token beszerzése az EKS-ről:

```bash
aws eks get-token --cluster-name aws-eks-demo | jq -r '.status.token'
```
