export ARCHS = armv7 arm64
export TARGET = iphone:clang:latest:latest

PACKAGE_VERSION = 0.0.1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = HomeCardIconLabel
HomeCardIconLabel_FILES = Tweak.xm
HomeCardIconLabel_FRAMEWORKS = UIKit CoreGraphics

include $(THEOS_MAKE_PATH)/tweak.mk

BUNDLE_NAME = HomeCardIconLabelBundle
HomeCardIconLabelBundle_INSTALL_PATH = /Library/Application Support/HomeCardIconLabel

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 SpringBoard"
