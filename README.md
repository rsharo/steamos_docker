# steamos_docker
Builds a [SteamOS](http://store.steampowered.com/steamos/) [docker](https://www.docker.com/) image directly from Valve repositories. *(for the paranoid.)*

> **[TL;DR]**  Run `make && make distclean` as root. You'll end up with a docker image named `steamos:latest`.  Use it as a base image or run `docker run -ti --name steamos steamos` to experiment with it.  You must have docker installed first, of course.


All binaries are pulled from http://repo.steampowered.com/steamos using gpg keys from `hkp://ha.pool.sks-keyservers.net:80`.


The filesystem build runs as root using the official `debian:jessie` base image.  The image is built by running `mkimage.sh`, but with final installation disabled.  Once the SteamOS file tree is built, it is pulled from the container and installed onto the host with `docker build`.

Run "make" (as root) to:
  1. Create a build machine based on `debian:jessie`, called `steamos_buildmach`
  2. Load all dependencies needed to build a SteamOS image
  3. Run the `steamos_buildmach` producing a SteamOS root file system in the `./output/` directory
  4. Build "steamos" image on host

`make` Target | Description
--------------|--------
all | equivalent to "steamos" target
steamos | builds the `steamos` image (plus build dependencies)
steamos_buildmach | builds `steamos_buildmach`: the debian machine that can build steamos images
clean | Removes any pre-existing `steamos_buildmach` container.  Equivalent to `docker rm -f steamos_buildmach`
distclean | Removes `steamos_buildmach` container, image, and volumes. Does not touch `steamos`.
delete-steamos | Removes `steamos` container and image.  *Use at your own risk!*

Currently configured to build SteamOS `brewmaster`.

To build `alchemist`, type the following *(NOTE: not tested!)*:
```
make steamos_buildmach
docker run -ti --privileged --name steamos_buildmach -v <your_volume>:/root/steamos steamos_buildmach -d steamos -t steamos debootstrap --variant=minbase alchemist http://repo.steampowered.com/steamos ./brewmaster
cp Dockerfile.steamos <your_volume>/Dockerfile
docker build -t alchemist <your_volume>
```
> That last `./brewmaster` is not a typo.  That same script will work for `alchemist`.
