#!/bin/sh

SHOULD_CONTINUE_LOOP=true

while [ "$SHOULD_CONTINUE_LOOP" = "true" ]; do
  if docker system info > /dev/null 2>&1 ; then
    echo "Docker daemon is running. Breaking the loop"
    SHOULD_CONTINUE_LOOP=false
    break
  fi

  echo "Waiting for Docker daemon finishing starting"
  sleep 5
done

echo "Setting the qemu-user-static"
docker run --rm --privileged multiarch/qemu-user-static:register
echo "Done"
