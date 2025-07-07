# Build image
```bash
docker build -t <image-name> <directory>
```

# Run container
```bash
docker run -d -p <host-port>:<container-port> <image-name>
```

# Run container with volume
```bash
docker run -d -p <host-port>:<container-port> -v <host-path>:<container-path>:<permission> <image-name>
```

# Run container with shell
```bash
docker run -it --rm <image-name>
```
