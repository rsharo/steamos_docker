

IMAGES= steamos steamos_buildmach
BUILD_VOLUME=$(realpath ./output)

.PHONY: all clean clean-buildimage distclean $(IMAGES) 

all: steamos

distclean: clean-buildimage
	$(call clean-container,steamos)
	$(call clean-image,steamos)

clean-buildimage: clean
	$(call clean-image,steamos_buildmach)
	$(call clean-volume,$(BUILD_VOLUME))
	rm -rf $(BUILD_VOLUME)

clean:
	$(call clean-container,steamos_buildmach)

steamos: $(BUILD_VOLUME)/rootfs.tar.xz
	cp -f Dockerfile.steamos $(BUILD_VOLUME)/Dockerfile
	docker build -t $@ $(BUILD_VOLUME)

steamos_buildmach:
	docker build -t $@ .

$(BUILD_VOLUME)/rootfs.tar.xz: steamos_buildmach
	mkdir -p $(BUILD_VOLUME)
	docker run -ti --privileged --name steamos_buildmach \
		-v $(BUILD_VOLUME):/root/steamos steamos_buildmach

clean-container= $(foreach id, $(shell docker ps -aq -f name="$(1)"), docker rm -f $(id) ; )
clean-image= $(foreach id, $(shell docker images -q "$(1)"), docker rmi -f $(id) ; )
clean-volume= $(foreach id, $(shell docker volume ls -qf name="$(1)"), docker volume rm $(id) ; )

