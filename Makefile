include $(THEOS)/makefiles/common.mk

THEOS_DEVICE_IP = 192.168.1.56
# THEOS_DEVICE_IP = local
TARGET = iphone:clang:11.2:10.1.1
ARCHS = arm64
# TARGET = simulator:clang:11.4:11.4
# ARCHS = x86_64
DEBUG = 0
PACKAGE_VERSION = $(THEOS_PACKAGE_BASE_VERSION)

TWEAK_NAME = SystemOverwrite
SystemOverwrite_FILES = Tweak.xm
SystemOverwrite_FRAMEWORKS = UIKit CoreText CoreFoundation

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 backboardd"
SUBPROJECTS += systemoverwritepref
include $(THEOS_MAKE_PATH)/aggregate.mk
