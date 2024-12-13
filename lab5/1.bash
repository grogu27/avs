#!/bin/bash

if [ $1 == start ]
then
	minikube start
	minikube addons enable ingress
	kubectl apply -f deployment.yaml
	kubectl apply -f service.yaml
	kubectl apply -f ingress.yaml
fi

if [ $1 == status ]
then
	kubectl get deployments
	kubectl get replicasets
	kubectl get pods
fi

if [ $1 == ping ]
then
	curl http://nginx.local | grep "<h1>Welcome to nginx!</h1>"
fi

if [ $1 == stop ]
then
	kubectl delete all --all
	minikube stop
fi