include ../functs.mk

IMAGE= steamos_buildmach
BUILTFILE = $(IMAGE:%=%.built)

all: build

build: $(IMAGE)

distclean: clean
	$(call clean-image,$(IMAGE))
	$(RM) $(BUILTFILE)

clean:
	$(call clean-container,$(IMAGE))

$(IMAGE): % : %.built

$(BUILTFILE): Dockerfile Makefile
	$(DOCKER) build -t $(@:%.built=%) .
	$(DOCKER) inspect $(@:%.built=%) > $(@)

.PHONY: all build clean distclean $(IMAGE)
