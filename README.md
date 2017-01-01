# steamos_docker
Builds a SteamOS docker image directly from Valve repositories.

All binaries are pulled from http://repo.steampowered.com/steamos using gpg keys from `hkp://ha.pool.sks-keyservers.net:80`
SteamOS is built by running `debooststrap` from the official `debian:jessie` base image.

Run "make" to:
  1. Create a build machine based on Debian Jessie
  2. Load all dependencies to build a SteamOS image
  3. Run the build machine, producing a SteamOS root file system in ./output/
  4. Build "steamos" image on host


Currently configured for Brewmaster.
