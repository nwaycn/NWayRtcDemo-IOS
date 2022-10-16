#import <Foundation/Foundation.h>
//#import "RTCMacros.h"

#import "CallStateDelegate.h"

@class RTCSipEngine;

//RTC_OBJC_EXPORT

@interface RTCCallManager : NSObject
    
@property(nonatomic, weak) id<CallStateDelegate> delegate;
    
- (int)CreateCall:(int)accId;
- (void)MakeCall:(int)accId callId:(int)callId calleeUri:(NSString *)calleeUri  offersdp:(NSString*)sdp;
- (void)Accept:(int)callId answersdp:(NSString *)sdp sendAudio:(BOOL)send_audio sendVideo:(BOOL)send_video;
- (void)Update:(int)callId localsdp:(NSString *)sdp enableVideo:(BOOL)enable_video;
- (void)Hangup:(int)callId;
- (void)Reject:(int)callId reason:(int)reasonCode;
- (void)SendDtmfDigits:(int)callId digits:(NSString *)digits;
- (void)UpdateMediaState:(int)callId isOffer:(BOOL)isOffer localsdp:(NSString* )sdp audio:(BOOL)audio video:(BOOL)video;
- (void)RegisterCallStateDelegate:(id<CallStateDelegate>)delegate;

@end
