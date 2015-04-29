SRC_ROOT=$(shell pwd)/src
SRC_OUT=$(SRC_ROOT)/out

DST=$(shell pwd)/build

ROOT=$(shell pwd)
SCRIPTS=$(ROOT)/scripts
HEADERS=$(shell cat $(SCRIPTS)/libjingle.headers)
GIT_REVISION?=c444de627656ffaef2d97285eb55656cc866cc6e
PKGCONFIG_VERSION?=1.0.0
DEB_VERSION?=1$(shell cd ${SRC_ROOT} && git rev-parse --short HEAD)
DEB_REVISION?=1

LINUX_x86_64_SRC=$(SRC_OUT)/linux_x86_64
LINUX_x86_64_DST=$(DST)/linux_x86_64
LINUX_x86_64_DEBUG_SRC=$(LINUX_x86_64_SRC)/Debug
LINUX_x86_64_DEBUG_DST=$(LINUX_x86_64_DST)/debug
LINUX_x86_64_DEBUG_DEB=libjingle-dev_$(DEB_VERSION)debug-$(DEB_REVISION)_amd64.deb
LINUX_x86_64_RELEASE_SRC=$(LINUX_x86_64_SRC)/Release
LINUX_x86_64_RELEASE_DST=$(LINUX_x86_64_DST)/release
LINUX_x86_64_RELEASE_DEB=libjingle-dev_$(DEB_VERSION)release-$(DEB_REVISION)_amd64.deb

LINUX_ARMHF_SRC=$(SRC_OUT)/linux_armv7hf
LINUX_ARMHF_DST=$(DST)/linux_armhf
LINUX_ARMHF_DEBUG_SRC=$(LINUX_ARMHF_SRC)/Debug
LINUX_ARMHF_DEBUG_DST=$(LINUX_ARMHF_DST)/debug
LINUX_ARMHF_DEBUG_DEB=libjingle-dev_$(DEB_VERSION)debug-$(DEB_REVISION)_armhf.deb
LINUX_ARMHF_RELEASE_SRC=$(LINUX_ARMHF_SRC)/Release
LINUX_ARMHF_RELEASE_DST=$(LINUX_ARMHF_DST)/release
LINUX_ARMHF_RELEASE_DEB=libjingle-dev_$(DEB_VERSION)release-$(DEB_REVISION)_armhf.deb

ANDROID_ARMV7_SRC=$(SRC_OUT)/android_armv7
ANDROID_ARMV7_DST=$(DST)/android_armv7
ANDROID_ARMV7_DEBUG_SRC=$(ANDROID_ARMV7_SRC)/Debug
ANDROID_ARMV7_DEBUG_DST=$(ANDROID_ARMV7_DST)/debug
ANDROID_ARMV7_DEBUG_JAR=
ANDROID_ARMV7_RELEASE_SRC=$(ANDROID_ARMV7_SRC)/Release
ANDROID_ARMV7_RELEASE_DST=$(ANDROID_ARMV7_DST)/release
ANDROID_ARMV7_RELEASE_JAR=

all: \
linux_x86_64_debug \
linux_x86_64_release \
linux_armhf_debug \
linux_armhf_release \
android_armv7_debug \
android_armv7_release

