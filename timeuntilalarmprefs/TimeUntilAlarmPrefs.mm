#import <Preferences/Preferences.h>

static const NSBundle *tweakBundle = [NSBundle bundleWithPath:@"/Library/Application Support/TimeUntilAlarm.bundle"];
#define LOCALIZED(str) [tweakBundle localizedStringForKey:str value:@"" table:nil]

#define BITCOIN_ADDRESS @"18Wf4XCPSfd1NVkbhoLeu75CpPmRCAq4rL"

@interface TimeUntilAlarmPrefsListController: PSListController {
	UIView *alert;
	UIView *shadow;
}
@end

@implementation TimeUntilAlarmPrefsListController

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [self loadSpecifiersFromPlistName:@"TimeUntilAlarmPrefs" target:self];
	}
	return _specifiers;
}

- (void)contact {
	NSURL *url = [NSURL URLWithString:@"mailto:ludvigeriksson@icloud.com?subject=TimeUntilAlarm"];
	[[UIApplication sharedApplication] openURL:url];
}

- (void)donatePayPal {
	NSURL *url = [NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=ludvigeriksson%40icloud%2ecom&lc=US&item_name=Donation%20to%20Ludvig%20Eriksson&no_note=0&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHostedGuest"];
	[[UIApplication sharedApplication] openURL:url];
}

- (void)donateBitcoin {
	shadow = [[UIView alloc] initWithFrame:self.view.bounds];
	shadow.userInteractionEnabled = YES;
	shadow.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];

	alert = [[UIView alloc] init];
	alert.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
	alert.layer.cornerRadius = 5;
	alert.clipsToBounds = YES;

	UILabel *title = [[UILabel alloc] init];
	title.font = [UIFont boldSystemFontOfSize:17];
	title.text = LOCALIZED(@"DONATE_BITCOIN");
	[title sizeToFit];
	[alert addSubview:title];

	NSString *bundlePath = @"/Library/MobileSubstrate/DynamicLibraries/TimeUntilAlarmBundle.bundle";
	NSBundle *bundle = [[NSBundle alloc] initWithPath:bundlePath];
	NSString *imagePath = [bundle pathForResource:@"Bitcoin" ofType:@"png"];
	UIImage *image = [UIImage imageWithContentsOfFile:imagePath];

	UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
	[alert addSubview:imageView];

	UILabel *address = [[UILabel alloc] init];
	address.font = [UIFont systemFontOfSize:13];
	address.text = BITCOIN_ADDRESS;
	[address sizeToFit];
	[alert addSubview:address];

	UIView *grayLine = [[UIView alloc] init];
	grayLine.backgroundColor = [UIColor lightGrayColor];
	[alert addSubview:grayLine];

	UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeSystem];
	copyButton.titleLabel.font = [UIFont systemFontOfSize:15];
	[copyButton setTitle:LOCALIZED(@"COPY_TO_CLIPBOARD") forState:UIControlStateNormal];
	[copyButton addTarget:self action:@selector(copyBitcoinAddressToClipboard) forControlEvents:UIControlEventTouchUpInside];
	[copyButton sizeToFit];
	[alert addSubview:copyButton];

	UIView *grayLine2 = [[UIView alloc] init];
	grayLine2.backgroundColor = [UIColor lightGrayColor];
	[alert addSubview:grayLine2];

	UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeSystem];
	dismissButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
	[dismissButton setTitle:LOCALIZED(@"DISMISS") forState:UIControlStateNormal];
	[dismissButton addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
	[dismissButton sizeToFit];
	[alert addSubview:dismissButton];

	CGFloat alertWidth = address.frame.size.width + 20;

	CGRect frame = title.frame;
	frame.origin.x = alertWidth / 2 - frame.size.width / 2;
	frame.origin.y = 20;
	title.frame = frame;

	frame = imageView.frame;
	frame.size.width = alertWidth / 2;
	frame.size.height = frame.size.width;
	frame.origin.x = alertWidth / 2 - frame.size.width / 2;
	frame.origin.y = CGRectGetMaxY(title.frame) + 8;
	imageView.frame = frame;

	frame = address.frame;
	frame.origin.x = alertWidth / 2 - frame.size.width / 2;
	frame.origin.y = CGRectGetMaxY(imageView.frame) + 8;
	address.frame = frame;

	frame = grayLine.frame;
	frame.size.width = alertWidth;
	frame.size.height = 1;
	frame.origin.y = CGRectGetMaxY(address.frame) + 8;
	grayLine.frame = frame;

	frame = copyButton.frame;
	frame.size.width = alertWidth;
	frame.origin.x = alertWidth / 2 - frame.size.width / 2;
	frame.origin.y = CGRectGetMaxY(grayLine.frame) + 8;
	copyButton.frame = frame;

	frame = grayLine2.frame;
	frame.size.width = alertWidth;
	frame.size.height = 1;
	frame.origin.y = CGRectGetMaxY(copyButton.frame) + 8;
	grayLine2.frame = frame;

	frame = dismissButton.frame;
	frame.size.width = alertWidth;
	frame.origin.x = alertWidth / 2 - frame.size.width / 2;
	frame.origin.y = CGRectGetMaxY(grayLine2.frame) + 8;
	dismissButton.frame = frame;

	frame = alert.frame;
	frame.size.height = CGRectGetMaxY(dismissButton.frame) + 8;
	frame.size.width = alertWidth;
	frame.origin.x = self.view.frame.size.width / 2 - alertWidth / 2;
	frame.origin.y = self.view.frame.size.height / 2 - frame.size.height / 2;
	alert.frame = frame;

	alert.alpha = 0.0;
	shadow.alpha = 0.0;

	[self.view addSubview:shadow];
	[self.view addSubview:alert];

	[UIView animateWithDuration:0.25 animations:^{
		alert.alpha = 1.0;
		shadow.alpha = 1.0;
	} completion:nil];
}

