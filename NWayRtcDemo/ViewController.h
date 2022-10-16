//
//  ViewController.h
//
//  Created by david  on 2019/7/31.
//  Copyright © 2019 NWayRtc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NWayRtcSDK/SipEngineDelegate.h>
#import "ARDSettingsViewController.h"
#import "CallingScreenViewController.h"

@interface ViewController : UIViewController<SipEngineUICallDelegate, SipEngineUIRegistrationDelegate>

@property(nonatomic) CallingScreenViewController *calling_screen_view;

@property (weak, nonatomic) IBOutlet UITextField *UserNameText;
@property (weak, nonatomic) IBOutlet UITextField *PeerNameText;

- (IBAction)RegisterButter:(id)sender;
- (IBAction)CallButter:(id)sender;
- (IBAction)SettingsButton:(id)sender;

@end

