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
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ch.bonventre.systemoverwritepref.preferencesChanged" object:self];
}

-(void)viewDidLoad{

	UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
						   initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                           target:self
                           action:@selector(share:)];

	self.navigationItem.rightBarButtonItem = shareButton;

	[shareButton release];
	[super viewDidLoad];
}

-(IBAction)share:(UIBarButtonItem *)sender{
	NSString *textToShare = @"Click the link below to add LeroyB's beta repository to Cydia!";
    NSURL *myWebsite = [NSURL URLWithString:@"cydia://url/https://cydia.saurik.com/api/share#?source=http://repo.bonventre.ch"];
    NSArray *activityItems = @[textToShare, myWebsite];
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    [self presentViewController:activityViewControntroller animated:true completion:nil];
}

@end
