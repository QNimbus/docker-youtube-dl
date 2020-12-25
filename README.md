# qnimbus/youtube-dl <!-- omit in toc -->

![Linting](https://github.com/qnimbus/docker-youtube-dl/workflows/Linting/badge.svg?style=for-the-badge&branch=latest) ![Docker](https://github.com/qnimbus/docker-youtube-dl/workflows/Docker/badge.svg?style=for-the-badge&branch=latest) ![Publish Docker image](https://github.com/QNimbus/docker-youtube-dl/workflows/Publish%20Docker%20image/badge.svg?style=for-the-badge)

`yt-dl` - download videos from various online video platforms.

## Table of Contents <!-- omit in toc -->

- [Quick Start](#quick-start)
- [Environment variables](#environment-variables)
- [Shell access](#shell-access)
- [Support or Contact](#support-or-contact)
- [Troubleshooting](#troubleshooting)

## Quick Start

**NOTE**: The docker command provided in this quick start is just an example. You will likely need to add additional parameters depending on how you would like to use `youtube-dl`.

It is suggested to configure an alias as follows (and place into your `.bash_aliases` file):

```bash
alias yt-dl='docker run \
              --rm -it \
              --name youtube-dl \
              -e PGID=$(id -g) \
              -e PUID=$(id -u) \
              -v "$(pwd)":/downloads:rw \
              qnimbus/youtube-dl
```

**HANDY HINT:** After updating your `.bash_aliases` file, run `source ~/.bash_aliases` to make your changes live!

When you run `youtube-dl` (e.g: `yt-dl <video_url>`) it will download the video file to your current working directory.

## Environment variables

| Environment variable | Default | Possible values      | Description                                               |
| -------------------- | ------- | -------------------- | --------------------------------------------------------- |
| `LOG`                | `yes`   | yes, no, true, false | Writes youtube-dl console output to `/downloads/log.txt`. |

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

## Support or Contact

Having troubles with the container or have questions? Please [create a new issue](https://github.com/qnimbus/docker-youtube-dl/issues).

## Troubleshooting

When running the docker commands from a Windows Git Bash shell (MSYS) you may need to prepend the `MSYS_NO_PATHCONV=1` environment variable to the commands, like so:

```bash
MSYS_NO_PATHCONV=1 docker run --rm -it -v ${PWD}/downloads:/downloads -e LOG=YES qnimbus/youtube-dl --version
```
