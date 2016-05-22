//
//  LoginViewController.m
//  DragonHouse
//
//  Created by KangJihun on 2016. 4. 21..
//  Copyright © 2016년 a2big. All rights reserved.
//

#import "LoginViewController.h"
#import "AgreementView.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
///
#import "MainViewController.h"
#import "NaverThirdPartyConstantsForApp.h"
#import "NLoginThirdPartyOAuth20InAppBrowserViewController.h"

////
@interface LoginViewController ()
@property (nonatomic, strong) AppDelegate *appDelegate;
-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification;

//-(void)hideUserInfo:(BOOL)shouldHide;

@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"LoginViewController viewWillAppear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@">>>>>LoginViewController");

    // Do any additional setup after loading the view.
    _thirdPartyLoginConn = [NaverThirdPartyLoginConnection getSharedInstance];
    _thirdPartyLoginConn.delegate = self;

    
    // Observe for the custom notification regarding the session state change.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];

    // Initialize the appDelegate property.
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    KOSession *session = [KOSession sharedSession];
    if (session.isOpen) {
        //로그아웃 처리
        [session close];
    }

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
        [[FBSession activeSession] closeAndClearTokenInformation];
        [self.appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];

    }

    
    
}

- (IBAction)doKakaoLogin:(id)sender {
    NSLog(@"doKakaoLogin..");
    KOSession *session = [KOSession sharedSession];
    if (session.isOpen) {
        //로그아웃 처리
        [session close];
    }

    
    session.presentingViewController = self;
    [session openWithCompletionHandler:^(NSError *error) {
        session.presentingViewController = nil;
        NSLog(@"login3333");
        
        if (!session.isOpen) {
            NSLog(@"Error");
            NSLog(@"You are not logged in.");
            [self requestMe:YES];

        }
        else{
            NSLog(@"OK");
            NSLog(@"You are logged in.");
            [self test];
            [self requestMe:YES];

        }
        
    }];

    
    
}

- (IBAction)doNaverLogin:(id)sender {
    NSLog(@"doNaverLogin..");
    if(_doneSignup == true){
        NSLog(@"OK");
        
        [self requestDeleteToken];
        
    }
    else{
        NSLog(@">>>>>LOGOUT");
        [self requestThirdpartyLogin];
    }
    
    
    //[self showAgreementView];


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

                                          //
                                          [self showAgreementView];
                                          
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

///////
-(void)test{
    [KOSessionTask talkProfileTaskWithCompletionHandler:^(id result, NSError *error) {
        if (error) {
            NSLog(@">>>>>111 %@",[error description]);
        } else {
            _profile = result;
            NSLog(@">>>>>nickName %@", _profile.nickName);
            NSLog(@">>>>>image %@", _profile.profileImageURL);
            
           /*
            NSURL *pictureURL = [NSURL URLWithString:_profile.profileImageURL];
            
            self.profileImage.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
            self.lblFullname.text = _profile.nickName;
            */
            
        }
    }];
}

//다음은 사용자 정보를 얻어오는 예제 코드입니다. 사용자 본인의 아이디와 부가 정보는 KOUser 객체를 통해 반환됩니다.
- (void)requestMe:(BOOL)displayResult {
    [KOSessionTask meTaskWithCompletionHandler:^(id result, NSError *error) {
        if (error) {
            if (error.code == KOErrorCancelled) {
                NSLog(@"requestMe>>>>>%@",@"에러, 다시 로그인해주세요!");
                
            } else {
                NSLog(@"requestMe>>>>>%@",[NSString stringWithFormat:@"에러! code=%d, Signup 을 누르세요", (int) error.code]);
                
            }
            _doneSignup = YES;
        } else {
            if (displayResult) {
                NSLog(@"requestMe>>>>>%@",[result description]);
            }else{
                NSLog(@"requestMe>>>>>%@",@"22222");
            }
            _doneSignup = NO;
            _user = result;
        }
    }];
}


////
-(void)showAgreementView{
    NSLog(@"showAgreementView");
    
    AgreementView *myS = [self.storyboard instantiateViewControllerWithIdentifier:@"AgreementView"];
    [self.navigationController pushViewController:myS animated:NO];
}


-(void)showMainCaheView{
    NSLog(@"showLoginCaheView");
    
    MainViewController *myS = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self.navigationController pushViewController:myS animated:NO];
}


