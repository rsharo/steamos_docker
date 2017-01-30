# steamos_docker
Builds a [SteamOS](http://store.steampowered.com/steamos/) [docker](https://www.docker.com/) image directly from Valve repositories. *(for the paranoid.)*

> **[TL;DR]  Requires Docker 1.13 or later.**  From an account with Docker privileges (e.g. root), run the following:
> ```
XUSER=<the user account you log into X with>
export STEAMUSER_UID=$(id -u ${XUSER})
export STEAMUSER_GID=$(id -g ${XUSER})
export STEAMUSER_HOME=$(grep "${XUSER}" /etc/passwd | cut -f6 -d:)
mkdir ${STEAMUSER_HOME}/steamhome && chown ${XUSER}:${XUSER} ${XUSER}/steamhome
make
util/steambox
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
distclean | Removes `steambox`, `buildmach`, and build artifacts.  Retains the baseimage.
steambox_ati | Builds `steambox_ati`: a derivative of `steambox` with support for ATI video cards.
steambox_nvidia | Builds `steambox_nvidia`: a derivative of `steambox` with support for NVIDIA video cards.


## Makefile Build Parameters

Parameter | Default | Description
----------|---------|-------------
STEAMUSER_UID | *none* | The user id of the *host* user running Steam.  Required for the `steambox` target only.
STEAMUSER_GID | *none* | The group id of the *host* user running Steam.  Required for the `steambox` target only.
STEAMUSER_HOME | *none* | The home directory of the *host* user running Steam.  Required for the `steambox` target only.
BASEIMAGE | `$(SUITE)` | Docker repository name for the final SteamOS base image
SUITE | brewmaster | SteamOS version to build
VARIANT | minbase | [debootstrap](https://wiki.debian.org/Debootstrap) variant of SteamOS to build
STEAMREPO | http://repo.steampowered.com/steamos | Where to get the SteamOS binaries
DOCKER | docker | The program used to control the docker daemon
DRIVERFILE | AMD-Catalyst-15.9-Linux-installer-15.201.1151-x86.x86_64.run | **ATI build only** The video driver installer (you must download it into `steambox_ati`)


## Running The Driver-Specific Builds
```
STEAMBOX=steambox_nvidia ./util/steambox
```
