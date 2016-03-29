# Docker Compose Configuration for GFB

First steps
-----------

You will need to clone in `..` gfb repos 

* Install [docker](docker.com) (probably
[boot2docker](https://docs.docker.com/installation/mac/))
* [docker-compose](https://docs.docker.com/compose/install/)

Run the thing
-------------

If you want to run everything:

    docker-compose up
    
If you want to run everything as deamonised:

    docker-compose up -d

If you just want part of the architecture:

    docker-compose up gfb # for example


BIG WARNINGS (please READ!)
---------------------------

- The projects are build with your local branch. This means that if you want
  last versions it's your responsability to update the code using `git`.
- If you can't start the app with `docker-compose up` because it says that
  there is a server already running, find and remove the respective pid files.
- Not all the environment variables are set, feel free to add the missing ones
  that you need.