- (void)requestThirdpartyLogin
{
    // NaverThirdPartyLoginConnection의 인스턴스에 서비스앱의 url scheme와 consumer key, consumer secret, 그리고 appName을 파라미터로 전달하여 3rd party OAuth 인증을 요청한다.
    NSLog(@"requestThirdpartyLogin...%@ %@ %@ %@",kConsumerKey, kConsumerSecret, kServiceAppName, kServiceAppUrlScheme);
    
    NaverThirdPartyLoginConnection *tlogin = [NaverThirdPartyLoginConnection getSharedInstance];
    [tlogin setConsumerKey:kConsumerKey];
    [tlogin setConsumerSecret:kConsumerSecret];
    [tlogin setAppName:kServiceAppName];
    [tlogin setServiceUrlScheme:kServiceAppUrlScheme];
    [tlogin requestThirdPartyLogin];
}

- (void)requestAccessTokenWithRefreshToken
{
    NaverThirdPartyLoginConnection *tlogin = [NaverThirdPartyLoginConnection getSharedInstance];
    [tlogin setConsumerKey:kConsumerKey];
    [tlogin setConsumerSecret:kConsumerSecret];
    [tlogin requestAccessTokenWithRefreshToken];
}

- (void)resetToken
{
    [_thirdPartyLoginConn resetToken];
}

- (void)requestDeleteToken
{
    NaverThirdPartyLoginConnection *tlogin = [NaverThirdPartyLoginConnection getSharedInstance];
    [tlogin requestDeleteToken];
}


