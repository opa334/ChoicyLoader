include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = ChoicyLoader

ChoicyLoader_FILES = ChoicyLoader.m
ChoicyLoader_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/library.mk
SUBPROJECTS = postinst postrm
include $(THEOS_MAKE_PATH)/aggregate.mk

#using a layout directory somehow doesn't work if the postinst/postrm's are subprojects
internal-stage::
	$(ECHO_NOTHING)cp triggers $(THEOS_STAGING_DIR)/DEBIAN$(ECHO_END)