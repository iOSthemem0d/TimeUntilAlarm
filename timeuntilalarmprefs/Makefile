CFLAGS = -fobjc-arc
ARCHS = armv7 armv7s arm64

include theos/makefiles/common.mk

BUNDLE_NAME = TimeUntilAlarmPrefs
TimeUntilAlarmPrefs_FILES = TimeUntilAlarmPrefs.mm
TimeUntilAlarmPrefs_INSTALL_PATH = /Library/PreferenceBundles
TimeUntilAlarmPrefs_FRAMEWORKS = UIKit CoreGraphics
TimeUntilAlarmPrefs_PRIVATE_FRAMEWORKS = Preferences
TimeUntilAlarmPrefs_LIBRARIES = colorpicker

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/TimeUntilAlarmPrefs.plist$(ECHO_END)
