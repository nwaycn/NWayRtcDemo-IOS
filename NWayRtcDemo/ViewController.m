//
//  ViewController.m
//
//  Created by david  on 2019/7/31.
//  Copyright © 2019 NWayRtc. All rights reserved.
//

#import "ViewController.h"
#import <NWayRtcSDK/SipEngineManager.h>
#import <NWayRtcSDK/CallParams.h>
#import <WebRTC/RTCAudioSession.h>
#import <WebRTC/RTCAudioSessionConfiguration.h>
#import <WebRTC/RTCDispatcher.h>
#import "AppDelegate.h"

static NSString* const kARDDefaultSTUNServerUrl =
@"stun:8.135.43.47:19302";
static NSString* const kARDDefaultTURNServerUrl =
@"turn:8.135.43.47:19302";

@interface ViewController () <RTCAudioSessionDelegate>

@end

@implementation ViewController {
    Account *current_account;
    Call *current_call;
}

@synthesize calling_screen_view;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    current_account = nil;
    NSLog(@"=====viewDidLoad===");
    //[[SipEngineManager instance] setSipEngineRegistrationDelegate:self];
    //[[SipEngineManager instance] setSipEngineCallDelegate:self];
    
    calling_screen_view = [self.storyboard instantiateViewControllerWithIdentifier:@"CallingScreenViewController"];
    //[calling_screen_view setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
     /*RTCAudioSessionConfiguration *webRTCConfig =
         [RTCAudioSessionConfiguration webRTCConfiguration];
     webRTCConfig.categoryOptions = webRTCConfig.categoryOptions |
         AVAudioSessionCategoryOptionDefaultToSpeaker;
     [RTCAudioSessionConfiguration setWebRTCConfiguration:webRTCConfig];

     RTCAudioSession *session = [RTCAudioSession sharedInstance];
     [session addDelegate:self];
    
     [RTCDispatcher dispatchAsyncOnType:RTCDispatcherTypeAudioSession
                                 block:^{
      RTCAudioSession *session = [RTCAudioSession sharedInstance];
      [session lockForConfiguration];
      NSError *error = nil;
      if ([session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&error]) {
      } else {
        RTCLogError(@"Error overriding output port: %@",
                    error.localizedDescription);
      }
      [session unlockForConfiguration];
    }];*/
    
     //[self configureAudioSession];
}

-(void) viewWillAppear:(BOOL)animated {
    NSLog(@"=========viewWillAppear:(BOOL)animated========");
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterBackgroundNotification:) name:@"enterBackground" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActiveNotification:) name:@"becomeActive" object:nil];
}

-(void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"enterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"becomeActive" object:nil];
}

-(void)appWillEnterBackgroundNotification:(NSNotification *)notification
{
    NSLog(@"=======appWillEnterBackgroundNotification=====");
}

-(void)appBecomeActiveNotification:(NSNotification *)notification
{
    NSLog(@"=======appBecomeActiveNotification=====");
    [[SipEngineManager instance] setSipEngineRegistrationDelegate:self];
    [[SipEngineManager instance] setSipEngineCallDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"========viewDidAppear:(BOOL)animated======");
    [[SipEngineManager instance] setSipEngineRegistrationDelegate:self];
    [[SipEngineManager instance] setSipEngineCallDelegate:self];
}

- (void)configureAudioSession {
  RTCAudioSessionConfiguration *configuration =
      [[RTCAudioSessionConfiguration alloc] init];
  configuration.category = AVAudioSessionCategoryAmbient;
  configuration.categoryOptions = AVAudioSessionCategoryOptionDuckOthers;
  configuration.mode = AVAudioSessionModeDefault;

  RTCAudioSession *session = [RTCAudioSession sharedInstance];
  [session lockForConfiguration];
  BOOL hasSucceeded = NO;
  NSError *error = nil;
  if (session.isActive) {
    hasSucceeded = [session setConfiguration:configuration error:&error];
  } else {
    hasSucceeded = [session setConfiguration:configuration
                                      active:YES
                                       error:&error];
  }
  if (!hasSucceeded) {
    RTCLogError(@"Error setting configuration: %@", error.localizedDescription);
  }
  [session unlockForConfiguration];
}

