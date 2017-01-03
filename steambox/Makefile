include ../functs.mk

BOOTSTRAP_STEAMDEPS ?= ./bootstrap_steamdeps.txt

ifeq ("","$(STEAMUSER_UID)")
   $(error you must provide STEAMUSER_UID (the UID of the host account that will be running steamos) to proceed)
else
   $(info STEAMUSER_UID=$(STEAMUSER_UID))
endif

ifeq ("","$(STEAMUSER_GID)")
   $(error you must provide STEAMUSER_GID (the GID of the host account that will be running steamos) to proceed)
else
   $(info STEAMUSER_GID=$(STEAMUSER_GID))
endif

ifeq ("","$(STEAMUSER_HOME)")
   $(error you must provide STEAMUSER_HOME (home directory of the host account that will be running steamos) to proceed)
else
   $(info STEAMUSER_HOME=$(STEAMUSER_HOME))
endif

IMAGE= steambox
BUILTFILE = $(IMAGE:%=%.built)

all: build

build: $(IMAGE)

distclean: clean
	$(call clean-image,$(IMAGE))
	$(RM) $(BUILTFILE)

clean:
	$(call clean-container,$(IMAGE))

$(IMAGE): % : %.built

$(BUILTFILE): Dockerfile show_motd $(BOOTSTRAP_STEAMDEPS) Makefile
	docker build -t $(@:%.built=%) \
		--build-arg "STEAMUSER_UID=$(STEAMUSER_UID)" \
		--build-arg "STEAMUSER_GID=$(STEAMUSER_GID)" \
		--build-arg "BOOTSTRAP_STEAMDEPS=$(BOOTSTRAP_STEAMDEPS)" \
		.
	docker inspect $(@:%.built=%) > $(@)

.PHONY: all build clean distclean $(IMAGE)

