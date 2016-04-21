//
//  AppDelegate.h
//  DragonHouse
//
//  Created by KangJihun on 2016. 4. 15..
//  Copyright © 2016년 a2big. All rights reserved.
//

#import <UIKit/UIKit.h>
//facebook login
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//facebook login
-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI;

@end

