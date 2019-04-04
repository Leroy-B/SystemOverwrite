include $(THEOS)/makefiles/common.mk

ARCHS = arm64

BUNDLE_NAME = systemoverwritepref
systemoverwritepref_FILES = SOPRootListController.m
systemoverwritepref_INSTALL_PATH = /Library/PreferenceBundles
systemoverwritepref_FRAMEWORKS = UIKit
systemoverwritepref_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/systemoverwritepref.plist$(ECHO_END)
