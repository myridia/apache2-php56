# AGENTS.md — apache2-php56

## What this is
Docker image with Debian Bullseye, Apache, and PHP 5.6, preconfigured with common PHP extensions, composer, and supervisor for running both SSH and Apache.

## Stack
- Debian bullseye
- Apache2
- PHP 5.6 (surys package)
- Supervisor (supervisord)
- Composer

## Build
```bash
./build.sh   # docker build -t apache2-php56 .
```

## Run
```bash
docker run -p 80:80 -p 22:22 -it apache2-php56
```

## Structure
- `Dockerfile` — image definition
- `supervisord.conf` — supervisor config (Apache + SSH)
- `build.sh` — build helper
- `remove_all_dockers.sh` — cleanup helper

## Conventions
- No comments in code unless asked.
- Verify: `docker build .`