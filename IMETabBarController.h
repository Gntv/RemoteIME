//
//  IMETabBarController.h
//  RemoteIME
//
//  Created by 李微辰 on 11/11/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"


@interface IMETabBarController : UITabBarController{
    NSString * ip;
    AsyncUdpSocket *vCommSoc;
}
@property (nonatomic,retain) NSString *ip;
@property (nonatomic,retain) AsyncUdpSocket *vCommSoc;

@end
