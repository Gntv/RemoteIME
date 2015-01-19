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
#import <AVFoundation/AVFoundation.h>
@interface VOICEVIEWController : UIViewController<IFlySpeechRecognizerDelegate>
{
    //录音器
    AVAudioRecorder *recorder;
    NSDictionary *recorderSettingsDict;
    //定时器
    NSTimer *timer;
    //图片组
    NSMutableArray *volumImages;
    double lowPassResults;
}
@end
