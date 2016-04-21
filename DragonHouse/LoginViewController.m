//
//  LoginViewController.m
//  DragonHouse
//
//  Created by KangJihun on 2016. 4. 21..
//  Copyright © 2016년 a2big. All rights reserved.
//

#import "LoginViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()
@property (nonatomic, strong) AppDelegate *appDelegate;
-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification;

//-(void)hideUserInfo:(BOOL)shouldHide;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Observe for the custom notification regarding the session state change.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];

    // Initialize the appDelegate property.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)doFaceBookLogin:(id)sender {
    NSLog(@"doFaceBookLogin..");
    
    if ([FBSession activeSession].state != FBSessionStateOpen &&
        [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
        NSLog(@"doFaceBookLogin..111111");

        [self.appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
        
    }
    else{
        NSLog(@"doFaceBookLogin..22222");

        // Close an existing session.
        ///[[FBSession activeSession] closeAndClearTokenInformation];
        
    }

    
    
}

- (IBAction)doKakaoLogin:(id)sender {
    NSLog(@"doKakaoLogin..");

}

- (IBAction)doNaverLogin:(id)sender {
    NSLog(@"doNaverLogin..");

}



#pragma mark - Private method implementation

-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification{
    // Get the session, state and error values from the notification's userInfo dictionary.
    NSDictionary *userInfo = [notification userInfo];
    
    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
    NSError *error = [userInfo objectForKey:@"error"];
    
    
    NSLog(@"Logging you in...");
    
    // Handle the session state.
    // Usually, the only interesting states are the opened session, the closed session and the failed login.
    if (!error) {
        // In case that there's not any error, then check if the session opened or closed.
        if (sessionState == FBSessionStateOpen) {
            // The session is open. Get the user information and update the UI.
            
            //            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            //
            //                if (!error) {
            //                    NSLog(@"%@", result);
            //                }
            //
            //            }];
            
            
            [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:@{@"fields": @"first_name, last_name, picture.type(normal), email"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error) {
                                          // Set the use full name.
                                          NSLog(@"%@", [NSString stringWithFormat:@"%@ %@",
                                                        [result objectForKey:@"first_name"],
                                                        [result objectForKey:@"last_name"]
                                                        ]);
                                          
                                          
                                          // Set the e-mail address.
                                          NSLog(@"%@", [result objectForKey:@"email"]);

                                          
                                          
                                         /*
                                          // Get the user's profile picture.
                                          NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                                          self.imgProfilePicture.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
                                          
                                          // Make the user info visible.
                                          [self hideUserInfo:NO];
                                          
                                          // Stop the activity indicator from animating and hide the status label.
                                          self.lblStatus.hidden = YES;
                                          [self.activityindicator stopAnimating];
                                          self.activityindicator.hidden = YES;
                                          */
                                      }
                                      else{
                                          NSLog(@"%@", [error localizedDescription]);
                                      }
                                  }];
            
            
           /// [self.btnToggleLoginState setTitle:@"Logout" forState:UIControlStateNormal];
            
        }
        else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
            // A session was closed or the login was failed. Update the UI accordingly.
          //  [self.btnToggleLoginState setTitle:@"Login" forState:UIControlStateNormal];
          //  self.lblStatus.text = @"You are not logged in.";
           // self.activityindicator.hidden = YES;
            NSLog(@"You are not logged in...");

        }
    }
    else{
        // In case an error has occurred, then just log the error and update the UI accordingly.
        NSLog(@"Error: %@", [error localizedDescription]);
        /*
        [self hideUserInfo:YES];
        [self.btnToggleLoginState setTitle:@"Login" forState:UIControlStateNormal];
        */
    }
}



@end