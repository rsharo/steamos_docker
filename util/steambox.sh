#!/bin/bash

# Launches the steambox image with direct connections to the specified
# user's X session, ALSA, and PulseAudio.

if [[ -n "${STEAMUSER_UID}" ]] ; then
	echo "$0: you must set the environment variable STEAMUSER_UID"
fi

if [[ -n "${STEAMUSER_HOME}" ]] ; then
	echo "$0: you must set the environment variable STEAMUSER_HOME"
fi

cat << EOF
WARNING: This script launches a steambox Docker container with
unrestricted access to your X session and audio drivers.

There are no provisions stopping the container from:
   1) Showing you spoofed windows, including prompts to enter your password.
   2) Accessing your microphone
   3) Capturing mouse gestures and/or keystrokes
   4) Accessing other microphones on your network if you are tunneling PulseAudio

EOF

read -n 1 -t 20 -p "Are you sure you want to continue? [N/y] " response
echo
if [[ "${response}" != "y" ]]; then
	echo "Exiting." >&2
	exit 1
fi


STEAMHOME="${STEAMUSER_HOME}/steamhome"

declare -a HOMEDIR_ARGS=( -v "${STEAMHOME}:/home/steamuser" )

declare -a X11_ARGS=( -v /tmp/.X11-unix:/tmp/.X11-unix )

declare -a ALSA_ARGS=( --device /dev/snd )

declare -a PULSE_ARGS=(
#	--device /dev/shm
#	-v /etc/machine-id:/etc/machine-id:ro
#	-v "/run/user/${STEAMUSER_UID}/pulse:/run/user/${STEAMUSER_UID}/pulse"
#	-v /var/lib/dbus:/var/lib/dbus
#	-v "${STEAMUSER_HOME}/.pulse:${STEAMHOME}/.pulse"
)

echo $0: Using args: "${HOMEDIR_ARGS[@]}" "${X11_ARGS[@]}" "${ALSA_ARGS[@]}" "${PULSE_ARGS[@]}"

if [[ ! -d "${STEAMHOME}" ]] ; then
	echo "$0: The steam home directory '${STEAMHOME}' does not exist or is not a directory. Please create it with the appropriate user permissions." 2>&1
	exit 1
fi


docker run -ti --rm --name steambox \
	"${HOMEDIR_ARGS[@]}" "${X11_ARGS[@]}" "${ALSA_ARGS[@]}" "${PULSE_ARGS[@]}" \
	steambox "$@"

