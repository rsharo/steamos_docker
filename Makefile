include functs.mk

# Build parameters
SUITE=brewmaster
VARIANT=minbase
STEAMREPO=http://repo.steampowered.com/steamos
NAME=$(SUITE)

IMAGES= steamos steamos_buildmach
BUILDDIR=./build

all: steamos

distclean: clean
	$(MAKE) -C steamos_buildmach distclean
	rm -rf "$(BUILDDIR)"

clean:
	$(MAKE) -C steamos_buildmach clean
	rm -f steamos/rootfs.tar.xz

steamos: $(BUILDDIR)/rootfs.tar.xz
	cp "$(BUILDDIR)/rootfs.tar.xz" steamos/rootfs.tar.xz
	docker build -t "$(NAME)" ./steamos

steamos_buildmach:
	$(MAKE) -C steamos_buildmach all


delete-steamos:
	@$(call check-confirm,"Are you sure you want to delete your steamos container and image?")
	@echo
	$(call clean-container,$(NAME))
	$(call clean-image,$(NAME))

debug-buildmach: steamos_buildmach
	docker run -ti --privileged --rm \
		-v "$(abspath $(BUILDDIR)):/root/steamos" \
		--entrypoint /bin/bash \
		steamos_buildmach -i


$(BUILDDIR)/rootfs.tar.xz: steamos_buildmach
	mkdir -p $(BUILDDIR)
	@$(call check-new-container-msg,steamos_buildmach, \
		"steamos_buildmach already exists. Please run \"make clean\" first.")
	docker run -ti --privileged --rm \
		--name steamos_buildmach \
		-v "$(abspath $(BUILDDIR)):/root/steamos" steamos_buildmach \
		"--variant=$(VARIANT)" "$(SUITE)" "$(STEAMREPO)"

.PHONY: all clean distclean delete-steamos debug-buildmach $(IMAGES)
