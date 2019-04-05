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

- (id)readPreferenceValue:(PSSpecifier *)specifier {
	NSDictionary *s = [NSDictionary dictionaryWithContentsOfFile:PLIST_PATH];
	if (!s[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
	return s[specifier.properties[@"key"]];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
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

- (id)specifiers {
	if (!_specifiers){
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target: self] retain];
	}
	return _specifiers;
}

- (void)_returnKeyPressed:(NSNotificationCenter *)notification {
    [self.view endEditing:YES];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"ch.bonventre.systemoverwritepref.preferencesChanged" object:self];
}

-(void)viewDidLoad {

	UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
						   initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                           target:self
                           action:@selector(share:)];

	self.navigationItem.rightBarButtonItem = shareButton;

	[shareButton release];
	[super viewDidLoad];
}

-(IBAction)share:(UIBarButtonItem *)sender {
	NSString *textToShare = @"Click the link below to add LeroyB's beta repository to Cydia!";
    NSURL *myWebsite = [NSURL URLWithString:@"cydia://url/https://cydia.saurik.com/api/share#?source=http://repo.bonventre.ch"];
    NSArray *activityItems = @[textToShare, myWebsite];
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    [self presentViewController:activityViewControntroller animated:true completion:nil];
}


-(void)showTwitter {
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=IDEK_a_Leroy"] options:@{} completionHandler:nil];
	else [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/IDEK_a_Leroy"] options:@{} completionHandler:nil];
}

-(void)showReddit {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.reddit.com/user/IDEK_a_Leroy"] options:@{} completionHandler:nil];
}

-(void)showSourceCode {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Leroy-B/SystemOverwrite"] options:@{} completionHandler:nil];
}

-(void)showBitcoin {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	pasteboard.string = @"1EZATpr8i4N5XaR9bfCwPHAK6DB2s19uwN";
	UIAlertController * alert = [UIAlertController
			alertControllerWithTitle:@"SystemOverwrite: INFO"
							 message:@"My Bitcoin address has been copied to your clipboard, all you have to do is paste it. Thank you for your donation! :)"
					  preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* okButton = [UIAlertAction
				actionWithTitle:@"OK"
						  style:UIAlertActionStyleDefault
						handler:^(UIAlertAction * action){
							//
						}];
	[alert addAction:okButton];
	[self presentViewController:alert animated:YES completion:nil];
	[alert release];
}

-(void)showMonero {
	UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
	pasteboard.string = @"42jBMo7NpyYUoPU3qdu7x6cntT3ez2da5TxKTwZVX9eZfwBA6XzeQEFcTxBukNUYyaGtgvdKtLyz72udsnRo3hFhLYPo37L";
	UIAlertController * alert = [UIAlertController
			alertControllerWithTitle:@"SystemOverwrite: INFO"
							 message:@"My Monero address has been copied to your clipboard, all you have to do is paste it. Thank you for your donation! :)"
					  preferredStyle:UIAlertControllerStyleAlert];
	UIAlertAction* okButton = [UIAlertAction
				actionWithTitle:@"OK"
						  style:UIAlertActionStyleDefault
						handler:^(UIAlertAction * action){
							//
						}];
	[alert addAction:okButton];
	[self presentViewController:alert animated:YES completion:nil];
	[alert release];
}

-(void)showPayPal {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=YFSWZBQM8V3C8"] options:@{} completionHandler:nil];
}

-(void)respring {
	// _returnKeyPressed();
	pid_t pid;
	int status;
	const char* argv[] ={"killall", "backboardd", NULL};
	posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char* const*)argv, NULL);
	waitpid(pid, &status, WEXITED);
}

@end
