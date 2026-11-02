# AGENTS.md — apache2-php56

## What this is
Docker image with Debian Trixie, Apache, and PHP 5.6, preconfigured with common PHP extensions, composer, and supervisor for running both SSH and Apache.

## Stack
- Debian trixie
- Apache2
- PHP 5.6 (surys package)
- Supervisor (supervisord)
- Composer

## Build
```bash
./ask.sh   # task 1: DOCKER_BUILDKIT=0 docker build -t myridia/apache2-php56:latest .
```

## Run
```bash
./ask.sh   # task 2: foreground, task 3: daemon
```

## Structure
- `Dockerfile` — image definition
- `supervisord.conf` — supervisor config (Apache + SSH)
- `ask.sh` — task runner (build/run/status/shell/cleanup/push)
- `remove_all_dockers.sh` — cleanup helper

## Conventions
- No comments in code unless asked.
- Verify: `docker build .`