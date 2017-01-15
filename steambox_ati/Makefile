include ../functs.mk

DOCKER ?= docker
IMAGE= steambox_ati
BUILTFILE = $(IMAGE:%=%.built)
DRIVERFILE ?= AMD-Catalyst-15.9-Linux-installer-15.201.1151-x86.x86_64.run

all: build

build: $(IMAGE)

distclean: clean
	$(call clean-image,$(IMAGE))
	$(RM) $(BUILTFILE)

clean:
	$(call clean-container,$(IMAGE))

$(IMAGE): % : %.built

pre-driver-install: Dockerfile.1 Makefile $(DRIVERFILE)
	$(DOCKER) build -t steambox_ati:preinstall --build-arg DRIVERFILE=$(DRIVERFILE) -f Dockerfile.1 .

$(BUILTFILE): Dockerfile Makefile pre-driver-install
	$(DOCKER) run -ti --name steambox_ati \
		-v /tmp/.X11-unix:/tmp/.X11-unix \
		--env DRIVERFILE=$(DRIVERFILE) \
		steambox_ati:preinstall
	$(DOCKER) commit steambox_ati steambox_ati:postinstall
	$(DOCKER) rm steambox_ati
	$(DOCKER) build -t $(@:%.built=%) .
	$(DOCKER) inspect $(@:%.built=%) > $(@)

$(DRIVERFILE):
	$(error You do not appear to have $(DRIVERFILE): please download it from AMD/ATI's website before continuing.)

.PHONY: all build clean distclean pre-driver-install $(IMAGE)

