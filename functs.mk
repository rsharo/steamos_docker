# Author: rsharo <rsharo@users.noreply.github.com>

#
# Call a single-argument function on every element in a list
# usage:
# 	$(call myFunction,file1 file2 ... fileN)
map1arg = $(foreach a,$(2),$(call $(1),$(a)))


#
# Remove containers from docker daemon
# usage:
# 	$(call clean-container,myContainerName)
clean-container = docker ps -aq -f "name=$(1)" | xargs -r docker rm -f


#
# Remove images from docker daemon
# usage:
# 	$(call clean-image, myImageName)
clean-image = docker images -q "$(1)" | xargs -r docker rmi -f


#
# Remove volumes from docker daemon
# usage: 
# 	$(call clean-volume, myVolumeName)
clean-volume = docker volume ls -qf "name=$(1)" | xargs -r docker volume rm


#
# Prompt user, retain fail code if user doesn't press "y"
# usage:
# 	@$(call check-confirm,"Are you sure you want to do that?")
# 	@echo
check-confirm = bash -c 'read -n 1 -t 20 -p "$(1) [y/N] " response ; [[ "$$response" == "y" ]]'


#
# Return fail code if container already exists
# usage:
#	@$(call check-new-container,containerName)
#	docker run --name containerName ...
check-new-container = docker ps -aq -f "name=$(1)" | xargs -r false


#
# Return fail code if local image repository exists
# usage:
#	@if ( $(call check-new-image,$(IMAGE)) ) ; then \
#		echo "Building $(IMAGE)..." ; \
#		docker build -t $(IMAGE) $(IMAGE) ; \
#	fi
check-new-image = docker images -q "$(1)" | xargs -r false


#
# Variants that accept a list of arguments
# usage:
# 	$(call XXXs,arg1 arg2 ... argN)
clean-containers = $(call map1arg,clean-container,$(1))
clean-images = $(call map1arg,clean-image,$(1))
clean-volumes = $(call map1arg,clean-volume,$(1))
check-new-images = $(call check-new-image,$(1))
check-new-containers = $(call check-new-container,$(1))


#
# Variants that print an error message on failure
# usage:
#	@$(call XXX-msg,arg,"ERROR: command failed.")
#	docker build ...
call-with-msg = ( $(call $(1),$(2)) ) || ( echo $(3)>&2 ; false )
check-new-container-msg = $(call call-with-msg,check-new-container,$(1),$(2))
check-new-containers-msg = $(call call-with-msg,check-new-containers,$(1),$(2))
check-new-image-msg = $(call call-with-msg,check-new-image,$(1),$(2))
check-new-images-msg = $(call call-with-msg,check-new-images,$(1),$(2))
