# argocd-infra

## Add clusters

```
gcloud config set account anzeha@floorball-fantasy.iam.gserviceaccount.com

gcloud config set project floorball-fantasy


gcloud container clusters get-credentials my-cluster --region europe-west4-a


./setup.sh <argocd-server-ip> <username> <password> <context1> [<context2> ... <contextN>]"

./setup.sh 34.141.207.209 admin admin gke_floorball-fantasy_europe-west4-a_ffantasy-gke-cluster-dev
```