#pragma mark - RTCAudioSessionDelegate

- (void)audioSessionDidStartPlayOrRecord:(RTCAudioSession *)session {
  // Stop playback on main queue and then configure WebRTC.
  [RTCDispatcher dispatchAsyncOnType:RTCDispatcherTypeMain
                               block:^{
                                // if (self.mainView.isAudioLoopPlaying) {
                                   //RTCLog(@"Stopping audio loop due to WebRTC start.");
                                   //[self.audioPlayer stop];
                                 //}
                                // RTCLog(@"Setting isAudioEnabled to YES.");
                                 session.isAudioEnabled = YES;
                               }];
}

- (void)audioSessionDidStopPlayOrRecord:(RTCAudioSession *)session {
  // WebRTC is done with the audio session. Restart playback.
  [RTCDispatcher dispatchAsyncOnType:RTCDispatcherTypeMain
                               block:^{
    RTCLog(@"audioSessionDidStopPlayOrRecord");
    //[self restartAudioPlayerIfNeeded];
  }];
}
- (void)OnCallConnected:(Call *)call withVideoChannel:(BOOL)video_enabled withDataChannel:(BOOL)data_enabled {
    [calling_screen_view setCallingMode:video_enabled? kVideoAnswered : kAudioAnswered];
}

- (void)OnCallEnded:(Call *)call {
    [calling_screen_view setCallingStatusLabel:NSLocalizedString(@"Hangup", @"")];
    [calling_screen_view stopCallingUI];
}

- (void)OnCallFailed:(Call *)call withErrorCode:(int)error_code reason:(NSString *)reason {
    [calling_screen_view setCallingStatusLabel:[NSString stringWithFormat:NSLocalizedString(@"Call failed, [%d]",@""),error_code]];
    if(calling_screen_view && [calling_screen_view isVideoCalling:call])
    {
        [calling_screen_view stopVideo];
    }
    
    [calling_screen_view setCurrentCall:nil];
    [calling_screen_view stopCallingUI];
}

- (void)OnCallPaused:(Call *)call {
    
}

/*外呼正在处理*/
- (void)OnCallProcessing:(Call *)call {
    [calling_screen_view setCallingStatusLabel:NSLocalizedString(@"Calling ...", @"")];
}

- (void)OnUpdatedByRemote:(Call *)call has_video:(BOOL)video {

}

- (void)OnUpdatingByLocal:(Call *)call has_video:(BOOL)video {

}

- (void)OnCallResume:(Call *)call {
    
}

/*对方振铃*/
- (void)OnCallRinging:(Call *)call {
    [calling_screen_view setCallingStatusLabel:NSLocalizedString(@"Ringing", @"")];
}

- (void)OnNewIncomingCall:(Call *)call caller:(NSString *)caller video_call:(BOOL)video_call deviceType:(NSString*)callerDeviceType {
    [calling_screen_view setCurrentCall:call];
    [calling_screen_view setCallingMode:video_call? kVideoRinging : kAudioRinging];
    [self showCallingViewController:video_call playRinging:YES];
}

- (void)OnNewOutgoingCall:(Call *)call caller:(NSString *)caller video_call:(BOOL)video_call {
    [calling_screen_view setCurrentCall:call];
    [calling_screen_view setCallingMode:video_call? kVideoCalling : kAudioCalling];
    [self showCallingViewController:video_call playRinging:NO];
}

- (void)OnDtmfEvent:(int)callId dtmf:(int)dtmf duration:(int)duration up:(int)up
{
    
}

- (void)OnUpdatedByLocal:(Call *)call has_video:(BOOL)video {
    
}


-(void)showCallingViewController:(BOOL)video_call
                     playRinging:(BOOL)play_ringing
{
    [self presentViewController:(UIViewController *)calling_screen_view animated:YES completion:nil];
    
    if(play_ringing)
    {
        //[[UserSoundsPlayerUtil instance] playRinging];
        //[[UserSoundsPlayerUtil instance] playVibrate:YES];
        [calling_screen_view setCallingMode:video_call? kVideoRinging : kAudioRinging];
    }
}

