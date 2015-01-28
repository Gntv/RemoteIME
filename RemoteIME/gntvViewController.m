//
//  gntvViewController.m
//  RemoteIME
//
//  Created by 李微辰 on 11/10/14.
//  Copyright (c) 2014 none. All rights reserved.
//

#import "gntvViewController.h"



@interface gntvViewController ()
@property (weak, nonatomic) IBOutlet UITextField *test;
@property (weak, nonatomic) IBOutlet UIImageView *roundani;
@property (weak, nonatomic) IBOutlet UITableView *vIPtable;
@property (weak, nonatomic) IBOutlet UIButton *vSearchButton;
@end

@implementation gntvViewController
@synthesize vCommSoc,vSearchButton,vIPtable,test,roundani,invo_Search;
@synthesize IPs;



- (void)viewDidLoad
{
    //NSLog(@"gagagagagagagagWifi is not available!");
    [super viewDidLoad];
    
    self.vCommSoc = [[AsyncUdpSocket alloc] initWithDelegate:self];
    [self.vCommSoc bindToPort:6000 error:nil];
    [self.vCommSoc receiveWithTimeout:-1 tag:0];
    
    IPs=[[NSMutableDictionary alloc] init];

    [self.roundani setHidden:YES];

    [vSearchButton setUserInteractionEnabled:NO];
    [vIPtable setUserInteractionEnabled:NO];
    [self doSearchOnce];
    
    
    //if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        //self.edgesForExtendedLayout = UIRectEdgeNone;
        //[self.navigationController.navigationBar setTranslucent:NO];
   //}
    
    //[self IsWifiNetworkAvialable];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];

}
-(void)viewDidDisappear:(BOOL)animated
{

}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];

}
/*
-(void)searchOnce
{
    BOOL wifi_status=[self IsWifiNetworkAvialable];
    
    if(!wifi_status) {
        [self.vSearchButton setUserInteractionEnabled:YES];
        NSString *ip=[self localWiFiIPAddress];
        if(ip !=nil ){
            NSArray *sections = [ip componentsSeparatedByString:@"."];
            NSString *ipwith3parts = [[NSString alloc] initWithFormat:@"%@.%@.%@.",[sections objectAtIndex:0],[sections objectAtIndex:1],[sections objectAtIndex:2] ];
            int ip4th = [[sections objectAtIndex:3] intValue];
            [self sendscan:ipwith3parts myipadd4th:ip4th];
        }
        
    }else{
        [self.vSearchButton setUserInteractionEnabled:NO];
        NSLog(@"Wifi is not available!");
    }
    
}*/
/*
-(void)searchDevice:(id)obj
{
    [self searchOnce];
}*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//- (IBAction)send:(id)sender {
//}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if([IPs count] ==0){
        [self.searchIND setText:@"Searching No STB."];
    }
    [self.roundani.layer removeAnimationForKey:@"rotationAnimationa"];
    [self.roundani setHidden:YES];
    [vSearchButton setUserInteractionEnabled:YES];
    [vIPtable setUserInteractionEnabled:YES];
    if(IPs.count == 1){
        
        gntvAppDelegate * del= [[UIApplication sharedApplication] delegate];
        del.ip =[[IPs allKeys] objectAtIndex:0];
        
        gntvTabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"TAB"];
        [self.navigationController pushViewController:tab animated:YES];
        
        
    }
    
}
-(void)doSearchOnce
{
    
    
    CATransform3D rotationTransform = CATransform3DMakeRotation(0.5f * M_PI, 0, 0, 1.0);
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    rotationAnimation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    rotationAnimation.duration = 0.5f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 10;
    [rotationAnimation setDelegate:self];
    [self.roundani.layer addAnimation:rotationAnimation forKey:@"rotationAnimationa"];
    [self.roundani  setHidden:NO];
    ///Users/apple28/Desktop/github/RemoteIME/RemoteIME/gntvViewController.m:108:27: Incompatible pointer types initializing 'dispatch_queue_attr_t' (aka 'NSObject<OS_dispatch_queue_attr> *') with an expression of type 'dispatch_queue_t' (aka 'NSObject<OS_dispatch_queue> *')
    //dispatch_queue_t cq=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    //dispatch_async(cq, ^{
    BOOL wifi_status=[self IsWifiNetworkAvialable];
    if(!wifi_status) {
        NSString *ip=[self localWiFiIPAddress];
        if(ip !=nil ){
            NSArray *sections = [ip componentsSeparatedByString:@"."];
            NSString *ipwith3parts = [[NSString alloc] initWithFormat:@"%@.%@.%@.",[sections objectAtIndex:0],[sections objectAtIndex:1],[sections objectAtIndex:2] ];
            int ip4th = [[sections objectAtIndex:3] intValue];
            [self.searchIND setText:@"Searching STB..."];
            [self sendscan:ipwith3parts myipadd4th:ip4th];
        }
        
    }else{
        NSLog(@"Wifi is not available!");
    }
    //});
    
    //invo_Search = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(searchDevice:) object:nil];
    
    //[invo_Search start];
    

}
- (IBAction)searchnow:(id)sender {
    [vSearchButton setUserInteractionEnabled:NO];
    [vIPtable setUserInteractionEnabled:NO];
    [self doSearchOnce];
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
	//NSLog(@"haha");
    
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
    //[IPs setObject:host];
    
    //states = [[NSMutableDictionary alloc]init];
    [IPs setObject:host forKey:host];
    
    //datasource = [IPs allKeys];
    
    
    
    [self.vIPtable reloadData];
    [self.vCommSoc receiveWithTimeout:-1 tag:0];
    
    
    [self.searchIND setText:@"Select STB in the list."];
	return YES;
}
- (BOOL)IsWifiNetworkAvialable
{
    NetworkStatus re = [[Reachability reachabilityWithHostName:@"www.baidu.com"] currentReachabilityStatus];
    if (re == ReachableViaWiFi) {
        return 0;
    }else {
        return 1;
    }
}
- (NSString *) localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}
-(void)sendscan:(NSString *)ip3parts
     myipadd4th:(int)myip4th
{
    int i;
    Byte content[7];
    content[0]=7; // data sum
    content[1]=1; // type
    content[2]=1; // opertation
    
    content[3]='S';//SCAN
    content[4]='C';
    content[5]='A';
    content[6]='N';
    NSData * packet = [[NSData alloc] initWithBytes:content length:7];
    for(i=2;i<255;i++){
        if(i!=myip4th){
            
            NSString * ip = [ip3parts stringByAppendingFormat:@"%d",i];
            
            [self.vCommSoc sendData:packet toHost:ip port:6000 withTimeout:80 tag:0];
            //[NSThread sleepForTimeInterval:0.01];
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [IPs count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];
    //UIImage *image = [UIImage imageNamed:@"LightGrey.png"];
    //imageView.image = image;
    //cell.backgroundView = imageView;
    //[[cell textLabel] setBackgroundColor:[UIColor clearColor]];
    //[[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"机顶盒%d",indexPath.row+1];
    //[[IPs allKeys] objectAtIndex:indexPath.row];
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //IMEViewController *ime = [self.storyboard instantiateViewControllerWithIdentifier:@"IME"];
    //ime.ip = [[IPs allKeys] objectAtIndex:indexPath.row];
    //[self.navigationController pushViewController:ime animated:YES];
    
    
    gntvAppDelegate * del= [[UIApplication sharedApplication] delegate];
    del.ip =[[IPs allKeys] objectAtIndex:indexPath.row];
    
    gntvTabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"TAB"];
    //tab.ip = [[IPs allKeys] objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:tab animated:YES];
    
    
    
}




@end
