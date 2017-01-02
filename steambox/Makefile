include ../functs.mk

ifeq ($(origin STEAMUSER_UID),undefined)
	$(error you must provide STEAMUSER_UID (the UID of the host account that will be running steamos) to proceed)
endif

ifeq ($(origin STEAMUSER_GID),undefined)
	$(error you must provide STEAMUSER_GID (the GID of the host account that will be running steamos) to proceed)
endif

ifeq ($(origin STEAMUSER_HOME),undefined)
	$(error you must provide STEAMUSER_HOME (home directory of the host account that will be running steamos) to proceed)
endif

IMAGES= steambox
BUILTFILES = $(IMAGES:%=%.built)

all: $(IMAGES)

distclean: clean
	$(call clean-images,$(IMAGES))
	rm -f $(BUILTFILES)

clean:
	$(call clean-containers,$(IMAGES))

$(IMAGES): $(@:%=%.built)

$(BUILTFILES):
	docker build -t $@ \
		--build-arg STEAMUSER_UID=$(STEAMUSER_UID) \
		--build-arg STEAMUSER_GID=$(STEAMUSER_GID) .
	docker inspect $@ > $(@:%=%.built)

.PHONY: all clean distclean $(IMAGES)

