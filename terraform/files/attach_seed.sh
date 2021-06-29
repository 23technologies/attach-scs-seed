#!/usr/bin/env bash

# Create token on gardener-apiserver
kubectl apply -f token.yaml --kubeconfig gardener-apiserver.yaml
# Create cloudprofile on gardener-apiserver
kubectl apply -f cpfl.yaml --kubeconfig gardener-apiserver.yaml
# Create cloudsecret on gardener-apiserver
kubectl apply -f cloud-secret.yaml --kubeconfig gardener-apiserver.yaml
git clone https://github.com/gardener/gardener
kubectl create namespace garden --kubeconfig seed.yaml
helm install gardenlet gardener/charts/gardener/gardenlet --namespace garden -f gardenlet-values.yaml --wait --kubeconfig seed.yaml

