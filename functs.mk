# Author: rsharo <rsharo@users.noreply.github.com>

#### Call a single-argument function on every element in a list ####
# usage:
# 	$(call myFunction,file1 file2 ... fileN)
map1arg = $(foreach a,$(2),$(call $(1),$(a)))



#### Remove containers from docker daemon ####
# usage:
# 	$(call clean-container,myContainerName)
clean-container = docker ps -aq -f "name=$(1)" | xargs -r docker rm -f

# usage:
# 	$(call clean-containers,myContainerName1 myContainerName2 ... myContainerNameN)
clean-containers = $(call map1arg,clean-container,$1)



#### Remove images from docker daemon ####
# usage:
# 	$(call clean-image, myImageName)
clean-image = docker images -q "$(1)" | xargs -r docker rmi -f

# usage:
# 	$(call clean-images, myImageName1 myImageName2 ... myImageNameN)
clean-images = $(call map1arg,clean-image,$1)



#### Remove volumes from docker daemon ####
# usage: 
# 	$(call clean-volume, myVolumeName)
clean-volume = docker volume ls -qf "name=$(1)" | xargs -r docker volume rm

# usage:
# 	$(call clean-volume, myVolumeName1 myVolumeName2 ... myVolumeNameN)
clean-volumes = $(call map1arg,clean-volume,$1)



#### Prompt user, retain fail code if user doesn't press "y" ####
# usage:
# 	@$(call check-confirm,"Are you sure you want to do that?")
# 	@echo

check-confirm = bash -c 'read -n 1 -t 20 -p "$(1) [y/N] " response ; [[ "$$response" == "y" ]]'

#### Return fail code if container already exists ####
# usage:
#	@$(call check-new-container,containerName)
#	docker run --name containerName ...
check-new-container = docker ps -aq -f "name=$(1)" | xargs -r false

# usage:
#	$(call check-new-container,containerName,"Container exists. Please close it.")
# 	docker run --name containerName ...
check-new-container-msg = $(call check-new-container,$(1)) || ( echo "$(2)">&2 ; false )
