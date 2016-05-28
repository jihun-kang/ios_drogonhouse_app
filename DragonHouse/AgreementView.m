//
//  MenuItemView3.m
//  Cream ver 3.0
//
//  Created by Jihun,Kang on 25/2/15.
//  Copyright (c) 2015 Cream. All rights reserved.
//

#import "AgreementView.h"
#import "MainViewController.h"
#import "HelpViewController.h"

@interface AgreementView ()

@end

@implementation AgreementView

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"AgreementView viewWillAppear");

    [super viewWillAppear:animated];
    [self initNavigation];
}



-(void)setLeftButton{

    UIImage *buttonImage = [UIImage imageNamed:@"ico_back.png"];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:buttonImage forState:UIControlStateNormal];
        
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *customBarItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = customBarItem;
        
}
-(void)backAction
{
    NSLog(@"back button clicked");
    [self.navigationController popToRootViewControllerAnimated:YES];
    /*
    MainViewController* myS1 = (MainViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        //   [navController setViewControllers: @[myS1] animated: NO ];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.type = kCATransitionFade;
        //transition.subtype = kCATransitionFromTop;
    
    
    
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];
    [self.navigationController setViewControllers: @[myS1] animated: NO ];
     */
}


-(void)initNavigation{

    // set navigation bar's tint color when being shown
    [self.navigationController.navigationBar setTranslucent:NO];
    UINavigationBar *navBar = [[self navigationController] navigationBar];
    UIImage *backgroundImage = [UIImage imageNamed:@"top_bg"];
    [navBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        
    UIImage *myUIImage = [UIImage imageNamed:@"ico_logo.png"];
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:myUIImage];
    CGRect imageViewFrame = logoImage.frame;
    imageViewFrame.origin.x = 10;
    imageViewFrame.origin.y += 5;
    imageViewFrame.size.height -= 30;
    imageViewFrame.size.width -= 10;
    logoImage.frame = imageViewFrame;
        
    logoImage.contentMode = UIViewContentModeScaleAspectFit;
    [[self navigationItem] setTitleView:logoImage];
   // [self setLeftButton];
    self.navigationItem.hidesBackButton = YES;
    
    self.navigationController.navigationBarHidden = true;
    self.navigationController.navigationBarHidden = false;
            
}


-(IBAction)handleBack:(id)sender
{

        // do your custom handler code here
        NSLog(@"click backbutton.....");
        [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    checkboxSelected = 0;

    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"returnPolicyEng" ofType:@"html" inDirectory:nil];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        
    self.webView.delegate = self;
    [self.webView loadHTMLString:htmlString baseURL:nil];
    self.webView.userInteractionEnabled = YES;
    //[self.webView sizeToFit];
    self.webView.backgroundColor = [UIColor clearColor];
    self.webView.opaque = false;
        
        /*
         get Login infomation.
         */
       // CreamPreferenceInfo* info = [CreamPreferenceInfo getInstance];
       // NSLog(@"Login email %@", [info getLoginEmail]);
        
    
}



-(void)goNext{
    
    if (checkboxSelected == 1){
        HelpViewController *myS = [self.storyboard instantiateViewControllerWithIdentifier:@"HelpViewController"];
        [self.navigationController pushViewController:myS animated:NO];

    }
    else{
        NSLog(@"goNext 222");
    }
    

}


- (IBAction)checkboxButton:(id)sender {
    if (checkboxSelected == 0){
        [self.checkbox setSelected:YES];
        checkboxSelected = 1;
        
    } else {
        [self.checkbox setSelected:NO];
        checkboxSelected = 0;
    }

}

- (IBAction)goNextPage:(id)sender {
    [self goNext];
}
@end
