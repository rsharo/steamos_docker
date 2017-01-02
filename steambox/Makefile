include ../functs.mk

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

IMAGES= steambox
BUILTFILES = $(IMAGES:%=%.built)

all: $(IMAGES)

distclean: clean
	$(call clean-images,$(IMAGES))
	rm -f $(BUILTFILES)

clean:
	$(call clean-containers,$(IMAGES))

$(IMAGES): % : %.built

$(BUILTFILES):
	docker build -t $(@:%.built=%) \
		--build-arg STEAMUSER_UID=$(STEAMUSER_UID) \
		--build-arg STEAMUSER_GID=$(STEAMUSER_GID) .
	docker inspect $(@:%.built=%) > $(@)

.PHONY: all clean distclean $(IMAGES)

