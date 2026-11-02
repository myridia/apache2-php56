#!/bin/sh

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
IMAGE="myridia/apache2-php56:latest"
NAME="apache2-php56"

show_menu() {
  printf "%s\n" '  ┌─────┬────────────────────────────────────────────────────┐'
  printf "%s\n" '  │  ID │ Description                                        │'
  printf "%s\n" '  ├─────┼────────────────────────────────────────────────────┤'
  printf "%s\n" '  │  1  │ Build image (DOCKER_BUILDKIT=0)                    │'
  printf "%s\n" '  │  2  │ Run container (foreground)                         │'
  printf "%s\n" '  │  3  │ Run container (daemon)                             │'
  printf "%s\n" '  │  4  │ Status (image + container)                         │'
  printf "%s\n" '  │  5  │ Shell in container                                 │'
  printf "%s\n" '  │  6  │ Stop container                                     │'
  printf "%s\n" '  │  7  │ Remove container                                   │'
  printf "%s\n" '  │  8  │ Remove image                                       │'
  printf "%s\n" '  │  9  │ Push image                                         │'
  printf "%s\n" '  │  0  │ Exit                                               │'
  printf "%s\n" '  └─────┴────────────────────────────────────────────────────┘'
}

printf "\n  Apache2 PHP 5.6 — Task Runner\n\n"

while true; do
  show_menu

  printf "  Enter Task ID: "
  read task || exit 0

  if [ "$task" = "0" ]; then
    printf "  Goodbye!\n"
    exit 0

  elif [ "$task" = "1" ]; then
    printf "...Building %s\n" "$IMAGE"
    DOCKER_BUILDKIT=0 docker build -t "$IMAGE" "$SCRIPT_DIR"

  elif [ "$task" = "2" ]; then
    printf "...Running %s (foreground)\n" "$NAME"
    docker run --rm -p 80:80 -p 22:22 --name "$NAME" -it "$IMAGE"

  elif [ "$task" = "3" ]; then
    printf "...Running %s (daemon)\n" "$NAME"
    docker rm -f "$NAME" 2>/dev/null
    docker run -d -p 80:80 -p 22:22 --name "$NAME" "$IMAGE" && sleep 3
    docker ps --filter "name=^${NAME}$" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    printf "  Web:  http://127.0.0.1:80\n"
    printf "  SSH:  ssh -p 22 root@127.0.0.1\n"

  elif [ "$task" = "4" ]; then
    printf "...Image\n"
    docker images "$IMAGE" --format "table {{.Repository}}\t{{.Tag}}\t{{.ID}}\t{{.Size}}\t{{.CreatedSince}}"
    printf "...Container\n"
    if docker ps -a --format "{{.Names}}" | grep -q "^${NAME}$"; then
      docker ps -a --filter "name=^${NAME}$" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    else
      printf "  [missing]  %s\n" "$NAME"
    fi

  elif [ "$task" = "5" ]; then
    printf "...Shell in %s\n" "$NAME"
    docker exec -it "$NAME" bash

  elif [ "$task" = "6" ]; then
    printf "...Stopping %s\n" "$NAME"
    docker stop "$NAME"

  elif [ "$task" = "7" ]; then
    printf "...Removing container %s\n" "$NAME"
    docker rm -f "$NAME"

  elif [ "$task" = "8" ]; then
    printf "...Removing image %s\n" "$IMAGE"
    docker rmi "$IMAGE"

  elif [ "$task" = "9" ]; then
    printf "...Pushing %s\n" "$IMAGE"
    docker push "$IMAGE"

  else
    printf "  Unknown task: %s\n" "$task"
  fi

  sleep 2
  printf "\n"
done
