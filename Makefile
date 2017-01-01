

IMAGES= steamos steamos_buildmach
OUTPUT=./output

.PHONY: all clean clean-buildimage distclean $(IMAGES) 

all: steamos

distclean: clean-buildimage
	$(call clean-container,steamos)
	$(call clean-image,steamos)
	@:

clean-buildimage: clean
	$(call clean-image,steamos_buildmach)
	$(call clean-volume,$(BUILD_PATH))
	rm -rf $(OUTPUT)

clean:
	$(call clean-container,steamos_buildmach)
	@:

steamos: $(OUTPUT)/rootfs.tar.xz
	cp -f Dockerfile.steamos $(OUTPUT)/Dockerfile
	docker build -t $@ $(OUTPUT)

steamos_buildmach:
	docker build -t $@ .

$(OUTPUT)/rootfs.tar.xz: steamos_buildmach
	mkdir -p $(OUTPUT)
	docker run -ti --privileged --name steamos_buildmach \
		-v $(realpath BUILD_VOLUME):/root/steamos steamos_buildmach

clean-container= $(foreach id, $(shell docker ps -aq -f name="$(1)"), docker rm -f $(id) ; )
clean-image= $(foreach id, $(shell docker images -q "$(1)"), docker rmi -f $(id) ; )
clean-volume= $(foreach id, $(shell docker volume ls -qf name="$(1)"), docker volume rm $(id) ; )

