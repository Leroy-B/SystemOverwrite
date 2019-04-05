
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
    [prefs release];
}


// ########### Tested and are working [start] ###########
// folder name
%hook SBFolder

-(void) setDisplayName:(id)arg1 {
	if(twIsEnabled) {
		arg1 = [arg1 stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [arg1 length])];
		%orig(arg1);
	} else {
		%orig(arg1);
	}
}

%end

// general
%hook UILabel

-(void)setText:(NSString *)arg1 {
	if(twIsEnabled) {
		arg1 = [arg1 stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [arg1 length])];
		%orig(arg1);
	} else {
		%orig(arg1);
	}
}

%end

// App name
%hook SBIconLabelImageParameters

-(NSString *)text {
	if(twIsEnabled) {
		NSString *temp = %orig();
	    return temp = [temp stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
	} else {
		return %orig();
	}
}

%end

// Notification title and content
%hook NCNotificationContentView

-(void)setPrimaryText:(NSString *)text {
	if(twIsEnabled) {
		if (!text) {
	        %orig(text);
	    }
		NSString *temp = text;
		temp = [temp stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
		%orig(temp);
	} else {
		%orig(text);
	}
}

-(void)setSecondaryText:(NSString *)text {
	if(twIsEnabled) {
		if (!text) {
	        %orig(text);
	    }
		NSString *temp = text;
		temp = [temp stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
		%orig(temp);
	} else {
		%orig(text);
	}
}

%end

// settings cell
%hook PSSpecifier

-(void)setName:(NSString *)arg1 {
	if(twIsEnabled) {
		if (!arg1) {
	        %orig(arg1);
	    }
		NSString *temp = arg1;
		temp = [temp stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
		%orig(temp);
	} else {
		%orig(arg1);
	}
}

%end

// general substring
%hook SBUILegibilityLabel

-(NSString *)string {
	if(twIsEnabled) {
		NSString *temp = %orig();
	    return temp = [temp stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
	} else {
		return %orig();
	}
}

-(void)setString:(NSString *)arg1 {
	if(twIsEnabled) {
		if (!arg1) {
			%orig(arg1);
		}
		NSString *temp = arg1;
		temp = [temp stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [temp length])];
		%orig(temp);
	} else {
		%orig(arg1);
	}
}

%end

// list title
%hook UITableViewLabel

-(void)setText:(id)arg1 {
	if(twIsEnabled) {
		arg1 = [arg1 stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [arg1 length])];
		%orig(arg1);
	} else {
		%orig(arg1);
	}
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

%hook UITextField

-(void)setAb_text:(NSString *)arg1 {
	if(twIsEnabled) {
		// NSLog(@"SystemOverwrite LOG: UITextField-setAb_text arg1: %@", arg1);
		arg1 = [arg1 stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [arg1 length])];
		%orig(arg1);
	} else {
		%orig(arg1);
	}
}

-(void)setText:(NSString *)arg1 {
	if(twIsEnabled) {
		// NSLog(@"SystemOverwrite LOG: UITextField-setText arg1: %@", arg1);
		arg1 = [arg1 stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [arg1 length])];
		%orig(arg1);
	} else {
		%orig(arg1);
	}
}

-(void)setPlaceholder:(NSString *)arg1 {
	if(twIsEnabled) {
		// NSLog(@"SystemOverwrite LOG: UITextField-setPlaceholder arg1: %@", arg1);
		arg1 = [arg1 stringByReplacingOccurrencesOfString:twLabelToReplace withString:twLabelToReplaceWith options:NSCaseInsensitiveSearch range:NSMakeRange(0, [arg1 length])];
		%orig(arg1);
	} else {
		%orig(arg1);
	}
}

%end


// ############################# CONSTRUCTOR ### START ####################################

static void preferencesChanged(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo){
    loadPrefs();
}

%ctor {
	@autoreleasepool {
		loadPrefs();
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
