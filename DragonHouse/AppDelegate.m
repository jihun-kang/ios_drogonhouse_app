//
//  AppDelegate.m
//  DragonHouse
//
//  Created by KangJihun on 2016. 4. 15..
//  Copyright © 2016년 a2big. All rights reserved.
//

#import "AppDelegate.h"
#import <KakaoOpenSDK/KakaoOpenSDK.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    UIStoryboard *storyboard = nil;
    UIViewController *initialViewController = nil;
    CGRect iOSDeviceScreenSize = [[UIScreen mainScreen] bounds]; //스크린에 대한 모든 정보
    NSLog(@"iOSDeviceScreenSize.height: %f %f",iOSDeviceScreenSize.size.height, ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]));

    
    if ( iOSDeviceScreenSize.size.height == 568 ){
        //  #ifdef DEUBG
        NSLog(STORY_BOARD_IPHONE_5);
        //   #endif
        storyboard = [UIStoryboard storyboardWithName:STORY_BOARD_IPHONE_5 bundle:nil];
       /// [info setCurDeviceType:DEVICE_IPHONE_5];
        
    }
    else if ( iOSDeviceScreenSize.size.height == 667 ){
#ifdef DEBUG
        NSLog(STORY_BOARD_IPHONE_6);
#else
        NSLog(@"else....%@", STORY_BOARD_IPHONE_6);
#endif
        
        
        storyboard = [UIStoryboard storyboardWithName:STORY_BOARD_IPHONE_6 bundle:nil];
      //  [info setCurDeviceType:DEVICE_IPHONE_6];
        
    }
    else if ( iOSDeviceScreenSize.size.height == 736 ){
        //  #ifdef DEUBG
        NSLog(STORY_BOARD_IPHONE_6_PLUS);
        //   #endif
        storyboard = [UIStoryboard storyboardWithName:STORY_BOARD_IPHONE_6_PLUS bundle:nil];
     //   [info setCurDeviceType:DEVICE_IPHONE_6_PLUS];
        
    }
    else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        // The iOS device = iPad
        NSLog(@"Loading ipad storyboard");
        // Instantiate a new storyboard object using the storyboard file named Storyboard_iPhone35
        storyboard = [UIStoryboard storyboardWithName:STORY_BOARD_IPAD bundle:nil];
    ///    [info setCurDeviceType:DEVICE_IPAD];
        
    }
    
    else{
        //  #ifdef DEUBG
        NSLog(STORY_BOARD_IPHONE_5);
        //   #endif
        storyboard = [UIStoryboard storyboardWithName:STORY_BOARD_IPHONE_5 bundle:nil];
     //   [info setCurDeviceType:DEVICE_IPHONE_5];
        
    }
    
    initialViewController = [storyboard instantiateInitialViewController];
    
    // 화면크기로 윈도우 생성
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // window의 rootViewController를 스토리보드의 initial view controller로 설정
    self.window.rootViewController = initialViewController;
    
    // 윈도우 보이기
    [self.window makeKeyAndVisible];
    
    
    // Override point for customization after application launch.
    return YES;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


////facebook login
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {
        [self openActiveSessionWithPermissions:nil allowLoginUI:NO];
    }
    
    [FBAppCall handleDidBecomeActive];

}

////facebook login
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([KOSession isKakaoAccountLoginCallback:url]) {
        return [KOSession handleOpenURL:url];
    }
    else{
        return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
    }
}


////facebook login
#pragma mark - Public method implementation
-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI{
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:allowLoginUI
                                  completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                                      // Create a NSDictionary object and set the parameter values.
                                      NSDictionary *sessionStateInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                                                        session, @"session",
                                                                        [NSNumber numberWithInteger:status], @"state",
                                                                        error, @"error",
                                                                        nil];
                                      
                                      // Create a new notification, add the sessionStateInfo dictionary to it and post it.
                                      [[NSNotificationCenter defaultCenter] postNotificationName:@"SessionStateChangeNotification"
                                                                                          object:nil
                                                                                        userInfo:sessionStateInfo];
                                      
                                  }];
}


////////////
//Kakao
///////////
- (void)reloadRootViewController {
    BOOL isOpened = [KOSession sharedSession].isOpen;
    
    if (!isOpened) {
        /// [self.mainViewController popToRootViewControllerAnimated:YES];
    }
    
    ///self.window.rootViewController = isOpened ? self.mainViewController : self.loginViewController;
    ////[self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    if ([KOSession isKakaoAccountLoginCallback:url]) {
        return [KOSession handleOpenURL:url];
    }
    return NO;
}

@end
