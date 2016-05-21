//
//  LoginViewController.h
//  DragonHouse
//
//  Created by KangJihun on 2016. 4. 21..
//  Copyright © 2016년 a2big. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>
#import "NaverThirdPartyLoginConnection.h"

@interface LoginViewController : UIViewController<NaverThirdPartyLoginConnectionDelegate>{
    BOOL _doneSignup;
    KOUser *_user;
    KOTalkProfile *_profile;
    
    NaverThirdPartyLoginConnection *_thirdPartyLoginConn;
    BOOL                elementFoundPortFolio;
    
    
    enum nodes {profile_image = 1, nickname = 2, invalidNode = -1};
    enum nodes aNode;
    
    NSString *profileURL;
    NSString *nick;

}


- (IBAction)doFaceBookLogin:(id)sender;
- (IBAction)doKakaoLogin:(id)sender;
- (IBAction)doNaverLogin:(id)sender;

@end
