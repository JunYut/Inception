# docker
## Build image
```bash
docker build -t <image-name> <directory>
```

## Run container
```bash
docker run -d -p <host-port>:<container-port> <image-name>
```

## Run container with volume
```bash
docker run -d -p <host-port>:<container-port> -v <host-path>:<container-path>:<permission> <image-name>
```

## Start container with a terminal and removes container when it exits
```bash
docker run -it --rm <image-name>
```

## Opens interactive shell in a running container
```bash
docker exec -it <container_name_or_id> sh
```

## Stop container
```bash
docker stop <container_name_or_id>
```

# docker compose
## Run containers
```bash
docker compose up
```

## Build and run containers
```bash
docker compose up --build
```
