# whoami multi-arch image

[![Build status](https://ci.appveyor.com/api/projects/status/bhma7tmx0eje73ao/branch/main?svg=true)](https://ci.appveyor.com/project/StefanScherer/whoami/branch/main)
[![This image on DockerHub](https://img.shields.io/docker/pulls/stefanscherer/whoami.svg)](https://hub.docker.com/r/stefanscherer/whoami/)

Simple HTTP docker service that prints it's container ID - for (almost) any Docker platform

## CI pipeline

![CI pipeline with Travis and AppVeyor](images/pipeline.png)

* AppVeyor CI
  * Matrix build for several Linux architectures
    * linux/amd64
    * linux/arm
    * linux/arm64
  * Build Windows image for nanoserver 2016 SAC
    * windows/amd64 10.0.14393.x
    * Rebase this image to nanoserver:1709 SAC
      * windows/amd64 10.0.16299.x
    * Rebase this image to nanoserver:1803 SAC
      * windows/amd64 10.0.17134.x
    * Rebase this image to nanoserver:1809 SAC
      * windows/amd64 10.0.17763.x
    * Rebase this image to nanoserver:1903 SAC
      * windows/amd64 10.0.18362.x
  * Wait for all images to be on Docker Hub
  * Create and push the manifest list
    * preview of `docker manifest` command

## Linux

    $ docker run -d -p 8080:8080 --name whoami -t stefanscherer/whoami
    736ab83847bb12dddd8b09969433f3a02d64d5b0be48f7a5c59a594e3a6a3541

    $ curl http://localhost:8080
    I'm 736ab83847bb running on linux/amd64

    IP: 127.0.0.1
    IP: 172.17.0.2
    ENV: PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    ENV: HOSTNAME=8b5485ce34ff
    ENV: PORT=80
    ENV: HOME=/root
    GET / HTTP/1.1
    Host: localhost
    User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.87 Safari/537.36
    Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3
    Accept-Encoding: gzip, deflate, br
    Accept-Language: en-US,en;q=0.9,de;q=0.8
    Cache-Control: no-cache
    Connection: keep-alive
    Pragma: no-cache
    Sec-Fetch-Mode: navigate
    Sec-Fetch-Site: none
    Sec-Fetch-User: ?1
    Upgrade-Insecure-Requests: 1

## Windows

    $ docker run -d -p 8080:8080 --name whoami -t stefanscherer/whoami
    736ab83847bb12dddd8b09969433f3a02d64d5b0be48f7a5c59a594e3a6a3541

    $ (iwr http://$(docker inspect -f '{{ .NetworkSettings.Networks.nat.IPAddress }}' whoami):8080 -UseBasicParsing).Content
    I'm 736ab83847bb on windows/amd64

Used for a first
[swarm-mode demo](https://github.com/StefanScherer/docker-windows-box/tree/main/swarm-mode)
with Windows containers.

## Query all supported platforms

```
$ docker run --rm mplatform/mquery stefanscherer/whoami
Image: stefanscherer/whoami
 * Manifest List: Yes
 * Supported platforms:
   - linux/amd64
   - linux/arm/v6
   - linux/arm64/v8
   - windows/amd64:10.0.14393.2248
   - windows/amd64:10.0.16299.431
   - windows/amd64:10.0.17134.48
```

## Machine readable version
On the route /api the app will expose the same information as a json body

```
{"hostname":"8b5485ce34ff","platform":"linux/amd64","ip":["127.0.0.1","172.17.0.2"],"header":{"Accept":["text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3"],"Accept-Encoding":["gzip, deflate, br"],"Accept-Language":["en-US,en;q=0.9,de;q=0.8"],"Connection":["keep-alive"],"Sec-Fetch-Mode":["navigate"],"Sec-Fetch-Site":["none"],"Sec-Fetch-User":["?1"],"Upgrade-Insecure-Requests":["1"],"User-Agent":["Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.87 Safari/537.36"]},"env":["PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin","HOSTNAME=8b5485ce34ff","PORT=80","HOME=/root"]}
```
