# Konténerek és Kubernetes (Docker & K8s)

## Kubernetes cluster (EKS) létrehozása EKSCTL-el

### EKSCTL Telepítése

https://github.com/weaveworks/eksctl


### Előfeltételek az EKS létrehozásához

Parancssorban bejelentkezve a megfeleő AWS fiókba


### Ceate EKS cluster

```bash
eksctl create cluster \
--name aws-eks-demo \
--version 1.26 \
--region eu-central-1 \
--nodegroup-name primary-nodes \
--node-type t3a.medium \
--nodes 1
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
kubectl create namespace best-new-tracks
```

2. Létrehozzuk az alkalmazást és a hozzá tartozó erőforrásokat EKS-en belül

```bash
kubectl apply -f https://raw.githubusercontent.com/cloudsteak/trn-aws-common/main/eks-bestnewtracks-deployment.yaml --namespace best-new-tracks
```

3. Ellenőrizzük az eredményt

```bash
kubectl -n best-new-tracks get deployment
kubectl -n best-new-tracks get svc 
```

4. Nézzük mit látunk a böngészőnkben

Másoljuk ki az `EXTERNAL-IP` értékét a. második parancs eredményéből. Majd másoljuk be egy új böngésző fülre az alábbi módon: `http://<EXTERNAL-IP>`


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
kubectl -n best-new-tracks get pods
```

### Skálázás

```bash
# Több POD manuálisan
kubectl -n best-new-tracks scale --replicas=5 deployment best-new-tracks

# Kevesebb POD manuálisan
kubectl -n best-new-tracks scale --replicas=1 deployment best-new-tracks
```
### Minden erőforrás egy névtéren belül

```bash
kubectl -n best-new-tracks get all
```

