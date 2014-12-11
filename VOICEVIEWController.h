//
//  VOICEVIEWController.h
//  RemoteIME
//
//  Created by APPLE28 on 14-11-21.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iflyMSC/IFlySpeechRecognizerDelegate.h>
#import <iflyMSC/IFlySpeechRecognizer.h>
#import <iflyMSC/IFlySpeechUtility.h>
#import <iflyMSC/IFlySpeechUnderstander.h>
#import <iflyMSC/IFlySpeechConstant.h>
#import "AsyncUdpSocket.h"
#import "gntvAppDelegate.h"
@interface VOICEVIEWController : UIViewController<IFlySpeechRecognizerDelegate,UITableViewDataSource,UITableViewDelegate>

@end
