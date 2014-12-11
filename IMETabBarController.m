//
//  IMETabBarController.m
//  RemoteIME
//
//  Created by 李微辰 on 11/11/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import "IMETabBarController.h"

@interface IMETabBarController ()

@end

@implementation IMETabBarController


@synthesize ip,vCommSoc;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    vCommSoc = [[AsyncUdpSocket alloc] initWithDelegate:self];
    [vCommSoc bindToPort:6000 error:nil];
    [vCommSoc receiveWithTimeout:-1 tag:0];
    
    
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)sendkey:(NSString *)boxip
        keynum:(int)key
{
    //int i;
    Byte content[7];
    content[0]=7; // data sum
    content[1]=1; // type
    content[2]=1; // opertation
    
    content[3]='S';//SCAN
    content[4]='C';
    content[5]='A';
    content[6]='N';
    NSData * packet = [[NSData alloc] initWithBytes:content length:7];
    
    [vCommSoc sendData:packet toHost:boxip port:6000 withTimeout:80 tag:0];
    
}

- (void)presskey:(int)key {
    
    [self sendkey:ip keynum:key];
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
	NSLog(@"haha");
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
	NSLog(@"nono");
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock
     didReceiveData:(NSData *)data
            withTag:(long)tag
           fromHost:(NSString *)host
               port:(UInt16)port
{
	NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"text:%@ host:%@:%d",msg,host,port) ;
    [vCommSoc receiveWithTimeout:-1 tag:0];
	return YES;
}


@end
