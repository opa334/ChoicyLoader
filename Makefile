include $(THEOS)/makefiles/common.mk

LIBRARY_NAME = ChoicyLoader

ChoicyLoader_FILES = ChoicyLoader.m
ChoicyLoader_CFLAGS = -DTHEOS_LEAN_AND_MEAN # <- this makes theos not link against anything by default (we do not want to link UIKit cause we load system wide)
ChoicyLoader_FRAMEWORKS = CoreFoundation

include $(THEOS_MAKE_PATH)/library.mk
SUBPROJECTS = postinst postrm
include $(THEOS_MAKE_PATH)/aggregate.mk

#using a layout directory somehow doesn't work if the postinst/postrm's are subprojects
internal-stage::
	$(ECHO_NOTHING)cp triggers $(THEOS_STAGING_DIR)/DEBIAN$(ECHO_END)