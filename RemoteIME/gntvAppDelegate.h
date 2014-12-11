//
//  gntvAppDelegate.h
//  RemoteIME
//
//  Created by 李微辰 on 11/10/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface gntvAppDelegate : UIResponder <UIApplicationDelegate>{
    NSString * ip;
}

@property (nonatomic,retain) NSString *ip;
@property (strong, nonatomic) UIWindow *window;

@end
