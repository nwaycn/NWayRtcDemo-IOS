#import <Foundation/Foundation.h>
#import <NWayRtcSipEngine/CallStateDelegate.h>>
#import "Call.h"
#import "SipEngineDelegate.h"
#import <WebRTC/RTCPeerConnectionFactory.h>
#import <NWayRtcSipEngine/RTCCallManager.h>

@interface CallManager : NSObject<CallStateDelegate>

@property(nonatomic, strong) RTCPeerConnectionFactory *factory;

@property(nonatomic, weak) id<SipEngineUICallDelegate> callDelegate;
    
+(CallManager *)instance;
- (instancetype)initWithRtcCallManager:(RTCCallManager *)callManager;

- (Call*)createCall:(int)accId;
- (void)makeCall:(int)accId callId:(int)callId
      calleeUri:(NSString *)calleeUri  offersdp:(NSString*)sdp;
- (void)accept:(int)callId answersdp:(NSString* )sdp sendAudio:(BOOL)send_audio sendVideo:(BOOL)send_video;
- (void)update:(int)callId localsdp:(NSString* )sdp enableVideo:(BOOL)enable_video;
- (void)hangup:(int)callId;
- (void)hangupAllCall;
- (void)reject:(int)callId reason:(int)reasonCode;
- (void)registerCall:(Call *)call;
- (void)unregisterCall:(Call *)call;
- (BOOL)InCalling;
- (void)sendDtmfDigits:(int)callId digits:(NSString*)digits;
- (void)updateMediaState:(int)callId isOffer:(BOOL)isOffer localsdp:(NSString* )sdp audio:(BOOL)audio video:(BOOL)video;
- (void)registerUICallStateDelegate: (id<SipEngineUICallDelegate>)delegate;

@end
