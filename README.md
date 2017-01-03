# steamos_docker
Builds a [SteamOS](http://store.steampowered.com/steamos/) [docker](https://www.docker.com/) image directly from Valve repositories. *(for the paranoid.)*

> **[TL;DR]**  From an account with Docker privileges (e.g. root), run the following:
> ```
export STEAMUSER_UID=$(id -u ${USER})
export STEAMUSER_GID=$(id -g ${USER})
export STEAMUSER_HOME=~${USER}
mkdir -p ~${USER}/steamhome && chown ${USER}:${USER} ${USER}/steamhome
util/steambox.sh
```
>
>You'll build and launch a docker image named `steambox`.  Type `steam` to run the steam launcher.
>
>*Note: still working to streamline this process*


Currently configured to build SteamOS `brewmaster`.  Other suites are untested.


All binaries are pulled from http://repo.steampowered.com/steamos using gpg keys from `hkp://ha.pool.sks-keyservers.net:80`.


The filesystem build runs as root inside a bootstrap container [FROM](https://docs.docker.com/engine/reference/builder/#/from) the official `debian:jessie` base image.  Once the SteamOS file tree is built, it is pulled from the container and installed onto the Docker host with `docker build`.

Run "make" (as root) to:
  1. Create a build machine based on `debian:jessie`, called `steamos_buildmach`
  2. Load all dependencies needed to bootstrap a SteamOS image
  3. Run a `steamos_buildmach` container, producing a SteamOS root file system
  4. Build a `$(SUITE)` SteamOS *(minbase)* base image, where `$(SUITE)` defaults to `brewmaster`
  4. Build `steambox` image that can actually run the steam launcher

## Makefile Targets

Target | Description
-------|--------
all | Equivalent to `steambox`
steambox | Builds the `steambox` image and all dependencies
baseimage | Builds the SteamOS minbase Docker base image
build-baseimage | Forcibly rebuilds `baseimage` even if you already have one
delete-baseimage | Deletes all `baseimage` containers and local repository images. *NOTE: asks for confirmation*
steamos_buildmach | Builds `steamos_buildmach`: a Debian image that can build SteamOS base images
debug-buildmach | Runs `steamos_buildmach` with bash tty.
clean | Equivalent to `docker rm -f steamos_buildmach steambox`.
distclean | Removes all containers, images, and build artifacts **including** `steambox`


## Makefile Build Parameters

Parameter | Default | Description
----------|---------|-------------
STEAMUSER_UID | *none* | The user id of the user that will be running Steam.  Required for the `steambox` target only.
STEAMUSER_GID | *none* | The group id of the user that will be running Steam.  Required for the `steambox` target only.
STEAMUSER_HOME | *none* | The home directory of the user that will be running Steam.  Required for the `steambox` target only.
BASEIMAGE | `$(SUITE)` | Name of the final SteamOS base image in your local repository
SUITE | brewmaster | SteamOS version to build
VARIANT | minbase | [debootstrap](https://wiki.debian.org/Debootstrap) variant of SteamOS to build
STEAMREPO | http://repo.steampowered.com/steamos | Where to get the SteamOS binaries

