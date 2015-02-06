SRC_ROOT=$(shell pwd)/src
SRC_OUT=$(SRC_ROOT)/out

DST=$(shell pwd)/build

ROOT=$(shell pwd)
SCRIPTS=$(ROOT)/scripts
HEADERS=$(shell cat $(SCRIPTS)/libjingle.headers)
PKGCONFIG_VERSION?=1.0.0
DEB_VERSION?=1.0.0
DEB_REVISION?=1

LINUX_x86_64_SRC=$(SRC_OUT)/linux_x86_64
LINUX_x86_64_DST=$(DST)/linux_x86_64

LINUX_x86_64_DEBUG_SRC=$(LINUX_x86_64_SRC)/Debug
LINUX_x86_64_DEBUG_DST=$(LINUX_x86_64_DST)/debug
LINUX_x86_64_DEBUG_DEB=libjingle_$(DEB_VERSION)debug-$(DEB_REVISION)_amd64.deb

LINUX_x86_64_RELEASE_SRC=$(LINUX_x86_64_SRC)/Release
LINUX_x86_64_RELEASE_DST=$(LINUX_x86_64_DST)/release
LINUX_x86_64_RELEASE_DEB=libjingle_$(DEB_VERSION)release-$(DEB_REVISION)_amd64.deb

LINUX_ARMHF_SRC=$(SRC_OUT)/linux_armv7hf
LINUX_ARMHF_DST=$(DST)/linux_armhf

LINUX_ARMHF_DEBUG_SRC=$(LINUX_ARMHF_SRC)/Debug
LINUX_ARMHF_DEBUG_DST=$(LINUX_ARMHF_DST)/debug
LINUX_ARMHF_DEBUG_DEB=libjingle_$(DEB_VERSION)debug-$(DEB_REVISION)_armhf.deb

LINUX_ARMHF_RELEASE_SRC=$(LINUX_ARMHF_SRC)/Release
LINUX_ARMHF_RELEASE_DST=$(LINUX_ARMHF_DST)/release
LINUX_ARMHF_RELEASE_DEB=libjingle_$(DEB_VERSION)release-$(DEB_REVISION)_armhf.deb

all: \
linux_x86_64_debug \
linux_x86_64_release \
linux_armhf_debug \
linux_armhf_release

