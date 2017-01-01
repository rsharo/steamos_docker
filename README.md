# steamos_docker
Utilities to support running SteamOS in a docker container.

Run "make" to:
   1) Create a build machine based on Debian Jessie
   2) Load all dependencies to build a SteamOS image
   3) Run the build machine, producing a SteamOS root file system in ./output/
   4) Build "steamos" image on host


Currently configured for Brewmaster.
