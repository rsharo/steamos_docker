# steamos_docker
Builds a SteamOS docker image directly from Valve repositories. *(for the paranoid.)*

All binaries are pulled from http://repo.steampowered.com/steamos using gpg keys from `hkp://ha.pool.sks-keyservers.net:80`.


The filesystem build runs as root using the official `debian:jessie` base image.  The image is built by running `mkimage.sh`, but with final installation disabled.  Once the SteamOS file tree is built, it is pulled from the container and installed onto the host with `docker build`.

Run "make" to:
  1. Create a build machine based on Debian Jessie
  2. Load all dependencies to build a SteamOS image
  3. Run the build machine, producing a SteamOS root file system in ./output/
  4. Build "steamos" image on host


Currently configured for SteamOS `brewmaster`.
