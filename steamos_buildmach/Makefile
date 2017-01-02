include ../functs.mk

IMAGES= steamos_buildmach
BUILTFILES = $(IMAGES:%=%.built)

all: $(IMAGES)

distclean: clean
	$(call clean-images,$(IMAGES))
	$(RM) $(BUILTFILES)

clean:
	$(call clean-containers,$(IMAGES))

$(IMAGES): % : %.built

$(BUILTFILES):
	docker build -t $(@:%.built=%) .
	docker inspect $(@:%.built=%) > $(@)


.PHONY: all clean distclean $(IMAGES)