clean:
	rm -rf $(SRC_OUT)/*
	rm -rf $(DST)

.phony: \
all \
clean \
linux_x86_64_debug \
linux_x86_64_release \
linux_armhf_debug \
linux_armhf_release \
android_armv7_debuge \
android_armv7_release

$(DST):
	mkdir -p $@

# linux x86_64 debug

$(LINUX_x86_64_DEBUG_SRC)/libjingle.a $(LINUX_x86_64_DEBUG_SRC)/obj/talk/libjingle_peerconnection_so.ninja:
	WEBRTC_PROFILE=linux_x86_64 WEBRTC_BUILD=Debug $(SCRIPTS)/build -r $(GIT_REVISION)

$(LINUX_x86_64_DEBUG_DST): $(DST)
	mkdir -p $@

$(LINUX_x86_64_DEBUG_DST)/root:
	mkdir -p $@

$(LINUX_x86_64_DEBUG_DST)/root/usr/lib/libjingle.a: $(LINUX_x86_64_DEBUG_SRC)/libjingle.a
	mkdir -p $(dir $@)
	cp $< $@

$(LINUX_x86_64_DEBUG_DST)/root/usr/lib/pkgconfig/libjingle.pc: $(LINUX_x86_64_DEBUG_SRC)/obj/talk/libjingle_peerconnection_so.ninja
	mkdir -p $(dir $@)
	$(SCRIPTS)/libjingle pkg-config $(LINUX_x86_64_DEBUG_SRC) $(PKGCONFIG_VERSION) > $@

$(addprefix $(LINUX_x86_64_DEBUG_DST)/root/usr/include/jingle, $(HEADERS)): $(LINUX_x86_64_DEBUG_SRC)/libjingle.a
	mkdir -p $(dir $@)
	cp $(subst $(LINUX_x86_64_DEBUG_DST)/root/usr/include/jingle, $(SRC_ROOT), $@) $@

$(DST)/$(LINUX_x86_64_DEBUG_DEB): \
$(addprefix $(LINUX_x86_64_DEBUG_DST)/root/usr/include/jingle, $(HEADERS)) \
$(LINUX_x86_64_DEBUG_DST)/root/usr/lib/pkgconfig/libjingle.pc \
$(LINUX_x86_64_DEBUG_DST)/root/usr/lib/libjingle.a
	rm -rf $@ && cd $(DST) && fpm -s dir -t deb -a x86_64 -n libjingle-dev -v $(DEB_VERSION)debug --iteration $(DEB_REVISION) -C $(LINUX_x86_64_DEBUG_DST)/root .

linux_x86_64_debug: $(DST)/$(LINUX_x86_64_DEBUG_DEB)

# linux x86_64 release

$(LINUX_x86_64_RELEASE_SRC)/libjingle.a $(LINUX_x86_64_RELEASE_SRC)/obj/talk/libjingle_peerconnection_so.ninja:
	WEBRTC_PROFILE=linux_x86_64 WEBRTC_BUILD=Release $(SCRIPTS)/build -r $(GIT_REVISION)

$(LINUX_x86_64_RELEASE_DST): $(DST)
	mkdir -p $@

$(LINUX_x86_64_RELEASE_DST)/root:
	mkdir -p $@

$(LINUX_x86_64_RELEASE_DST)/root/usr/lib/libjingle.a: $(LINUX_x86_64_RELEASE_SRC)/libjingle.a
	mkdir -p $(dir $@)
	cp $< $@

$(LINUX_x86_64_RELEASE_DST)/root/usr/lib/pkgconfig/libjingle.pc: $(LINUX_x86_64_RELEASE_SRC)/obj/talk/libjingle_peerconnection_so.ninja
	mkdir -p $(dir $@)
	$(SCRIPTS)/libjingle pkg-config $(LINUX_x86_64_RELEASE_SRC) $(PKGCONFIG_VERSION) > $@

$(addprefix $(LINUX_x86_64_RELEASE_DST)/root/usr/include/jingle, $(HEADERS)): $(LINUX_x86_64_RELEASE_SRC)/libjingle.a
	mkdir -p $(dir $@)
	cp $(subst $(LINUX_x86_64_RELEASE_DST)/root/usr/include/jingle, $(SRC_ROOT), $@) $@

$(DST)/$(LINUX_x86_64_RELEASE_DEB): \
$(addprefix $(LINUX_x86_64_RELEASE_DST)/root/usr/include/jingle, $(HEADERS)) \
$(LINUX_x86_64_RELEASE_DST)/root/usr/lib/pkgconfig/libjingle.pc \
$(LINUX_x86_64_RELEASE_DST)/root/usr/lib/libjingle.a
	rm -rf $@ && cd $(DST) && fpm -s dir -t deb -a x86_64 -n libjingle-dev -v $(DEB_VERSION)release --iteration $(DEB_REVISION) -C $(LINUX_x86_64_RELEASE_DST)/root .

linux_x86_64_release: $(DST)/$(LINUX_x86_64_RELEASE_DEB)

# linux armhf debug

$(LINUX_ARMHF_DEBUG_SRC)/libjingle.a $(LINUX_ARMHF_DEBUG_SRC)/obj/talk/libjingle_peerconnection_so.ninja:
	WEBRTC_PROFILE=linux_armv7hf WEBRTC_BUILD=Debug $(SCRIPTS)/build -r $(GIT_REVISION)

$(LINUX_ARMHF_DEBUG_DST): $(DST)
	mkdir -p $@

$(LINUX_ARMHF_DEBUG_DST)/root:
	mkdir -p $@

$(LINUX_ARMHF_DEBUG_DST)/root/usr/lib/libjingle.a: $(LINUX_ARMHF_DEBUG_SRC)/libjingle.a
	mkdir -p $(dir $@)
	cp $< $@

$(LINUX_ARMHF_DEBUG_DST)/root/usr/lib/pkgconfig/libjingle.pc: $(LINUX_ARMHF_DEBUG_SRC)/obj/talk/libjingle_peerconnection_so.ninja
	mkdir -p $(dir $@)
	$(SCRIPTS)/libjingle pkg-config $(LINUX_ARMHF_DEBUG_SRC) $(PKGCONFIG_VERSION) > $@

$(addprefix $(LINUX_ARMHF_DEBUG_DST)/root/usr/include/jingle, $(HEADERS)): $(LINUX_ARMHF_DEBUG_SRC)/libjingle.a $(LINUX_ARMHF_DEBUG_SRC)/obj/talk/libjingle_peerconnection_so.ninja
	mkdir -p $(dir $@)
	cp $(subst $(LINUX_ARMHF_DEBUG_DST)/root/usr/include/jingle, $(SRC_ROOT), $@) $@

$(DST)/$(LINUX_ARMHF_DEBUG_DEB): \
$(addprefix $(LINUX_ARMHF_DEBUG_DST)/root/usr/include/jingle, $(HEADERS)) \
$(LINUX_ARMHF_DEBUG_DST)/root/usr/lib/pkgconfig/libjingle.pc \
$(LINUX_ARMHF_DEBUG_DST)/root/usr/lib/libjingle.a
	rm -rf $@ && cd $(DST) && fpm -s dir -t deb -a armhf -n libjingle-dev -v $(DEB_VERSION)debug --iteration $(DEB_REVISION) -C $(LINUX_ARMHF_DEBUG_DST)/root .

linux_armhf_debug: $(DST)/$(LINUX_ARMHF_DEBUG_DEB)

# linux arm release

$(LINUX_ARMHF_RELEASE_SRC)/libjingle.a $(LINUX_ARMHF_RELEASE_SRC)/obj/talk/libjingle_peerconnection_so.ninja:
	WEBRTC_PROFILE=linux_armv7hf WEBRTC_BUILD=Release $(SCRIPTS)/build -r $(GIT_REVISION)

$(LINUX_ARMHF_RELEASE_DST): $(DST)
	mkdir -p $@

$(LINUX_ARMHF_RELEASE_DST)/root:
	mkdir -p $@

$(LINUX_ARMHF_RELEASE_DST)/root/usr/lib/libjingle.a: $(LINUX_ARMHF_RELEASE_SRC)/libjingle.a
	mkdir -p $(dir $@)
	cp $< $@

$(LINUX_ARMHF_RELEASE_DST)/root/usr/lib/pkgconfig/libjingle.pc: $(LINUX_ARMHF_RELEASE_SRC)/obj/talk/libjingle_peerconnection_so.ninja
	mkdir -p $(dir $@)
	$(SCRIPTS)/libjingle pkg-config $(LINUX_ARMHF_RELEASE_SRC) $(PKGCONFIG_VERSION) > $@

$(addprefix $(LINUX_ARMHF_RELEASE_DST)/root/usr/include/jingle, $(HEADERS)): $(LINUX_ARMHF_RELEASE_SRC)/libjingle.a $(LINUX_ARMHF_RELEASE_SRC)/obj/talk/libjingle_peerconnection_so.ninja
	mkdir -p $(dir $@)
	cp $(subst $(LINUX_ARMHF_RELEASE_DST)/root/usr/include/jingle, $(SRC_ROOT), $@) $@

$(DST)/$(LINUX_ARMHF_RELEASE_DEB): \
$(addprefix $(LINUX_ARMHF_RELEASE_DST)/root/usr/include/jingle, $(HEADERS)) \
$(LINUX_ARMHF_RELEASE_DST)/root/usr/lib/pkgconfig/libjingle.pc \
$(LINUX_ARMHF_RELEASE_DST)/root/usr/lib/libjingle.a
	rm -rf $@ && cd $(DST) && fpm -s dir -t deb -a armhf -n libjingle-dev -v $(DEB_VERSION)release --iteration $(DEB_REVISION) -C $(LINUX_ARMHF_RELEASE_DST)/root .

linux_armhf_release: $(DST)/$(LINUX_ARMHF_RELEASE_DEB)

# android armv7

$(ANDROID_ARMV7_DEBUG_SRC)/libjingle_peerconnection.jar:
	WEBRTC_PROFILE=android_armv7 WEBRTC_BUILD=Debug $(SCRIPTS)/build -r $(GIT_REVISION)

$(ANDROID_ARMV7_DEBUG_DST)/libjingle_peerconnection.jar: $(ANDROID_ARMV7_DEBUG_SRC)/libjingle_peerconnection.jar
	mkdir -p $(dir $@)
	cp $< $@

android_armv7_debug: $(ANDROID_ARMV7_DEBUG_DST)/libjingle_peerconnection.jar

$(ANDROID_ARMV7_RELEASE_SRC)/libjingle_peerconnection.jar:
	WEBRTC_PROFILE=android_armv7 WEBRTC_BUILD=Release $(SCRIPTS)/build -r $(GIT_REVISION)

$(ANDROID_ARMV7_RELEASE_DST)/libjingle_peerconnection.jar: $(ANDROID_ARMV7_RELEASE_SRC)/libjingle_peerconnection.jar
	mkdir -p $(dir $@)
	cp $< $@

android_armv7_release: $(ANDROID_ARMV7_RELEASE_DST)/libjingle_peerconnection.jar