- (void)OnRegistrationFailed:(Account *)account withErrorCode:(int)code withErrorReason:(NSString *)reason {
    NSLog(@"OnRegistrationFailed=======:%d:%@", code, reason);
}

- (void)OnRegistrationCleared:(Account *)account {
}

- (void)OnRegistrationProgress:(Account *)account {
    
}

-(void)OnRegistrationSuccess:(Account *)account {
    NSLog(@"OnRegistrationSuccess");
}

- (void)OnMessage:(NSString *)fromUri withMessage:(NSString *)message {
    NSLog(@"OnMessage====%@", message);
}


-(void)onMessage:(NSString *)fromUri withMessage:(NSString *)message {
    
}

-(void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize {
    CGSize cGSize = {0, 0};
    return cGSize;
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    
}

- (void)setNeedsFocusUpdate {
    
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    return true;
}

- (void)updateFocusIfNeeded {
    
}

- (IBAction)RegisterButter:(id)sender {
    
    /*AccountConfig *accountConfig = [[AccountConfig alloc] init];
    accountConfig.username = @"1008";
    accountConfig.password = @"2345";
    accountConfig.server = @"120.24.192.241";
    accountConfig.proxy = @"120.24.192.241";
    accountConfig.trans_type = kTCP;
    accountConfig.display_name = @"1005";
    accountConfig.usePushNotification = FALSE;
    accountConfig.display_name = @"1005";
    accountConfig.pn_providers = @"apns";
    accountConfig.pn_prid = @"1005";
    accountConfig.pn_param = @"default";*/
    
    /*AccountConfig *accountConfig = [[AccountConfig alloc] init];
    accountConfig.username = @"1255";
    accountConfig.password = @"4321";
    accountConfig.server = @"222.211.83.169:5060";
    accountConfig.proxy = @"222.211.83.186:5060";
    accountConfig.trans_type = kTCP;
    accountConfig.display_name = @"testDemo";*/
    
    /*AccountConfig *accountConfig = [[AccountConfig alloc] init];
    accountConfig.username = @"1005";
    accountConfig.password = @"4123";
    accountConfig.server = @"39.108.167.93:5770";
    accountConfig.proxy = @"39.108.167.93:5770";
    accountConfig.trans_type = kTCP;
    accountConfig.display_name = @"1005";*/
    
   
    //AppDelegate *appDelegate = ((AppDelegate *)[UIApplication //sharedApplication].delegate);
    [[SipEngineManager instance] sendMessage:@"1005" withLocalUri:@"1006" withMessage:@"UNLOCK"];
    //if(appDelegate.current_account == NULL) {
        //current_account = [[SipEngineManager instance] //registerSipAccount:accountConfig];
    //} else {
        //[current_account refreshRegister];
    //}
}

- (IBAction)CallButter:(id)sender {
    CallParams *callParams = [[CallParams alloc]init];
    [callParams addIceServer:kARDDefaultSTUNServerUrl username:@"" credential:@""];
    [callParams addIceServer:kARDDefaultTURNServerUrl username:@"websip" credential:@"websip"];
    RTCVideoCodecInfo *videoCodecInfo = [[RTCVideoCodecInfo alloc] initWithName:@"H264 (Baseline)"];
    [callParams storeVideoCodecConfig:videoCodecInfo];
    callParams.isVideoCall = TRUE;
    
    //89005 80707
    AppDelegate *appDelegate = ((AppDelegate *)[UIApplication sharedApplication].delegate);
    //Call* current_call =
    [[SipEngineManager instance] makeCall:appDelegate.current_account.accId calleeUri:@"1003" callParams:callParams];
}

- (IBAction)SettingsButton:(id)sender {
    ARDSettingsViewController *settingsController =
    [[ARDSettingsViewController alloc] initWithStyle:UITableViewStyleGrouped
                                       settingsModel:[[CallParams alloc] init]
                                       accountConfig:[[AccountConfig alloc] init]
    ];
    
    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:settingsController];
    [self presentViewControllerAsModal:navigationController];
}

- (void)presentViewControllerAsModal:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

@end
