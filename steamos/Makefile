include ../functs.mk

IMAGES= steamos
BUILTFILES = $(IMAGES:%=%.built)

all: $(IMAGES)

distclean: clean
	$(call clean-images,$(IMAGES))
	rm -f $(BUILTFILES)

clean:
	$(call clean-containers,$(IMAGES))

$(IMAGES): % : %.built

$(BUILTFILES): 
	docker build -t $(@:%.built=%) .
	docker inspect $(@:%.built=%) > $(@)

steamos.built: rootfs.tar.xz

rootfs.tar.xz:
	$(error This makefile cannot produce its own rootfs.tar.xz.  \
		You must provide one or build one from the parent directory.)

.PHONY: all clean distclean $(IMAGES)
