
#import <Foundation/Foundation.h>
#import "RegistrationManager.h"
#import "CallManager.h"
#import <NWayRtcSipEngine/RTCSipEngine.h>

@interface SipEngine : NSObject
{
}

@property(nonatomic, readonly) RTCSipEngine* rtcSipEngine;

+(SipEngine *)instance;
/*初始化*/
- (int)Initialize;
- (void)Terminate;
- (void)startSipEngine;
- (void)stopSipEngine;
- (CallManager*)getCallManager;
- (RegistrationManager*)getRegistrationManager;
    
@end

