include ../../functs.mk

IMAGES= debug_buildmach

all: run

distclean: clean
	$(call clean-images,$(IMAGES))

clean:
	$(call clean-containers,$(IMAGES))

run: debug_buildmach
	@$(call check-new-container-msg,$<, \
		"$< already exists. Please run \"make clean\" first.")
	docker run --rm --name $< -ti debug_buildmach

debug_buildmach:
	docker build -t $@ .

.PHONY: all clean distclean run $(IMAGES)
