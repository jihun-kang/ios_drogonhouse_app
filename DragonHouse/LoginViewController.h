//
//  LoginViewController.h
//  DragonHouse
//
//  Created by KangJihun on 2016. 4. 21..
//  Copyright © 2016년 a2big. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface LoginViewController : UIViewController{
    BOOL _doneSignup;
    KOUser *_user;
    KOTalkProfile *_profile;
    
}


- (IBAction)doFaceBookLogin:(id)sender;
- (IBAction)doKakaoLogin:(id)sender;
- (IBAction)doNaverLogin:(id)sender;

@end
