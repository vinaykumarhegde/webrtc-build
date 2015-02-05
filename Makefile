SRC_ROOT:=$(shell pwd)/src
SRC_OUT:=$(SRC_ROOT)/out

DST:=build

ROOT:=$(shell pwd)
SCRIPTS:=$(ROOT)/scripts
HEADERS:=$(shell cat $(SCRIPTS)/libjingle.headers)
PKGCONFIG_VERSION:=1.0.0
DEB_VERSION:=12313123
DEB_REVISION:=1

LINUX_x86_64_SRC:=$(SRC_OUT)/linux_x86_64
LINUX_x86_64_DST:=$(DST)/linux_x86_64
LINUX_x86_64_DEBUG_SRC:=$(LINUX_x86_64_SRC)/Debug
LINUX_x86_64_DEBUG_DST:=$(LINUX_x86_64_DST)/debug
LINUX_x86_64_DEBUG_DEB:=libjingle_$(DEB_VERSION)-debug_$(DEB_REVISION)_amd64.deb

$(DST):
	mkdir -p $@

all: \
$(LINUX_x86_64_DEBUG_DST)/$(LINUX_x86_64_DEBUG_DEB)

clean:
	rm -rf $(SRC_OUT)/*
	rm -rf $(DST)

.phony: all clean

# linux x86_64 debug

$(LINUX_x86_64_DEBUG_SRC)/libjingle.a $(LINUX_x86_64_DEBUG_SRC)/libjingle_peerconnection_so.ninja:
	WEBRTC_OS=linux WEBRTC_ARCH=x86_64 WEBRTC_BUILD=Debug $(SCRIPTS)/build

$(LINUX_x86_64_DEBUG_DST): $(DST)
	mkdir -p $@

$(LINUX_x86_64_DEBUG_DST)/libjingle.pc: $(LINUX_x86_64_DEBUG_SRC)/libjingle_peerconnection_so.ninja
	$(SCRIPTS)/libjingle pkg-config $(LINUX_x86_64_DEBUG_SRC) $(PKGCONFIG_VERSION) > $@

$(LINUX_x86_64_DEBUG_DST)/root:
	mkdir -p $@

$(LINUX_x86_64_DEBUG_DST)/root/usr/lib/libjingle.a: $(LINUX_x86_64_SRC)/Debug/libjingle.a
	mkdir -p $(dir $@)
	cp $< $@

$(LINUX_x86_64_DEBUG_DST)/root/usr/lib/pkconfig/libjingle.pc: $(LINUX_x86_64_DEBUG_DST)/libjingle.pc
	mkdir -p $(dir $@)
	cp $< $@

$(addprefix $(LINUX_x86_64_DEBUG_DST)/root, $(HEADERS)):
	mkdir -p $(dir $@)
	cp $(subst $(LINUX_x86_64_DEBUG_DST)/root, $(SRC_ROOT), $@) $@

$(LINUX_x86_64_DEBUG_DST)/$(LINUX_x86_64_DEBUG_DEB): \
$(addprefix $(LINUX_x86_64_DEBUG_DST)/root, $(HEADERS)) \
$(LINUX_x86_64_DEBUG_DST)/root/usr/lib/pkconfig/libjingle.pc \
$(LINUX_x86_64_DEBUG_DST)/root/usr/lib/libjingle.a
	fpm -s dir -t deb -a x86_64 -n libjingle -v $(DEB_VERSION) --iteration $(DEB_REVISION) $(LINUX_x86_64_DEBUG_DST)/root
