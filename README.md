# qnimbus/youtube-dl <!-- omit in toc -->

![Linting](https://github.com/qnimbus/docker-youtube-dl/workflows/Linting/badge.svg?style=for-the-badge) ![Docker](https://github.com/qnimbus/docker-youtube-dl/workflows/Docker/badge.svg?style=for-the-badge) ![Publish Docker image](https://github.com/QNimbus/docker-youtube-dl/workflows/Publish%20Docker%20image/badge.svg?style=for-the-badge)

`yt-dl` - download videos from various online video platforms.

## Table of Contents <!-- omit in toc -->

- [Quick Start](#quick-start)
- [Environment variables](#environment-variables)
- [Shell access](#shell-access)
- [Configuration](#configuration)
  - [Configuration file](#configuration-file)
- [Support or Contact](#support-or-contact)
- [Test](#test)
- [Troubleshooting](#troubleshooting)

## Quick Start

**NOTE**: The docker command provided in this quick start is just an example. You will likely need to add additional parameters depending on how you would like to use `youtube-dl`.

It is suggested to configure an shell function as follows (and append to your `~/.profile` file):

```bash
function yt-dl() {
    docker run \
        --rm -it \
        --name youtube-dl \
        -e PGID=$(id -g) \
        -e PUID=$(id -u) \
        -v "$(pwd)"/downloads:/downloads:rw \
        qnimbus/youtube-dl $@
}
```

Or using `docker-compose`:

```bash
PGID=$(id -g) PUID=$(id -u) docker-compose run --rm youtube-dl
```

**HANDY HINT:** After updating your `~/.profile` file, run `source ~/.profile` to make your changes live! Alternatively you can logout of your shell and log back in.

When you run `youtube-dl` (e.g: `yt-dl <video_url>`) it will download the video file to the `./downloads` folder in your current working directory.

## Environment variables

| Environment variable | Default    | Possible values      | Description                                               |
| -------------------- | ---------- | -------------------- | --------------------------------------------------------- |
| `LOG`                | `yes`      | yes, no, true, false | Writes stderr and stdout to `/downloads/log` folder. |
| `PGID`               | `$(id -g)` | valid GID            | The group id (GID) used to run the `youtube-dl` as.       |
| `PUID`               | `$(id -u)` | valid UID            | The user id (UID) used to run the `youtube-dl` as.        |

## Shell access

To get shell access to a running container execute the following command:

```bash
docker exec -ti [CONTAINER NAME] /bin/bash
```

Where `CONTAINER` is the name of the running container.

To start a fresh container with a shell (instead of `youtube-dl`) execute the following command:

```bash
docker run --rm -ti --entrypoint=/bin/bash qnimbus/youtube-dl
```

## Configuration

Visit the official [`youtube-dl`](https://github.com/ytdl-org/youtube-dl/blob/master/README.md) documentation for [command line and configuration](https://github.com/ytdl-org/youtube-dl/blob/master/README.md#options) options.

### Configuration file

To prevent having to specify many command line arguments every time you run `youtube-dl` you may wish to have an external configuation file. This configuration file needs to be exposed to the Docker container using a volume mount. In the example below the `youtube-dl.conf` file is assumed to reside in the present work directory (`pwd`). It is mount as a read-only file in the `youtube-dl` Docker container.

```bash
docker run \
        --rm -i \
        -e PGID=$(id -g) \
        -e PUID=$(id -u) \
        -v "$(pwd)"/downloads:/downloads:rw \
        -v "$(pwd)"/youtube-dl.conf:/etc/youtube-dl.conf:ro \
        qnimbus/youtube-dl
```

If you need help creating a `youtube-dl.conf` configuration file you can view the [official `youtube-dl` documentation](https://github.com/ytdl-org/youtube-dl/blob/master/README.md#configuration).

## Support or Contact

Having troubles with the container or have questions? Please [create a new issue](https://github.com/qnimbus/docker-youtube-dl/issues).

## Test

You can test the container by downloading a small sample video from Youtube like so:

```bash
docker run --rm -it -v ${PWD}/downloads:/downloads qnimbus/youtube-dl https://www.youtube.com/watch?v=EngW7tLk6R8
```

## Troubleshooting

When running the docker commands from a Windows Git Bash shell (MSYS) you may need to prepend the `MSYS_NO_PATHCONV=1` environment variable to the commands like so:

```bash
MSYS_NO_PATHCONV=1 docker run --rm -it -v ${PWD}/downloads:/downloads qnimbus/youtube-dl --version
```
