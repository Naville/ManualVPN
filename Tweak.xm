#import <objc/runtime.h>
#import <substrate.h>
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
-(void)activateVPN:(id)arg1 ;
-(void)updateVPNConfigurationsList;
-(id)specifiers;
-(void)formSheetViewWillDisappear;
-(void)willBecomeActive;
-(void)showStatus:(id)arg1 ;
-(void)activateVPN:(id)arg1 ;
@end

static void load(){
NSBundle* VPNPreferences=[NSBundle bundleWithPath:@"/System/Library/PreferenceBundles/VPNPreferences.bundle"];
if([VPNPreferences load]==YES){
Class VPB=objc_getClass("VPNController");
if(VPB!=NULL){
NSLog(@"VPNController Loaded");
}
VPNController* VNC=[[VPB alloc] init];
[VNC updateVPNConfigurationsList];
NSArray* sps=[VNC specifiers];
	NSOperatingSystemVersion ios9_0_1 = (NSOperatingSystemVersion){9, 0, 1};
   if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ios9_0_1]) {
      [VNC startPersonalConnection:[sps objectAtIndex:0]];
   } else {
[VNC activateVPN:[sps objectAtIndex:0]];
   }

}
else{
NSLog(@"VPNPreferences.bundle Loading Failed");
}
}


void __attribute__((constructor)) SaitoAsuka(){
NSString* bundleID=[[NSBundle mainBundle] bundleIdentifier];
NSArray* allowsList=[NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/naville.manualvpn.plist"].allKeys;
if(bundleID!=nil && allowsList!=nil &&[allowsList containsObject:bundleID]){
	load();
}

}
