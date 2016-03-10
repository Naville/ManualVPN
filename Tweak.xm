#import <objc/runtime.h>
#import <substrate.h>
#import <UIKit/UIKit.h>
//NSString* curAppbundleID=[[NSBundle mainBundle] bundleIdentifier];
@interface SBApplication:NSObject{

}
-(id)bundleIdentifier;
@end
@interface VPNBundleController : NSObject {

	char _networkSpinnerVisible;
	char _rootMenuItem;
	char _toggleSwitchInRootMenu;
	char _registered;
	/*VPNConnectionStore* _connectionStore;
	NSNumber* _lastServiceCount;
	PSSpecifier* _passwordSetupSpecifier;
	PSSpecifier* _vpnSpecifier;
	PSSpecifier* _linkVPNSpecifier;
	PSConfirmationSpecifier* _toggleVPNSpecifier;*/

}

/*@property (retain) VPNConnectionStore * connectionStore;                              //@synthesize connectionStore=_connectionStore - In the implementation block
@property (retain) NSNumber * lastServiceCount;                                       //@synthesize lastServiceCount=_lastServiceCount - In the implementation block
@property (retain) PSSpecifier * passwordSetupSpecifier;                              //@synthesize passwordSetupSpecifier=_passwordSetupSpecifier - In the implementation block
@property (retain) PSSpecifier * vpnSpecifier;                                        //@synthesize vpnSpecifier=_vpnSpecifier - In the implementation block
@property (retain) PSSpecifier * linkVPNSpecifier;                                    //@synthesize linkVPNSpecifier=_linkVPNSpecifier - In the implementation block
@property (retain) PSConfirmationSpecifier * toggleVPNSpecifier; */                     //@synthesize toggleVPNSpecifier=_toggleVPNSpecifier - In the implementation block
@property (getter=isNetworkSpinnerVisible) char networkSpinnerVisible;                //@synthesize networkSpinnerVisible=_networkSpinnerVisible - In the implementation block
@property (getter=isRootMenuItem) char rootMenuItem;                                  //@synthesize rootMenuItem=_rootMenuItem - In the implementation block
@property (getter=isToggleSwitchInRootMenu) char toggleSwitchInRootMenu;              //@synthesize toggleSwitchInRootMenu=_toggleSwitchInRootMenu - In the implementation block
@property (getter=isRegistered) char registered;                                      //@synthesize registered=_registered - In the implementation block
-(id)initWithParentListController:(id)Meh;
+(char)networkingIsDisabled;
+(void)disableAirplaneMode;
-(char)isRegistered;
-(void)setRegistered:(char)arg1 ;
-(void)dealloc;
-(char)isNetworkSpinnerVisible;
-(void)setNetworkSpinnerVisible:(char)arg1 ;
-(unsigned)getStatusAndUpdateNetworkSpinnerVisibility;
//-(PSSpecifier *)vpnSpecifier;
//-(PSConfirmationSpecifier *)toggleVPNSpecifier;
-(void)vpnStatusChanged:(id)arg1 ;
-(void)setVPNActive:(BOOL)arg1 ;
-(void)_setVPNActive:(BOOL)arg1 ;
-(void)setVPNActive:(id)arg1 forSpecifier:(id)arg2 ;
-(id)vpnActiveForSpecifier:(id)arg1 ;
//-(void)setToggleVPNSpecifier:(PSConfirmationSpecifier *)arg1 ;
-(void)confirmAirplaneModeDisable:(id)arg1 ;
-(void)cancelAirplaneModeDisable:(id)arg1 ;
//-(PSSpecifier *)linkVPNSpecifier;
//-(void)setLinkVPNSpecifier:(PSSpecifier *)arg1 ;
-(char)isRootMenuItem;
-(void)setLastServiceCount:(NSNumber *)arg1 ;
-(NSNumber *)lastServiceCount;
-(void)setToggleSwitchInRootMenu:(char)arg1 ;
-(char)isToggleSwitchInRootMenu;
//-(void)setVpnSpecifier:(PSSpecifier *)arg1 ;
-(void)vpnConfigurationChanged:(id)arg1 ;
-(void)setRootMenuItem:(char)arg1 ;
-(void)updateVPNSwitchStatus;
//-(VPNConnectionStore *)connectionStore;
//-(void)setConnectionStore:(VPNConnectionStore *)arg1 ;
//-(PSSpecifier *)passwordSetupSpecifier;
//-(void)setPasswordSetupSpecifier:(PSSpecifier *)arg1 ;
-(id)statusForSpecifier:(id)arg1 ;
-(void)unload;
-(id)specifiersWithSpecifier:(id)arg1 ;
-(id)initWithParentListController:(id)arg1 properties:(id)arg2 ;
@end
@interface VPNController : NSObject {