- (void)dismissAlert {
	[UIView animateWithDuration:0.25 animations:^{
		alert.alpha = 0.0;
		shadow.alpha = 0.0;
	} completion:^(BOOL finished) {
		[alert removeFromSuperview];
		[shadow removeFromSuperview];
		alert = nil;
		shadow = nil;
	}];
}

- (void)copyBitcoinAddressToClipboard {
	UIPasteboard *pb = [UIPasteboard generalPasteboard];
    [pb setString:BITCOIN_ADDRESS];

    [self dismissAlert];
    [self showCopiedConfirmation];
}

- (void)showCopiedConfirmation {
	UILabel *label = [[UILabel alloc] init];
	label.font = [UIFont systemFontOfSize:17];
	label.textAlignment = NSTextAlignmentCenter;
	label.text = LOCALIZED(@"COPIED");
	[label sizeToFit];

	label.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
	label.layer.cornerRadius = 10;
	label.layer.borderColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;
	label.layer.borderWidth = 1;
	label.clipsToBounds = YES;
	[self.view addSubview:label];

	label.center = self.view.center;
	CGRect newFrame = CGRectInset(label.frame, -50, -20);
	label.frame = CGRectZero;
	label.center = self.view.center;
	CGRect oldFrame = label.frame;
	[UIView animateWithDuration:0.25 animations:^{ label.frame = newFrame; }];

	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		[UIView animateWithDuration:0.25 
						 animations:^{ label.frame = oldFrame; } 
						 completion:^(BOOL finished) { [label removeFromSuperview]; }];
	});
}

@end






@interface TUATimeFormatListController : PSListController
@end

@implementation TUATimeFormatListController

- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [self loadSpecifiersFromPlistName:@"TUATimeFormat" target:self];
    }
    return _specifiers;
}

@end





static CFStringRef TUAPrefsKey = CFSTR("com.ludvigeriksson.timeuntilalarmprefs");
static CFStringRef TUALockScreenHorizontalPositionKey = CFSTR("TUALockScreenHorizontalPosition");
static CFStringRef TUALockScreenVerticalPositionKey = CFSTR("TUALockScreenVerticalPosition");
static CFStringRef settingsChangedNotification = CFSTR("com.ludvigeriksson.timeuntilalarmprefs/settingschanged");


@interface TUALockScreenPositionListController : PSListController
@property (nonatomic) BOOL customHorizontalPositionEnabled;
@property (nonatomic) BOOL customVerticalPositionEnabled;
@property (strong, nonatomic) NSArray *customHorizontalSpecifiers;
@property (strong, nonatomic) NSArray *customVerticalSpecifiers;
@property (strong, nonatomic) PSSpecifier *horizontalGroup;
@property (strong, nonatomic) PSSpecifier *verticalGroup;
@end

@implementation TUALockScreenPositionListController {
	int _customHorizontalPositionIndex;
	int _customVerticalPositionIndex;
	NSString *_horizontalFooter;
	NSString *_verticalFooter;
}

- (void)setCustomHorizontalPositionEnabled:(BOOL)value {
	if (value && !_customHorizontalPositionEnabled) {
		[self.horizontalGroup setProperty:_horizontalFooter forKey:@"footerText"];
		[self reloadSpecifier:self.horizontalGroup animated:YES];
		[self insertContiguousSpecifiers:self.customHorizontalSpecifiers atIndex:_customHorizontalPositionIndex animated:YES];
		_customVerticalPositionIndex += self.customHorizontalSpecifiers.count;
	} else if (_customHorizontalPositionEnabled) {
		[self.horizontalGroup setProperty:@"" forKey:@"footerText"];
		[self reloadSpecifier:self.horizontalGroup animated:YES];
		[self removeContiguousSpecifiers:self.customHorizontalSpecifiers animated:YES];
		_customVerticalPositionIndex -= self.customHorizontalSpecifiers.count;
	}
	_customHorizontalPositionEnabled = value;
}

- (void)setCustomVerticalPositionEnabled:(BOOL)value {
	if (value && !_customVerticalPositionEnabled) {
		[self.verticalGroup setProperty:_verticalFooter forKey:@"footerText"];
		[self reloadSpecifier:self.verticalGroup animated:YES];
		[self insertContiguousSpecifiers:self.customVerticalSpecifiers atIndex:_customVerticalPositionIndex animated:YES];
	} else if (_customVerticalPositionEnabled) {
		[self.verticalGroup setProperty:@"" forKey:@"footerText"];
		[self reloadSpecifier:self.verticalGroup animated:YES];
		[self removeContiguousSpecifiers:self.customVerticalSpecifiers animated:YES];
	}
	_customVerticalPositionEnabled = value;
}

