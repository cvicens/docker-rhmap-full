# RHMAP Docker image

## Clone this repo

```
$ git clone https://github.com/cvicens/docker-rhmap-full
```

## Create a directory to run your projects locally and copy your ssh keys
You'll mount a volume when you run the docker image and this 'projects' directory will be used in the container to allow persistence.

```
$ mkdir projects
```

Now copy your RHMAP ssh keys to ./projects

## Set up environment to name the image properly

```
export PROJECT_ID="rhmap-docker-full"
export IMAGE_NAME="rhmap-4.4"
export IMAGE_VERSION="v1.0"
export CONTAINER_NAME="rhmap-docker-dev"
```

## Build the image

```
docker build -t $PROJECT_ID/$IMAGE_NAME:$IMAGE_VERSION .
```

## Now let's run the image

As you can see below we're exposing port 8001 but you have to export the ports you need. Pay attention to the docker environment variables SSH_ID_RSA and SSH_ID_RSA_PUB, these variables should point to your ssh keys private and public repectively, bear in mind that because they are referred to the container filesystem they should point to /usr/projects. For instance if your key files are your_id_rsa and your_id_rsa.pub and you have copied to ./projects then inside the container the paths would be repectively /usr/projects/your_id_rsa and /usr/projects/your_id_rsa.pub

```
docker run -p=8001:8001 -it --rm -v $(pwd)/projects:/usr/projects -e SSH_ID_RSA='/usr/projects/your_id_rsa' -e SSH_ID_RSA_PUB='/usr/projects/your_id_rsa.pub' --name $CONTAINER_NAME $PROJECT_ID/$IMAGE_NAME:$IMAGE_VERSION /bin/bash
```

## Example: running a cloud app and a service locally
Running locally a Cloud App that in its turn call a service also running locally.

### Run the container exposing 8001

```
docker run -p=8001:8001 -it --rm -v $(pwd)/projects:/usr/projects --name $CONTAINER_NAME $PROJECT_ID/$IMAGE_NAME:$IMAGE_VERSION /bin/bash
```

### Running the service in background

Clone both repos and run ``npm install`` (Cloud App and Service) then change dir to the service folder and run.

```
$ nohup grunt serve &
```

Now move to the cloud app folder and run

```
$ grunt serve:local
```

Finally use Postman, for instance, to call you cloud app running on port 8001 on your localhost.

### Stop all and exit
Type Ctrl+C and exit
