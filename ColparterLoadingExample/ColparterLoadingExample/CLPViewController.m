//
//  CLPViewController.m
//  ColparterLoadingExample
//
//  Created by Alekseenko Oleg on 09.09.14.
//  Copyright (c) 2014 alekoleg. All rights reserved.
//

#import "CLPViewController.h"
#import "UIView+CLPLoading.h"

@interface CLPViewController ()

@end

@implementation CLPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [UIView clp_setActivityIndicatorColor:[UIColor redColor]];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.view clp_showLoadingWithText ];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.view clp_hideAll];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
