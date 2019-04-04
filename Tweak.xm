
#define PLIST_PATH @"/var/mobile/Library/Preferences/ch.bonventre.systemoverwritepref.plist"

static bool twIsEnabled = NO;
static NSString *twLabelToReplace = @"";
static NSString *twLabelToReplaceWith = @"";

static void loadPrefs() {
    // storing in a key and value fashon for easy access
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
    if(prefs){
        twIsEnabled				= ([prefs objectForKey:@"pfIsTweakEnabled"] ? [[prefs objectForKey:@"pfIsTweakEnabled"] boolValue] : twIsEnabled);
		twLabelToReplace    	= ([prefs objectForKey:@"pfLabelToReplace"] ? [[prefs objectForKey:@"pfLabelToReplace"] description] : twLabelToReplace);
		twLabelToReplaceWith    = ([prefs objectForKey:@"pfLabelToReplaceWith"] ? [[prefs objectForKey:@"pfLabelToReplaceWith"] description] : twLabelToReplaceWith);
    }
	//NSLog(@"AlwaysRemindMe LOG: after prefs: %@", prefs);
    [prefs release];
}


// ########### Tested and are working [start] ###########
// folder name
%hook SBFolder

-(void) setDisplayName:(id)arg1 {
	if(twIsEnabled) {
		// NSLog(@"SystemOverwrite LOG: SBFolder arg1: %@", arg1);
		arg1 = [arg1 stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [arg1 length])];
	}
	%orig(arg1);
}

%end

// general
%hook UILabel

-(void)setText:(NSString *)arg1 {
	// NSLog(@"SystemOverwrite LOG: UILabel arg1: %@", arg1);
	if(twIsEnabled) {
		// arg1 = [arg1 stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [arg1 length])];
	}
	%orig(arg1);
}

%end

// App name
%hook SBIconLabelImageParameters

-(NSString *)text {
	NSString *temp = %orig();
	// NSLog(@"SystemOverwrite LOG: SBIconLabelImageParameters text: %@", temp);
    return temp = [temp stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
}

%end

// Notification title and content
%hook NCNotificationContentView

-(void)setPrimaryText:(NSString *)text {
	// NSLog(@"SystemOverwrite LOG: setPrimaryText text: %@", text);
    if (!text) {
        %orig(text);
        return;
    }
	NSString *temp = text;
	temp = [temp stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
	%orig(temp);
}

-(void)setSecondaryText:(NSString *)text {
	// NSLog(@"SystemOverwrite LOG: setSecondaryText text: %@", text);
    if (!text) {
        %orig(text);
        return;
    }
	NSString *temp = text;
	temp = [temp stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
	%orig(temp);
}

%end
// ########### Tested and are working [end] ###########


// ########### This seems unneeded as all of my findings are also within UILabel ###########
// %hook UIButtonLabel
//
// -(void)setText:(NSString *)arg1 {
// 	NSLog(@"alphaChangeText LOG: UIButtonLabel arg1: %@", arg1);
// 	if(twIsEnabled) {
// 		arg1 = [arg1 stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [arg1 length])];
// 	}
// 	%orig(arg1);
// }
//
// %end
// ########### This seems unneeded as all of my findings are also within UILabel ###########

%hook PSSpecifier

-(NSString *)name {
	NSString *temp = %orig();
	NSLog(@"SystemOverwrite LOG: PSSpecifier name: %@", temp);
    return temp = [temp stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
}

%end

// ############################# CONSTRUCTOR ### START ####################################

static void preferencesChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    loadPrefs();
	NSLog(@"SystemOverwrite LOG: 'loadPrefs' called in 'preferencesChanged'");
}

%ctor {
	@autoreleasepool {
		// load the saved preferences from the plist
		loadPrefs();
		// listen for changes to settings
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
			NULL,
			(CFNotificationCallback)preferencesChanged,
			CFSTR("ch.bonventre.systemoverwritepref.preferencesChanged"),
			NULL,
			CFNotificationSuspensionBehaviorDeliverImmediately
		);
	}
}

// ############################# CONSTRUCTOR ### END ####################################