	id _statusSpecifier;
	id _switchSpecifier;
	id _vpnListSeparatorGroupSpecifier;
	id _otherVPNSpecifier;
	NSArray* _cancelSpecifiers;
	NSString* _activeVPNServiceID;
	id _activeVPNSpecifier;
	id _alert;
	unsigned long long _vpnServiceCount;

}
+(id)sharedInstance;
-(void)dealloc;
-(id)init;
-(id)startPersonalConnection:(id)arg1 ;
-(id)startEnterpriseConnection:(id)arg1 ;
-(void)activateVPN:(id)arg1 ;
-(void)updateVPNConfigurationsList;
-(id)specifiers;
-(void)connect;
-(void)formSheetViewWillDisappear;
-(void)willBecomeActive;
-(void)showStatus:(id)arg1 ;
-(void)activateVPN:(id)arg1 ;
@end
/*static BOOL isVPNOn(NSArray* specList){
VPNBundleController* VPBC=[[objc_getClass("VPNBundleController") alloc] init];
for(int i=0;i<[specList count];i++){
	if([[VPBC vpnActiveForSpecifier:[specList objectAtIndex:i]] boolValue]==YES){
		return YES;
	}

}
return NO;
}*/
static void load(NSString* bundleID){
NSDictionary* allowsList=[NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/naville.manualvpn.plist"];
if(bundleID!=nil && allowsList!=nil &&[allowsList.allKeys containsObject:bundleID] &&[[allowsList objectForKey:bundleID] boolValue]==YES ){
NSBundle* VPNPreferences=[NSBundle bundleWithPath:@"/System/Library/PreferenceBundles/VPNPreferences.bundle"];
if([VPNPreferences load]==YES){
	Class VPC=objc_getClass("VPNBundleController");
	if(VPC!=NULL){
		NSLog(@"VPNBundleController Loaded");
		VPNBundleController* VPNBC=[[VPC alloc] initWithParentListController:nil];
		id PSS=[VPNBC valueForKey:@"_vpnSpecifier"];
		if([[VPNBC vpnActiveForSpecifier:PSS] boolValue]==YES){
			   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" 
                                                    message:@"VPN Already Connected" 
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK" 
                                                    otherButtonTitles:nil];
    			[alert show];
    			[alert release];


		}
		else{

			if([VPNBC respondsToSelector:@selector(setVPNActive:)]){
				[VPNBC setVPNActive:YES];
			}
			else if([VPNBC respondsToSelector:@selector(_setVPNActive:)]){
					[VPNBC _setVPNActive:YES];
			}
			else{
    		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" 
                                                    message:@"Failed To Call Connecting Method" 
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK" 
                                                    otherButtonTitles:nil];
    			[alert show];
    			[alert release];

			}
		}
		[VPNBC release];
	}

}
else{
NSLog(@"VPNPreferences.bundle Loading Failed");
			   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ooops" 
                                                    message:@"VPNPreferences.bundle Loading Failed" 
                                                    delegate:nil
                                                    cancelButtonTitle:@"OK" 
                                                    otherButtonTitles:nil];
    			[alert show];
    			[alert release];

}
}
}
%hook SBUIController
- (void)activateApplication:(id)arg1{
	NSLog(@">>>>>>activateApplication With Bundle ID:%@",[arg1 bundleIdentifier]);
	load([arg1 bundleIdentifier]);
	%orig;

}
- (void)activateApplication:(id)arg1 fromIcon:(id)arg2 location:(int)arg3{
	NSLog(@">>>>>>activateApplication:fromIcon:location: With Bundle ID:%@",[arg1 bundleIdentifier]);
	load([arg1 bundleIdentifier]);
	%orig;

}

%end
