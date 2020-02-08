include $(THEOS)/makefiles/common.mk

TOOL_NAME = postinst

postinst_FILES = main.m
postinst_CFLAGS += -fvisibility=hidden -DPOSTINST -fobjc-arc
postinst_FRAMEWORKS = CoreFoundation
postinst_INSTALL_PATH = /DEBIAN

include $(THEOS_MAKE_PATH)/tool.mk

include $(THEOS_MAKE_PATH)/aggregate.mk