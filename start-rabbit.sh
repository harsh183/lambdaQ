#!/usr/bin/env bash

docker run \
    -d \
    --hostname my-rabbit \
    --name some-rabbit \
    -p 5672:5672 \
    -p 15671:15671 \
    -p 15672:15672 \
    -p 15674:15674 \
    -p 15670:15670 \
    -p 61613:61613 \
rabbitmq:3

