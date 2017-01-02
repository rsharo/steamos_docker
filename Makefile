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

IMAGES= steambox steamos_buildmach
BUILDDIR=./build

all: steambox

steamos: $(BUILDDIR/steamos.built)

$(BUILDDIR/steamos.built): $(BUILDDIR)/Dockerfile $(BUILDDIR)/rootfs.tar.xz
	docker build -t $(NAME) ./build
	docker inspect $(NAME) > $(BUILDDIR)/$(NAME).built

steambox: steamos

steambox steamos_buildmach:
	$(MAKE) -C $(@) all

distclean: clean
	$(foreach img,$(IMAGES),$(MAKE) -C $(img) $(@);)
	$(RM) $(BUILDDIR)

clean:
	$(foreach img,$(IMAGES),$(MAKE) -C $(img) $(@);)

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

.PHONY: all clean distclean delete-steamos debug-buildmach steamos $(IMAGES)