clean:
	rm -rf $(SRC_OUT)/*
	rm -rf $(DST)

.phony: \
all \
clean \
linux_x86_64_debug \
linux_x86_64_release \
linux_armhf_debug \
linux_armhf_release

$(DST):
	mkdir -p $@

# linux x86_64 debug

$(LINUX_x86_64_DEBUG_SRC)/libjingle.a $(LINUX_x86_64_DEBUG_SRC)/obj/talk/libjingle_peerconnection_so.ninja:
	WEBRTC_OS=linux WEBRTC_ARCH=x86_64 WEBRTC_BUILD=Debug $(SCRIPTS)/build

$(LINUX_x86_64_DEBUG_DST): $(DST)
	mkdir -p $@

$(LINUX_x86_64_DEBUG_DST)/root:
	mkdir -p $@

$(LINUX_x86_64_DEBUG_DST)/root/usr/lib/libjingle.a: $(LINUX_x86_64_DEBUG_SRC)/libjingle.a
	mkdir -p $(dir $@)
	cp $< $@

$(LINUX_x86_64_DEBUG_DST)/root/usr/lib/pkconfig/libjingle.pc: $(LINUX_x86_64_DEBUG_SRC)/obj/talk/libjingle_peerconnection_so.ninja
	mkdir -p $(dir $@)
	$(SCRIPTS)/libjingle pkg-config $(LINUX_x86_64_DEBUG_SRC) $(PKGCONFIG_VERSION) > $@

$(addprefix $(LINUX_x86_64_DEBUG_DST)/root, $(HEADERS)):
	mkdir -p $(dir $@)
	cp $(subst $(LINUX_x86_64_DEBUG_DST)/root, $(SRC_ROOT), $@) $@

$(DST)/$(LINUX_x86_64_DEBUG_DEB): \
$(addprefix $(LINUX_x86_64_DEBUG_DST)/root, $(HEADERS)) \
$(LINUX_x86_64_DEBUG_DST)/root/usr/lib/pkconfig/libjingle.pc \
$(LINUX_x86_64_DEBUG_DST)/root/usr/lib/libjingle.a
	cd $(DST) && fpm -s dir -t deb -a x86_64 -n libjingle -v $(DEB_VERSION)debug --iteration $(DEB_REVISION) $(LINUX_x86_64_DEBUG_DST)/root

linux_x86_64_debug: $(DST)/$(LINUX_x86_64_DEBUG_DEB)

# linux x86_64 release

$(LINUX_x86_64_RELEASE_SRC)/libjingle.a $(LINUX_x86_64_RELEASE_SRC)/obj/talk/libjingle_peerconnection_so.ninja:
	WEBRTC_OS=linux WEBRTC_ARCH=x86_64 WEBRTC_BUILD=Release $(SCRIPTS)/build

$(LINUX_x86_64_RELEASE_DST): $(DST)
	mkdir -p $@

$(LINUX_x86_64_RELEASE_DST)/root:
	mkdir -p $@

$(LINUX_x86_64_RELEASE_DST)/root/usr/lib/libjingle.a: $(LINUX_x86_64_RELEASE_SRC)/libjingle.a
	mkdir -p $(dir $@)
	cp $< $@

$(LINUX_x86_64_RELEASE_DST)/root/usr/lib/pkconfig/libjingle.pc: $(LINUX_x86_64_RELEASE_SRC)/obj/talk/libjingle_peerconnection_so.ninja
	mkdir -p $(dir $@)
	$(SCRIPTS)/libjingle pkg-config $(LINUX_x86_64_RELEASE_SRC) $(PKGCONFIG_VERSION) > $@

$(addprefix $(LINUX_x86_64_RELEASE_DST)/root, $(HEADERS)):
	mkdir -p $(dir $@)
	cp $(subst $(LINUX_x86_64_RELEASE_DST)/root, $(SRC_ROOT), $@) $@

$(DST)/$(LINUX_x86_64_RELEASE_DEB): \
$(addprefix $(LINUX_x86_64_RELEASE_DST)/root, $(HEADERS)) \
$(LINUX_x86_64_RELEASE_DST)/root/usr/lib/pkconfig/libjingle.pc \
$(LINUX_x86_64_RELEASE_DST)/root/usr/lib/libjingle.a
	cd $(DST) && fpm -s dir -t deb -a x86_64 -n libjingle -v $(DEB_VERSION)release --iteration $(DEB_REVISION) $(LINUX_x86_64_RELEASE_DST)/root

linux_x86_64_release: $(DST)/$(LINUX_x86_64_RELEASE_DEB)

# linux armhf debug

$(LINUX_ARMHF_DEBUG_SRC)/libjingle.a $(LINUX_ARMHF_DEBUG_SRC)/obj/talk/libjingle_peerconnection_so.ninja:
	WEBRTC_OS=linux WEBRTC_ARCH=armv7hf WEBRTC_BUILD=Debug $(SCRIPTS)/build

$(LINUX_ARMHF_DEBUG_DST): $(DST)
	mkdir -p $@

$(LINUX_ARMHF_DEBUG_DST)/root:
	mkdir -p $@

$(LINUX_ARMHF_DEBUG_DST)/root/usr/lib/libjingle.a: $(LINUX_ARMHF_DEBUG_SRC)/libjingle.a
	mkdir -p $(dir $@)
	cp $< $@

$(LINUX_ARMHF_DEBUG_DST)/root/usr/lib/pkconfig/libjingle.pc: $(LINUX_ARMHF_DEBUG_SRC)/obj/talk/libjingle_peerconnection_so.ninja
	mkdir -p $(dir $@)
	$(SCRIPTS)/libjingle pkg-config $(LINUX_ARMHF_DEBUG_SRC) $(PKGCONFIG_VERSION) > $@

$(addprefix $(LINUX_ARMHF_DEBUG_DST)/root, $(HEADERS)):
	mkdir -p $(dir $@)
	cp $(subst $(LINUX_ARMHF_DEBUG_DST)/root, $(SRC_ROOT), $@) $@

$(DST)/$(LINUX_ARMHF_DEBUG_DEB): \
$(addprefix $(LINUX_ARMHF_DEBUG_DST)/root, $(HEADERS)) \
$(LINUX_ARMHF_DEBUG_DST)/root/usr/lib/pkconfig/libjingle.pc \
$(LINUX_ARMHF_DEBUG_DST)/root/usr/lib/libjingle.a
	cd $(DST) && fpm -s dir -t deb -a armhf -n libjingle -v $(DEB_VERSION)debug --iteration $(DEB_REVISION) $(LINUX_ARMHF_DEBUG_DST)/root

linux_armhf_debug: $(DST)/$(LINUX_ARMHF_DEBUG_DEB)

# linux arm release

$(LINUX_ARMHF_RELEASE_SRC)/libjingle.a $(LINUX_ARMHF_RELEASE_SRC)/obj/talk/libjingle_peerconnection_so.ninja:
	WEBRTC_OS=linux WEBRTC_ARCH=armv7hf WEBRTC_BUILD=Release $(SCRIPTS)/build

$(LINUX_ARMHF_RELEASE_DST): $(DST)
	mkdir -p $@

$(LINUX_ARMHF_RELEASE_DST)/root:
	mkdir -p $@

$(LINUX_ARMHF_RELEASE_DST)/root/usr/lib/libjingle.a: $(LINUX_ARMHF_RELEASE_SRC)/libjingle.a
	mkdir -p $(dir $@)
	cp $< $@

$(LINUX_ARMHF_RELEASE_DST)/root/usr/lib/pkconfig/libjingle.pc: $(LINUX_ARMHF_RELEASE_SRC)/obj/talk/libjingle_peerconnection_so.ninja
	mkdir -p $(dir $@)
	$(SCRIPTS)/libjingle pkg-config $(LINUX_ARMHF_RELEASE_SRC) $(PKGCONFIG_VERSION) > $@

$(addprefix $(LINUX_ARMHF_RELEASE_DST)/root, $(HEADERS)):
	mkdir -p $(dir $@)
	cp $(subst $(LINUX_ARMHF_RELEASE_DST)/root, $(SRC_ROOT), $@) $@

$(DST)/$(LINUX_ARMHF_RELEASE_DEB): \
$(addprefix $(LINUX_ARMHF_RELEASE_DST)/root, $(HEADERS)) \
$(LINUX_ARMHF_RELEASE_DST)/root/usr/lib/pkconfig/libjingle.pc \
$(LINUX_ARMHF_RELEASE_DST)/root/usr/lib/libjingle.a
	cd $(DST) && fpm -s dir -t deb -a armhf -n libjingle -v $(DEB_VERSION)release --iteration $(DEB_REVISION) $(LINUX_ARMHF_RELEASE_DST)/root

linux_armhf_release: $(DST)/$(LINUX_ARMHF_RELEASE_DEB)
