## Zeoserver ready to run Docker image

Docker image for ZEO server with `plone.recipe.zeoserver` full support
(supports all plone.recipe.zeoserver options as docker environment variables).

This image is generic, thus you can obviously re-use it within
your non-related EEA projects.

### Supported tags and respective Dockerfile links

  -  `:latest` (default)


### Base docker image

 - [hub.docker.com](https://registry.hub.docker.com/u/eeacms/zeoserver)


### Source code

  - [github.com](http://github.com/eea/eea.docker.zeoserver)


### Installation

1. Install [Docker](https://www.docker.com/).


## Usage

Most of the configuration of this image is based on the 
[plone.recipe.zeoserver](https://pypi.python.org/pypi/plone.recipe.zeoserver)
recipe package so it is advised that you check it out.

### Run with basic configuration

    $ docker run eeacms/zeoserver:latest

The image is built using a bare `buildout.cfg` file:

    [buildout]
    extends = http://dist.plone.org/release/4.3.6/versions.cfg
    parts = zeoserver

    [versions]
    zc.buildout = 2.2.1
    setuptools = 7.0

    [zeoserver]
    recipe = plone.recipe.zeoserver

`zeoserver` will therefore run inside the container with the default parameters given
by the recipe, such as listening on `port 8100`.

### Extend configuration through environment variables

Environment variables can be supplied either via an `env_file` with the `--env-file` flag
    
    $ docker run --env-file zeoserver.env eeacms/zeoserver:latest

or via the `--env` flag

    $ docker run --env BUILDOUT_ZEO_ADDRESS="8080" eeacms/zeoserver:latest

It is **very important** to know that the environment variables supplied are translated
into buildout configuration. For each variable with the prefix `BUILDOUT_` there will be
a line added to the `[zeoserver]` configuration. For example, if you want to set the
`read-only` attribute to the value `true`, you have to supply an environment variable
in the form `BUILDOUT_READ_ONLY="true"`. When the environment variable is processed,
the prefix is striped, `_` turns to `-` and uppercase turns to lowercase. Also, if the
value is enclosed in quotes or apostrophes, they will be striped. The configuration will
look like

    [zeoserver]
    ...
    read-only = true
    ...

The variables supported are the ones supported by the [recipe](https://pypi.python.org/pypi/plone.recipe.zeoserver),
so check out its documentation for a full list. Keep in mind that this option will trigger
a rebuild at start and might cause a few seconds of delay.

### Use a custom configuration file mounted as a volume

    $ docker run -v /path/to/your/configuration/file:/opt/zeoserver/buildout.cfg eeacms/zeoserver:latest

You are able to start a container with your custom `buildout` configuration with the mention
that it must be mounted at `/opt/zeoserver/buildout.cfg` inside the container. Keep in mind
that this option will trigger a rebuild at start and might cause delay, based on your
configuration. It is unadvised to use this option to install many packages, because they will
have to be reinstalled every time a container is created.


### Extend the image with a custom configuration file

Additionaly, in case you need to considerably change the base configuration of this image,
you can extend it with your configuration. You can write Dockerfile like this

    FROM eeacms/zeoserver:latest
    # Add your configuration file
    COPY path/to/configuration/file /opt/zeoserver/base.cfg
    # Rebuild
    RUN /opt/zeoserver/bin/buildout /opt/zeoserver/base.cfg

and then run

   $ docker build -t your-image-name:your-image-tag path/to/Dockerfile


### Upgrade

    $ docker pull eeacms/zeoserver:latest


## Supported environment variables ##

As mentioned above, the supported environment variables are derived from the configuration options
from the [recipe](https://pypi.python.org/pypi/plone.recipe.zeoserver). For example, `read-only`
becomes `BUILDOUT_READ_ONLY` and `zeo-address` becomes `BUILDOUT_ZEO_ADDRESS`.

For variables that support a list of values (such as `eggs`, for example), separe them by space, as
in `BUILDOUT_EGGS="zc.async ZopeUndo"`.

Besides the variables supported by the `zeoserver` recipe, you can also use `INDEX` and `FIND_LINKS`
that extend the `[buildout]` tag.

## Copyright and license

The Initial Owner of the Original Code is European Environment Agency (EEA).
All Rights Reserved.

The Original Code is free software;
you can redistribute it and/or modify it under the terms of the GNU
General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later
version.


## Funding

[European Environment Agency (EU)](http://eea.europa.eu)