- (id)specifiers {
    if(_specifiers == nil) {
        _specifiers = [self loadSpecifiersFromPlistName:@"TUALockScreenPosition" target:self];
        self.customHorizontalSpecifiers = @[_specifiers[2], _specifiers[3]];
        self.customVerticalSpecifiers = @[_specifiers[6], _specifiers[7]];

		self.horizontalGroup = _specifiers[0];
		self.verticalGroup = _specifiers[4];
    }
    return _specifiers;
}

- (void)setHorizontalPosition:(id)position {
	CFPreferencesAppSynchronize(TUAPrefsKey);
	CFPreferencesSetAppValue(TUALockScreenHorizontalPositionKey, (__bridge CFStringRef)position, TUAPrefsKey);
	CFPreferencesAppSynchronize(TUAPrefsKey);
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), settingsChangedNotification, NULL, NULL, true);

	int horizontalPosition = [position intValue];
	if (horizontalPosition == 0) {
		self.customHorizontalPositionEnabled = YES;
	} else {
		self.customHorizontalPositionEnabled = NO;
	}
}

- (void)setVerticalPosition:(id)position {
	CFPreferencesAppSynchronize(TUAPrefsKey);
	CFPreferencesSetAppValue(TUALockScreenVerticalPositionKey, (__bridge CFStringRef)position, TUAPrefsKey);
	CFPreferencesAppSynchronize(TUAPrefsKey);
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), settingsChangedNotification, NULL, NULL, true);

	int verticalPosition = [position intValue];
	if (verticalPosition == 0) {
		self.customVerticalPositionEnabled = YES;
	} else {
		self.customVerticalPositionEnabled = NO;
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];

	_customHorizontalPositionIndex = 2;
	_customVerticalPositionIndex = 4;

	CGRect screenRect = [[UIScreen mainScreen] bounds];
	int screenWidth = screenRect.size.width;
	int screenHeight = screenRect.size.height;

	_horizontalFooter = [NSString stringWithFormat:LOCALIZED(@"YOUR_SCREEN_IS_X_POINTS_WIDE"), screenWidth];
	_verticalFooter = [NSString stringWithFormat:LOCALIZED(@"YOUR_SCREEN_IS_Y_POINTS_TALL"), screenHeight];

    [self.horizontalGroup setProperty:_horizontalFooter forKey:@"footerText"];
    [self.verticalGroup setProperty:_verticalFooter forKey:@"footerText"];

    int horizontalPosition = 2;
    int verticalPosition = 2;

	CFPreferencesAppSynchronize(TUAPrefsKey);
	if (CFBridgingRelease(CFPreferencesCopyAppValue(TUALockScreenHorizontalPositionKey, TUAPrefsKey))) {
		horizontalPosition = [(id)CFBridgingRelease(CFPreferencesCopyAppValue(TUALockScreenHorizontalPositionKey, TUAPrefsKey)) intValue];
	}
	if (CFBridgingRelease(CFPreferencesCopyAppValue(TUALockScreenVerticalPositionKey, TUAPrefsKey))) {
		verticalPosition = [(id)CFBridgingRelease(CFPreferencesCopyAppValue(TUALockScreenVerticalPositionKey, TUAPrefsKey)) intValue];
	}

	if (horizontalPosition != 0) {
		[self.horizontalGroup setProperty:@"" forKey:@"footerText"];
		[self reloadSpecifier:self.horizontalGroup animated:YES];
		[self removeContiguousSpecifiers:self.customHorizontalSpecifiers animated:YES];
	} else {
		_customVerticalPositionIndex += self.customHorizontalSpecifiers.count;
		_customHorizontalPositionEnabled = YES;
	}
	if (verticalPosition != 0) {
		[self.verticalGroup setProperty:@"" forKey:@"footerText"];
		[self reloadSpecifier:self.verticalGroup animated:YES];
		[self removeContiguousSpecifiers:self.customVerticalSpecifiers animated:YES];
	} else {
		_customVerticalPositionEnabled = YES;
	}

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(applicationWillResignActive)
												 name:UIApplicationDidEnterBackgroundNotification
											   object:[UIApplication sharedApplication]];
}

- (void)applicationWillResignActive {
	// Pop when exiting app because of buggy layout
	[self.navigationController popViewControllerAnimated:NO];
	[[NSNotificationCenter defaultCenter] removeObserver:self
												 	name:UIApplicationDidEnterBackgroundNotification
											   	  object:[UIApplication sharedApplication]];
}

@end

static NSCharacterSet *allowedCharacters = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];

@interface ResigningTextCell : PSEditableTableCell
- (BOOL)textFieldShouldReturn:(UITextField *)textField;
@end

@implementation ResigningTextCell

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if (![allowedCharacters characterIsMember:c]) {
            return NO;
        }
    }
    return YES;
}

@end

// vim:ft=objc