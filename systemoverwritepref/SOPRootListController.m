#include "SOPRootListController.h"
#include <spawn.h>
#include <signal.h>

#define PLIST_PATH @"/var/mobile/Library/Preferences/ch.bonventre.systemoverwritepref.plist"

@implementation SOPRootListController

// original made by theos
// - (NSArray *)specifiers {
// 	if (!_specifiers) {
// 		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
// 	}
//
// 	return _specifiers;
// }

- (id)readPreferenceValue:(PSSpecifier *)specifier{
	NSDictionary *s = [NSDictionary dictionaryWithContentsOfFile:PLIST_PATH];
	if (!s[specifier.properties[@"key"]]){
		return specifier.properties[@"default"];
	}
	return s[specifier.properties[@"key"]];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier{
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:PLIST_PATH atomically:YES];
	CFStringRef toPost = (CFStringRef)specifier.properties[@"PostNotification"];
	if (toPost){
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(),
                                         toPost,
                                         NULL,
                                         NULL,
                                         YES);
  }
}

- (id)specifiers{
	if (!_specifiers){
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target: self] retain];
	}
	return _specifiers;
}

- (void)_returnKeyPressed:(NSNotificationCenter *)notification{
    [self.view endEditing:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ch.bonventre.alphachangetextpref.preferencesChanged" object:self];
}

@end
