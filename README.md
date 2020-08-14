# Getting Started
To run this Springboot sample app and deploy to the raspberry pi kubernetes cluster.

There's already an image for this demo in docker hub under this repo `aobakwe86/nedjiotdemo`, 
skip to [Kubernetes](#Kubernetes) if you don't want to create and push own image

# Prerequisites
The following must be installed in the machine

* At least Java 8
* Maven
* Docker
* Rasbpi k8s cluster set up as instructed

# Maven
* Package the app by running in project's root directory

    `mvn package`
# Docker

## Setup
To run in the PIs the image must be a `linux/arm/v7` image, need to enable 
[experimental features](https://github.com/docker/cli/blob/master/experimental/README.md) to build the images
outside the PIs. See instructions https://www.docker.com/blog/multi-arch-images/ 

## Build and push

* A Dockerfile is included in project root directory, in that directory run
     `docker buildx build --platform linux/arm/v7, <<other_platforms_if_required>> -t <<dockerhub_username>>/nedjiotdemo --push .`
# Kubernetes

## Create deployment
* Create a deployment.yaml file with contents like below, replace `aobakwe86/nedjiotdemo` if you built and pushed own image
```yaml
 apiVersion: apps/v1
 kind: Deployment
 metadata:
   name: demo
   labels:
     app: demo
 spec:
   replicas: 1
   selector:
     matchLabels:
       app: demo
   template:
     metadata:
       labels:
         app: demo
     spec:
       containers:
         - name: demo
           image: aobakwe86/nedjiotdemo
           ports:
             - containerPort: 8080
```

* In the terminal run: 

     `kubectl apply -f deployment.yaml`
     
* Might take a few minutes to pull image and create container but if everything went well after a few minutes
 when you run the following command the status of demo-**** should be Running

     `kubectl get pods`

## Create Service
To create service for pod
* Create service.yaml file with contents like below
```yaml
apiVersion: v1
kind: Service
metadata:
  name: demo-service
spec:
  type: NodePort
  selector:
    app: demo
  ports:
    - port: 8080
      targetPort: 8080
```
* In the terminal run: 
  
     `kubectl apply -f service.yaml`
* Then 
  
     `kubectl get services`
     
     Look for a line like this in output
     
     `demo-service                    NodePort    <<ClusterIP>>   <none>        8080:<<NodePort>>/TCP                <<AGE>>`
     
     The application should be available at `<<NodeIP>>:<<NodePort>>`

