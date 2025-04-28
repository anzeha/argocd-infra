#!/bin/bash

# Check for minimum required arguments
if [ "$#" -lt 4 ]; then
  echo "Usage: $0 <argocd-server-ip> <username> <password> <context1> [<context2> ... <contextN>]"
  exit 1
fi

ARGOCD_IP=$1
USERNAME=$2
PASSWORD=$3
shift 3
CONTEXTS=("$@")

# Set the GCP project
echo "Setting GCP project to 'floorball-fantasy'..."
gcloud config set project floorball-fantasy

if [ $? -ne 0 ]; then
  echo "Failed to set GCP project. Exiting."
  exit 1
fi

# Log into ArgoCD
echo "Logging into ArgoCD at $ARGOCD_IP..."
argocd login "$ARGOCD_IP" --username "$USERNAME" --password "$PASSWORD" --insecure

if [ $? -ne 0 ]; then
  echo "ArgoCD login failed. Please check your credentials or IP."
  exit 1
fi

# Add each cluster context
for context in "${CONTEXTS[@]}"; do
  echo "Adding cluster context: $context..."
  argocd cluster add "$context" --yes
  if [ $? -ne 0 ]; then
    echo "❌ Failed to add context: $context"
  else
    echo "✅ Successfully added: $context"
  fi
done

echo "✅ All clusters added to ArgoCD!"
