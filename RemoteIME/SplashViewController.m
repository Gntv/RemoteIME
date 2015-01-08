//
//  SplashViewController.m
//  RemoteIME
//
//  Created by APPLE28 on 15-1-6.
//  Copyright (c) 2015年 none. All rights reserved.
//

#import "SplashViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initGuide];
}
- (void)initGuide
{
    CGFloat height=self.view.bounds.size.height;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [scrollView setContentSize:CGSizeMake(1280, 0)];
    [scrollView setPagingEnabled:YES];  //视图整页显示

    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, height)];
    [imageview setImage:[UIImage imageNamed:@"guide_01.jpg"]];
    [scrollView addSubview:imageview];

    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(320, 0, 320, height)];
    [imageview1 setImage:[UIImage imageNamed:@"guide_02.jpg"]];
    [scrollView addSubview:imageview1];

    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(640, 0, 320, height)];
    [imageview2 setImage:[UIImage imageNamed:@"guide_03.jpg"]];
    [scrollView addSubview:imageview2];

    UIImageView *imageview3 = [[UIImageView alloc] initWithFrame:CGRectMake(960, 0, 320, height)];
    [imageview3 setImage:[UIImage imageNamed:@"guide_04.jpg"]];
    imageview3.userInteractionEnabled = YES;    //打开imageview3的用户交互;否则下面的button无法响应
    [scrollView addSubview:imageview3];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//在imageview3上加载一个透明的button
    [button setTitle:@"开始使用" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:30]];
    [button setFrame:CGRectMake(46, 371, 230, 37)];
    [button addTarget:self action:@selector(firstpressed) forControlEvents:UIControlEventTouchUpInside];
    button.translatesAutoresizingMaskIntoConstraints = NO;
    [button sizeToFit];
    
    
    [imageview3 addSubview:button];

    [imageview3 addConstraint:[NSLayoutConstraint
                              
                              constraintWithItem:button
                              
                              attribute:NSLayoutAttributeCenterX
                              
                              relatedBy:NSLayoutRelationEqual
                              
                              toItem:imageview3
                              
                              attribute:NSLayoutAttributeCenterX
                              
                              multiplier:1
                              
                              constant:0]];
    [imageview3 addConstraint:[NSLayoutConstraint
                              
                              constraintWithItem:button
                              
                              attribute:NSLayoutAttributeBottom
                              
                              relatedBy:NSLayoutRelationEqual
                              
                              toItem:imageview3
                              
                              attribute:NSLayoutAttributeBottom
                              
                              multiplier:0.75
                              
                              constant:0]];
    
    //[self.view addSubview:button];
    [self.view addSubview:scrollView];
}
- (void)firstpressed
{
    //gntvViewController *transview = [[gntvViewController alloc] init];
    //gntvViewController *transview = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"qwer"];
    UINavigationController *transview = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"start"];
    //[self.navigationController pushViewController:transview animated:YES];
    //[self presentModalViewController:transview animated:YES];  //点击button跳转到根视图
    //transview.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:transview animated:YES completion:nil];
    
    
    //UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:transview];
    //navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
