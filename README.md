# steamos_docker
Builds a [SteamOS](http://store.steampowered.com/steamos/) [docker](https://www.docker.com/) image directly from Valve repositories. *(for the paranoid.)*

> **[TL;DR]**  Run `make && make distclean` as root. You'll end up with a docker image named `steamos:latest`.  Use it as a base image or run `docker run -ti --name steamos steamos` to experiment with it.  You must have docker installed first, of course.


Currently configured to build SteamOS `brewmaster`.  Other suites are untested.


All binaries are pulled from http://repo.steampowered.com/steamos using gpg keys from `hkp://ha.pool.sks-keyservers.net:80`.


The filesystem build runs as root inside a container built from the official `debian:jessie` base image.  Once the SteamOS file tree is built, it is pulled from the container and installed onto the Docker host with `docker build`.

Run "make" (as root) to:
  1. Create a build machine based on `debian:jessie`, called `steamos_buildmach`
  2. Load all dependencies needed to build a SteamOS image
  3. Run the `steamos_buildmach` producing a SteamOS root file system in the `./build/` directory
  4. Build `steamos` image on host

## Makefile Targets

Target | Description
--------------|--------
all | equivalent to "steamos" target
steamos | Builds the `steamos` image (plus build dependencies)
steamos_buildmach | Builds `steamos_buildmach`: the Debian machine that can build `steamos` images.
clean | Removes any pre-existing `steamos_buildmach` container.  Equivalent to `docker rm -f steamos_buildmach`
distclean | Removes `steamos_buildmach` container and image. Does not touch any `steamos` images.
delete-steamos | Removes the `steamos` container and image specified by `NAME`.  *Use at your own risk!*

## Makefile Build Parameters

Parameter | Default | Description
-----------------------|---------|-------------
NAME | brewmaster | Name of the final Docker image
SUITE | brewmaster | SteamOS version
VARIANT | minbase | [debootstrap](https://wiki.debian.org/Debootstrap) variant of SteamOS to build
STEAMREPO | http://repo.steampowered.com/steamos | Where to get the binaries

