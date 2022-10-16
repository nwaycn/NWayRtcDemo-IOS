
#import <Foundation/Foundation.h>

@protocol RegistrationStateDelegate<NSObject>

-(void) OnRegistrationProgress:(int)accId;

-(void) OnRegistrationSuccess:(int)accId;

-(void) OnRegistrationCleared:(int)accId;

-(void) OnRegistrationFailed:(int)accId
                withErrorCode:(int)code
              withErrorReason:(NSString *)reason;

-(void) onMessage:(NSString *)fromUri withMessage:(NSString *)message;

@end
