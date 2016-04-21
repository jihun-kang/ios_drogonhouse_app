//
//  SKSplashView.m
//  SKSplashView
//
//  Created by Sachin Kesiraju on 10/25/14.
//  Copyright (c) 2014 Sachin Kesiraju. All rights reserved.
//

#import "SKSplashView.h"

@interface SKSplashView() <NSURLConnectionDataDelegate>
@end

@implementation SKSplashView

#pragma mark - Instance methods



- (instancetype) initView
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    return self;
}


#pragma mark - Public methods
- (void) startAnimationWhileExecuting:(NSURL *)request withCompletion:(void (^)(NSData *, NSURLResponse *, NSError *))completion
{
    if([self.delegate respondsToSelector:@selector(splashView:didBeginAnimatingWithDuration:)])
    {
        [self.delegate splashView:self didBeginAnimatingWithDuration:self.animationDuration];
    }
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:@"http://www.usda.gov/data.json"]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //code
                    // handle response
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopAnimation" object:self userInfo:nil]; //remove animation on data retrieval
                    [self removeSplashView];
                    completion(data, response, error);

                });



            }] resume];
}


- (void) removeSplashView
{
    [self removeFromSuperview];
    [self endAnimating];
}

- (void) endAnimating
{
    if([self.delegate respondsToSelector:@selector(splashViewDidEndAnimating:)])
    {
        [self.delegate splashViewDidEndAnimating:self];
    }
}

@end
