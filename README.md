# argocd-infra

## Add clusters

```
gcloud config set account anzeha@floorball-fantasy.iam.gserviceaccount.com

gcloud config set project floorball-fantasy


gcloud container clusters get-credentials my-cluster --region europe-west1


./setup.sh <argocd-server-ip> <username> <password> <context1> [<context2> ... <contextN>]"

./setup.sh 34.141.172.102 admin admin gke_floorball-fantasy_europe-west4-a_ffantasy-gke-cluster-dev
```