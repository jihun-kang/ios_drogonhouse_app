//
//  ViewController.m
//  DragonHouse
//
//  Created by KangJihun on 2016. 4. 15..
//  Copyright © 2016년 a2big. All rights reserved.
//

#import "ViewController.h"
#import "MainViewController.h"

@interface ViewController ()
@property (strong, nonatomic) SKSplashView *splashView;

//Demo of how to add other UI elements on top of splash view
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"ViewController viewWillAppear");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@">>>>>ViewController");

    self.navigationController.navigationBarHidden = true;
    
    //This is to make the status bar (provider, network, clock etc.) color to white since the background is black
    
    [self initAni];
    
    [self uberAnimation];

    

}
UIImageView *animationImageView;

- (void) initAni
{
    // Load images
    NSArray *imageNames = @[@"win_1.png", @"win_2.png", @"win_3.png", @"win_4.png",
                            @"win_5.png", @"win_6.png", @"win_7.png", @"win_8.png",
                            @"win_9.png", @"win_10.png", @"win_11.png", @"win_12.png",
                            @"win_13.png", @"win_14.png", @"win_15.png", @"win_16.png"];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imageNames.count; i++) {
        [images addObject:[UIImage imageNamed:[imageNames objectAtIndex:i]]];
    }

    animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 95, 86, 193)];
    animationImageView.animationImages = images;
    animationImageView.animationDuration = 5;
    animationImageView.autoresizingMask = UIViewAutoresizingNone;
    animationImageView.contentMode = UIViewContentModeCenter;
    animationImageView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);

    
    [self.view addSubview:animationImageView];
    [animationImageView startAnimating];
}






#pragma mark - Concurrent Network Animation

- (void) uberAnimation
{
    SKSplashView *splashView = [[SKSplashView alloc] initView];
    splashView.delegate = self;
    [self.view addSubview:splashView];
    
   // NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.usda.gov/data.json"]]; //replace with url you want to download data for launch from
    NSURL *request = [NSURL URLWithString:@"http://www.usda.gov/data.json"]; 
    
    
    [splashView startAnimationWhileExecuting:request withCompletion:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(), ^{
             //code
             if(!error) {
                 //got data from request, parsing it
                 NSError *jsonError = nil;
                 NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                  NSLog(@"Got everything I needed while splash animation was running 👍 %@", responseDict);
                 
                 [animationImageView stopAnimating];
                 [self showLoginCaheView];
                 
                 
             }
         });

         
         
     }];
}


-(void)showLoginCaheView{
    NSLog(@"showLoginCaheView");
    
    MainViewController *myS = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self.navigationController pushViewController:myS animated:NO];
}



-(void)showMainCaheView{
    NSLog(@"showLoginCaheView");

        MainViewController *myS = [self.storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.navigationController pushViewController:myS animated:NO];
}




#pragma mark - Delegate methods

- (void) splashView:(SKSplashView *)splashView didBeginAnimatingWithDuration:(float)duration
{
    NSLog(@"Started animating from delegate");
    //To start activity animation when splash animation starts
    [_indicatorView startAnimating];
}

- (void) splashViewDidEndAnimating:(SKSplashView *)splashView
{
    NSLog(@"Stopped animating from delegate");
    //To stop activity animation when splash animation ends
    [_indicatorView stopAnimating];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
