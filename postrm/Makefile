include $(THEOS)/makefiles/common.mk

TOOL_NAME = postrm

postrm_FILES = main.m
postrm_CFLAGS += -fvisibility=hidden -DPOSTRM -fobjc-arc
postrm_FRAMEWORKS = CoreFoundation
postrm_INSTALL_PATH = /DEBIAN

include $(THEOS_MAKE_PATH)/tool.mk

include $(THEOS_MAKE_PATH)/aggregate.mk