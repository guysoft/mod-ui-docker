mod-ui docker image
===================

### Usage

1. Start jack on (example when user running jack 2 is user id 1000)
2. To run it:

    ```
    docker run -p 8888:8888 --user=1000 -v /dev/snd:/dev/snd:rw -v /dev/shm:/dev/shm:rw guysoft/mod-
    ui
    ```

3. Connect to localhost:8888 to user mod-ui
    
### Docker Compose

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
    tty: true
    user: "1000"
    ports:
      - "8888:8888"

```
