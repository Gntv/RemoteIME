//
//  gntvViewController.h
//  RemoteIME
//
//  Created by 李微辰 on 11/10/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncUdpSocket.h"
#import "Reachability.h"
#import <ifaddrs.h>
#import <net/if.h>
#import <arpa/inet.h>
#import "IMEViewController.h"
#import "gntvTabBarController.h"
#import "gntvAppDelegate.h"
@interface gntvViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
//AsyncUdpSocket *vCommSoc;
}
@property(nonatomic,retain)NSMutableDictionary * IPs;
@property(nonatomic,retain)AsyncUdpSocket * vCommSoc;

@end
