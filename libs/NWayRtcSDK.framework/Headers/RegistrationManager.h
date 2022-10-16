#import <Foundation/Foundation.h>
#import <NWayRtcSipEngine/RegistrationStateDelegate.h>
#import "Account.h"
#import "SipEngineDelegate.h"
#import <NWayRtcSipEngine/RTCRegistrationManager.h>

@interface RegistrationManager : NSObject<RegistrationStateDelegate>
    
@property(nonatomic, weak) id<SipEngineUIRegistrationDelegate> registrationDelegate;
 
+(RegistrationManager *)instance;

- (instancetype)initWithRtcRegistrationManager:(RTCRegistrationManager *)registrationManager;

- (Account*)createAccount;
- (int)makeRegister: (AccountConfig *)accountConfig;
- (void)makeDeRegister: (int)accId;
- (void)registerAccount: (Account *)account;
- (void)unregisterAccount: (Account *)account;
- (void)refreshRegistration: (int)accId;
- (void)registerUIRegistrationDelegate: (id<SipEngineUIRegistrationDelegate>)delegate;
- (void)deRegisterRegistrationDelegate;
- (void)setNetworkReachable: (BOOL)yesno;
- (void)sendMessage:(NSString *)peerUri withLocalUri:(NSString *)localUri withMessage:(NSString *)message;
    
@end
