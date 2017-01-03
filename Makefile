include functs.mk

# Build parameters
export SUITE ?= brewmaster
export VARIANT ?= minbase
export STEAMREPO ?= http://repo.steampowered.com/steamos
export BASEIMAGE ?= $(SUITE)
export STEAMUSER_UID STEAMUSER_GID STEAMUSER_HOME

IMAGES= steambox steamos_buildmach
BUILDDIR=./build

all: steambox

steambox: baseimage

baseimage: $(BUILDDIR)/$(BASEIMAGE).built

$(IMAGES):
	$(MAKE) -C $(@) build

distclean: clean
	$(foreach img,$(IMAGES),$(MAKE) -C $(img) $(@);)
	$(RM) -r $(BUILDDIR)


clean:
	$(foreach img,$(IMAGES),$(MAKE) -C $(img) $(@);)


$(BUILDDIR)/$(BASEIMAGE).built: $(BUILDDIR)
	@if ( $(call check-new-image,$(BASEIMAGE)) ) ; then \
		echo "Building baseimage $(BASEIMAGE)..." ; \
		$(MAKE) build-baseimage ; \
	fi
	docker inspect $(BASEIMAGE) > $(BUILDDIR)/$(BASEIMAGE).built


debug-buildmach: steamos_buildmach
	docker run -ti --privileged --rm \
		-v "$(abspath $(BUILDDIR)):/root/steamos" \
		--entrypoint /bin/bash \
		steamos_buildmach -i


delete-baseimage:
	@$(call check-confirm,Are you sure you want to delete your SteamOS base image ($(BASEIMAGE))?)
	@echo
	$(call clean-container,$(BASEIMAGE))
	$(call clean-image,$(BASEIMAGE))
	$(RM) $(BUILDDIR)/$(BASEIMAGE).built


build-baseimage: $(BUILDDIR)/Dockerfile $(BUILDDIR)/rootfs.tar.xz
	docker build -t $(BASEIMAGE) ./build


$(BUILDDIR)/Dockerfile $(BUILDDIR)/rootfs.tar.xz: steamos_buildmach $(BUILDDIR)
	@$(call check-new-container-msg,steamos_buildmach, \
		steamos_buildmach already exists. Please run \"make clean\" first.)
	docker run -ti --privileged --rm \
		--name steamos_buildmach \
		-v "$(abspath $(BUILDDIR)):/root/steamos" steamos_buildmach \
		"--variant=$(VARIANT)" "$(SUITE)" "$(STEAMREPO)"

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

.PHONY: all clean distclean baseimage build-baseimage delete-baseimage debug-buildmach $(IMAGES)

