//
//  MenuItemView3.h
//  Cream ver 3.0
//
//  Created by Jihun,Kang on 25/2/15.
//  Copyright (c) 2015 Cream. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgreementView : UIViewController <UIWebViewDelegate>{
    BOOL checkboxSelected;

}
//@property (weak, nonatomic) IBOutlet UIButton *backButton;
//-(IBAction)handleBack:(id)sender;
- (IBAction)checkboxButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *checkbox;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