- (void)didClickGetUserProfileBtn {
    NSLog(@"didClickGetUserProfileBtn...");
    
    if (NO == [_thirdPartyLoginConn isValidAccessTokenExpireTimeNow]) {
        ////[_mainView setResultLabelText:@"로그인 하세요."];
        return;
    }
    
    NSString *urlString = @"https://openapi.naver.com/v1/nid/getUserProfile.xml";  // 사용자 프로필 호출
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSString *authValue = [NSString stringWithFormat:@"Bearer %@", _thirdPartyLoginConn.accessToken];
    
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    NSData *receivedData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:&error];
    NSString *decodingString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    if (error) {
        NSLog(@"Error happened - %@", [error description]);
        /// [_mainView setResultLabelText:[error description]];
    } else {
        NSLog(@"recevied data - %@", decodingString);
        //// [_mainView setResultLabelText:decodingString];
        
        NSXMLParser *xmlParser =  [[NSXMLParser alloc] initWithData:receivedData];
        xmlParser.delegate = self;
        if( [xmlParser parse]){
            NSLog(@"The XML is Parsed.");
        }
        
    }
}
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    NSLog(@"parserDidStartDocument");
}
-(void)parserDidEndDocument:(NSXMLParser *)parser{
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    switch (aNode) {
        case profile_image:
            NSLog(@"profile_image>>%@",string);
            profileURL = string;
            break;
            
        case nickname:
            NSLog(@"nickname>>%@",string);
            nick = string;
            break;
    }
    
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    
    if([elementName isEqualToString:@"profile_image"]) {
        aNode = profile_image;
    }
    else if([elementName isEqualToString:@"nickname"]) {
        aNode = nickname;
    }
    else{
        aNode = invalidNode;
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    // if([elementName isEqualToString:@"profile_image"]){
    
    // }
}
#pragma mark - SampleOAuthConnectionDelegate
- (void) presentWebviewControllerWithRequest:(NSURLRequest *)urlRequest   {
    // FormSheet모달위에 FullScreen모달이 뜰 떄 애니메이션이 이상하게 동작하여 애니메이션이 없도록 함
    
    NLoginThirdPartyOAuth20InAppBrowserViewController *inAppBrowserViewController = [[NLoginThirdPartyOAuth20InAppBrowserViewController alloc] initWithRequest:urlRequest];
    inAppBrowserViewController.parentOrientation = (UIInterfaceOrientation)[[UIDevice currentDevice] orientation];
    [self presentViewController:inAppBrowserViewController animated:NO completion:nil];
}

#pragma mark - OAuth20 deleagate

- (void)oauth20ConnectionDidOpenInAppBrowserForOAuth:(NSURLRequest *)request {
    NSLog(@"oauth20ConnectionDidOpenInAppBrowserForOAuth...");
    
    [self presentWebviewControllerWithRequest:request];
}

- (void)oauth20Connection:(NaverThirdPartyLoginConnection *)oauthConnection didFailWithError:(NSError *)error {
    NSLog(@"%s=[%@]", __FUNCTION__, error);
    //[_mainView setResultLabelText:[NSString stringWithFormat:@"%@", error]];
    
}

- (void)oauth20ConnectionDidFinishRequestACTokenWithAuthCode {
    // [_mainView setResultLabelText:[NSString stringWithFormat:@"OAuth Success!\n\nAccess Token - %@\n\nAccess Token Expire Date- %@\n\nRefresh Token - %@", _thirdPartyLoginConn.accessToken, _thirdPartyLoginConn.accessTokenExpireDate, _thirdPartyLoginConn.refreshToken]];
    
    NSLog(@"%s=[%@]", __FUNCTION__, [NSString stringWithFormat:@"OAuth Success!\n\nAccess Token - %@\n\nAccess Token Expire Date- %@\n\nRefresh Token - %@", _thirdPartyLoginConn.accessToken, _thirdPartyLoginConn.accessTokenExpireDate, _thirdPartyLoginConn.refreshToken]);
    
    
  //  [self.activityindicator stopAnimating];
 //   self.activityindicator.hidden = YES;
 //   self.lblStatus.text = @"Logging you in...";
    _doneSignup = YES;
  //  [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    
    
    [self didClickGetUserProfileBtn];
    
 //   NSLog(@"profile_image222>>%@",profileURL);
  //  self.profileImage.hidden = false;
  //  self.lblFullname.hidden = false;
    
   // NSURL *pURL = [NSURL URLWithString:profileURL];
   // self.profileImage.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:pURL]];
   // self.lblFullname.text = nick;
    
    
}

- (void)oauth20ConnectionDidFinishRequestACTokenWithRefreshToken {
    //    [_mainView setResultLabelText:[NSString stringWithFormat:@"Refresh Success!\n\nAccess Token - %@\n\nAccess sToken ExpireDate- %@", _thirdPartyLoginConn.accessToken, _thirdPartyLoginConn.accessTokenExpireDate ]];
    
    NSLog(@"%s=[%@]", __FUNCTION__, [NSString stringWithFormat:@"Refresh Success!\n\nAccess Token - %@\n\nAccess sToken ExpireDate- %@", _thirdPartyLoginConn.accessToken, _thirdPartyLoginConn.accessTokenExpireDate ]);
    
    
    _doneSignup = YES;
  //  self.lblStatus.text = @"Logging you in...";
  //  [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    // Stop the activity indicator from animating and hide the status label.
  //  [self.activityindicator stopAnimating];
    
    [self didClickGetUserProfileBtn];
    
  //  NSLog(@"profile_image222>>%@",profileURL);
  //  NSURL *pURL = [NSURL URLWithString:profileURL];
   // self.profileImage.hidden = false;
  //  self.lblFullname.hidden = false;
   // self.profileImage.image =[UIImage imageWithData:[NSData //dataWithContentsOfURL:pURL]];
  //  self.lblFullname.text = nick;
    
}
- (void)oauth20ConnectionDidFinishDeleteToken {
    ////[_mainView setResultLabelText:[NSString stringWithFormat:@"로그아웃 완료"]];
    NSLog(@"%s=[%@]", __FUNCTION__, [NSString stringWithFormat:@"로그아웃 완료"]);
    _doneSignup = NO;
    
   // self.activityindicator.hidden = YES;
  //  [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
  //  self.lblStatus.hidden = NO;
  //  self.lblStatus.text = @"You are not logged in.";
  //  self.profileImage.hidden = true;
  //  self.lblFullname.hidden = true;
    
}


@end
