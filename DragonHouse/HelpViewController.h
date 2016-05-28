//
//  HelpViewController.h
//  DragonHouse
//
//  Created by KangJihun on 2016. 5. 29..
//  Copyright © 2016년 a2big. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"

@interface HelpViewController : UIViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *pageTitles;
@property (strong, nonatomic) NSArray *pageImages;


@end
