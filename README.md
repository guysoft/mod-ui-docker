mod-ui docker image
===================

mod-ui docker container lets you run on any machine that has jack an instance of the UI for the MOD software.
This is an LV2 linux plugin host. Attaching this plugin would let you control LV2 plugins from your browser.
The continer comes with sevral pre-compiled plugins, and you can add more and build them using your own image.


## Features
  * Runs mod-ui host out of the box
  * By default user information is saved on a volume ``mod-ui-data`` mapped to ``/home/moduser/mod-ui/data``
  
## Requirements
  * Running jack2 instance accisable from ``/dev/shm``

### Usage

1. Start jack on (example when user running jack 2 is user id 1000)
2. To run it:

    ```
    docker volume create --name=mod-ui-data
    docker run -p 8888:8888 --user=1000 -v /dev/snd:/dev/snd:rw -v /dev/shm:/dev/shm:rw -v mod-ui-data:/home/moduser/mod-ui/data guysoft/mod-ui
    ```
    
3. Connect to localhost:8888 to user mod-ui
    
### Docker Compose

There is an example file in the github repository, but you can also just paste this:

```yaml
version: '3.6'

services:
  mod-ui:
    container_name: mod-ui
    image: guysoft/mod-ui
    restart: always
    volumes:
      - /dev/snd:/dev/snd:rw
      - /dev/shm:/dev/shm:rw
      - type: volume
        source: mod-ui-data
        target: /home/moduser/mod-ui/data
    tty: true
    user: "1000"
    ports:
      - "8888:8888"
      
volumes:
  mod-ui-data:
    driver: local
    external:
      name: mod-ui-data

```

## Build your own container 

    FROM guysoft/mod-ui
    
    
LV2 plugin path: ``/home/moduser/mod-plugins/``
LV2 plugin sources: ``/home/moduser/mod-plugins/``

