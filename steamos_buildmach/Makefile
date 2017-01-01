include ../functs.mk

IMAGES= steamos_buildmach

all: $(IMAGES)

distclean: clean
	$(call clean-images,$(IMAGES))

clean:
	$(call clean-containers,$(IMAGES))

steamos_buildmach:
	docker build -t $@ .

.PHONY: all clean distclean $(IMAGES)
