//
//  IMEViewController.m
//  RemoteIME
//
//  Created by 李微辰 on 11/11/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import "IMEViewController.h"

@interface IMEViewController ()
@property (weak, nonatomic) IBOutlet UIButton *Khome;
@property (weak, nonatomic) IBOutlet UIButton *Kmenu;
@property (weak, nonatomic) IBOutlet UIButton *Kback;
@property (weak, nonatomic) IBOutlet UIButton *Kleft;
@property (weak, nonatomic) IBOutlet UIButton *Kup;
@property (weak, nonatomic) IBOutlet UIButton *Kright;
@property (weak, nonatomic) IBOutlet UIButton *Kdown;
@property (weak, nonatomic) IBOutlet UIButton *Kok;
@property (weak, nonatomic) IBOutlet UIButton *Kvolumdown;
//@property (weak, nonatomic) IBOutlet UIButton *Kmute;
@property (weak, nonatomic) IBOutlet UIButton *Kvolumup;

@end



@implementation IMEViewController

@synthesize vCommSoc;
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/
-(void)setSubView:(UIView *)view {
        
        // Get the subviews of the view
    NSArray *subviews = [view subviews];
    //[view setTranslatesAutoresizingMaskIntoConstraints:NO];
        // Return if there are no subviews
    if ([subviews count] == 0) return; // COUNT CHECK LINE
        
    for (UIView *subview in subviews) {
            
            // Do what you want to do with the subview
        //NSLog(@"%@", subview);
        if ([subviews isKindOfClass:[UIView class]]) {
            [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
        
            // List the subviews of subview
        [self setSubView:subview];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSubView:self.view];
    vCommSoc = [[AsyncUdpSocket alloc] initWithDelegate:self];
    [vCommSoc bindToPort:6000 error:nil];
    [vCommSoc receiveWithTimeout:-1 tag:0];
    //bool test = self.view.translatesAutoresizingMaskIntoConstraints;
    
    
	// Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    //[self setSubView:self.view];
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)sendkey:(NSString *)boxip
     keynum:(Byte)key
{
    //int i;
    Byte content[7];
    content[0]=7; // data sum
    content[1]=3; // type
    content[2]=1; // opertation
    content[3]=key;
    content[4]=0;
    content[5]=0;
    content[6]=0;//key
    NSData * packet = [[NSData alloc] initWithBytes:content length:7];
    
    [vCommSoc sendData:packet toHost:boxip port:6000 withTimeout:80 tag:0];
    
}

- (void)presskey:(int)key {
    gntvAppDelegate *del= [[UIApplication sharedApplication] delegate];
    [self sendkey:del.ip keynum:key];
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
- (IBAction)pressHome:(id)sender {
    [self presskey:3];
}
- (IBAction)pressMenu:(id)sender {
    [self presskey:82];
}

- (IBAction)pressBack:(id)sender {
    [self presskey:4];
    
    
    
}
- (IBAction)pressLeft:(id)sender {
    [self presskey:21];
    
    
}
- (IBAction)pressUp:(id)sender {
    [self presskey:19];
    
    
    
}
- (IBAction)pressRight:(id)sender {
    [self presskey:22];
    
    
    
}
- (IBAction)pressDown:(id)sender {
    [self presskey:20];
    
    
}
- (IBAction)pressOk:(id)sender {
    [self presskey:23];
    
    
    
    
}
- (IBAction)pressVolumDown:(id)sender {
    [self presskey:25];
    
    
    
}
- (IBAction)pressVolumUp:(id)sender {
    [self presskey:24];
    
    
    
}
/*
- (IBAction)pressMute:(id)sender {
    
    [self presskey:91];
    
    
}*/
- (IBAction)pressK1:(id)sender {
    [self presskey:8];
}
- (IBAction)pressK2:(id)sender {
    [self presskey:9];
}
- (IBAction)pressK3:(id)sender {
    [self presskey:10];
}
- (IBAction)pressK4:(id)sender {
    [self presskey:11];
}
- (IBAction)pressK5:(id)sender {
    [self presskey:12];
}
- (IBAction)pressK6:(id)sender {
    [self presskey:13];
}
- (IBAction)pressK7:(id)sender {
    [self presskey:14];
}
- (IBAction)pressK8:(id)sender {
    [self presskey:15];
}
- (IBAction)pressK9:(id)sender {
    [self presskey:16];
}
- (IBAction)pressK0:(id)sender {
    [self presskey:7];
}








@end
