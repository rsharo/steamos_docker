
IMAGES= steamos steamos_buildmach
OUTPUT=./output

.PHONY: all clean distclean delete-steamos $(IMAGES) 

all: steamos

distclean: clean
	$(call clean-image,steamos_buildmach)
	$(call clean-volume,$(abspath $(OUTPUT)))
	rm -rf $(OUTPUT)

clean:
	$(call clean-container,steamos_buildmach)
	@:

steamos: $(OUTPUT)/rootfs.tar.xz
	cp -f Dockerfile.steamos $(OUTPUT)/Dockerfile
	docker build -t $@ $(OUTPUT)

steamos_buildmach:
	docker build -t $@ .

delete-steamos:
	@bash -c 'read -n 1 -t 20 -p "Are you sure you want to delete your steamos container and image? [y/N] " response ; [[ "$$response" == "y" ]]'
	@echo
	$(call clean-container,steamos) 
	$(call clean-image,steamos)

$(OUTPUT)/rootfs.tar.xz: steamos_buildmach
	mkdir -p $(OUTPUT)
	docker run -ti --privileged --name steamos_buildmach \
		-v $(abspath $(OUTPUT)):/root/steamos steamos_buildmach

clean-container= $(foreach id, $(shell docker ps -aq -f name="$(1)"), docker rm -f $(id) ; )
clean-image= $(foreach id, $(shell docker images -q "$(1)"), docker rmi -f $(id) ; )
clean-volume= $(foreach id, $(shell docker volume ls -qf name="$(1)"), docker volume rm $(id) ; )

