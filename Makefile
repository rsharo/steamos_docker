include functs.mk

# Build parameters
SUITE=brewmaster
VARIANT=minbase
STEAMREPO=http://repo.steampowered.com/steamos
NAME=$(SUITE)

# These must be given by the caller if building steambox
export STEAMUSER_UID
export STEAMUSER_GID
export STEAMUSER_PATH

IMAGES= steamos steamos_buildmach steambox
BUILTFILES=$(join $(IMAGES:%=%/),$(IMAGES:%=%.built))
BUILDDIR=./build

all: steambox

distclean clean:
	$(foreach img,$(IMAGES),$(MAKE) -C $(img) $(@);)
	rm -f steamos/rootfs.tar.xz

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

steamos/rootfs.tar.xz:
	cp "$(BUILDDIR)/rootfs.tar.xz" steamos/rootfs.tar.xz

$(BUILDDIR)/rootfs.tar.xz:
	mkdir -p $(BUILDDIR)
	@$(call check-new-container-msg,steamos_buildmach, \
		"steamos_buildmach already exists. Please run \"make clean\" first.")
	docker run -ti --privileged --rm \
		--name steamos_buildmach \
		-v "$(abspath $(BUILDDIR)):/root/steamos" steamos_buildmach \
		"--variant=$(VARIANT)" "$(SUITE)" "$(STEAMREPO)"

$(BUILTFILES):
	$(MAKE) -C $(dir $(@)) $(notdir $(@))

.PHONY: all clean distclean delete-steamos debug-buildmach $(IMAGES)

###
# dependencies
###
distclean: clean

steambox: steambox/steambox.built
steamos : steambox/steamos.built
steamos_buildmach: steamos_buildmach/steamos_buildmach.built

steambox/steambox.built: steamos/steamos.built
steamos.built: steamos/rootfs.tar.xz
steamos/rootfs.tar.xz: $(BUILDDIR)/rootfs.tar.xz
$(BUILDDIR)/rootfs.tar.xz: steamos_buildmach/steamos_buildmach.built

