//
//  VOICEVIEWController.m
//  RemoteIME
//
//  Created by APPLE28 on 14-11-21.
//  Copyright (c) 2014年 none. All rights reserved.
//

#import "VOICEVIEWController.h"



@interface VOICEVIEWController ()
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *speekButton;
@property (weak, nonatomic) IFlySpeechRecognizer *speech;
@property (weak, nonatomic) IBOutlet UITableView *voiceText;



//@property(nonatomic,retain)NSMutableDictionary * texts;
@property (nonatomic,retain) AsyncUdpSocket *vCommSoc;

@end

@implementation VOICEVIEWController
@synthesize speech,speekButton;
@synthesize voiceText,vCommSoc;

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
    NSString *initstring = [[NSString alloc] initWithFormat:@"appid=%@",@"546ecb9c"];
    [IFlySpeechUtility createUtility:initstring];
    speech = [IFlySpeechRecognizer sharedInstance];
    speech.delegate = self;
    [speech setParameter:@"0" forKey: [IFlySpeechConstant ASR_PTT]];
    [speech setParameter:@"zh_cn" forKey: [IFlySpeechConstant LANGUAGE]];
    [speech setParameter:@"4000" forKey: [IFlySpeechConstant VAD_BOS]];
    [speech setParameter:@"1000" forKey: [IFlySpeechConstant VAD_EOS]];
    [speech setParameter:@"iat" forKey: [IFlySpeechConstant IFLY_DOMAIN]];
    [speech setParameter:@"asrview.pcm " forKey: [IFlySpeechConstant ASR_AUDIO_PATH]];
    
    
    //self.texts=[[NSMutableDictionary alloc] init];
    
    vCommSoc = [[AsyncUdpSocket alloc] initWithDelegate:self];
    [vCommSoc bindToPort:6000 error:nil];
    [vCommSoc receiveWithTimeout:-1 tag:0];
    
    
    
    
    
    
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        //7.0第一次运行会提示，是否允许使用麦克风
        AVAudioSession *session = [AVAudioSession sharedInstance];
        NSError *sessionError;
        //AVAudioSessionCategoryPlayAndRecord用于录音和播放
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
        if(session == nil)
            NSLog(@"Error creating session: %@", [sessionError description]);
        else
            [session setActive:YES error:nil];
    }

    //录音设置
    recorderSettingsDict =[[NSDictionary alloc] initWithObjectsAndKeys:
                           [NSNumber numberWithInt:kAudioFormatMPEG4AAC],AVFormatIDKey,
                           [NSNumber numberWithInt:1000.0],AVSampleRateKey,
                           [NSNumber numberWithInt:2],AVNumberOfChannelsKey,
                           [NSNumber numberWithInt:8],AVLinearPCMBitDepthKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
                           [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                           nil];
    //音量图片数组
    volumImages = [[NSMutableArray alloc]initWithObjects:@"voice_search_microphone.png",
                   @"voice_search_microphone_0.png",
                   @"voice_search_microphone_1.png",
                   @"voice_search_microphone_2.png",
                   @"voice_search_microphone_3.png",   nil];

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)search:(id)sender {
    
    gntvAppDelegate *del= [[UIApplication sharedApplication] delegate];
    [self sendText:del.ip str:self.searchText.text];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    //[speech destroy];
    [super viewWillDisappear:animated];
}
- (IBAction)speekPressed:(id)sender {
    //[self.texts removeAllObjects];
    [speech startListening];
    
    
    
    if ([self canRecord]) {
        
        NSError *error = nil;
        //必须真机上测试,模拟器上可能会崩溃
        recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:@"/dev/null"] settings:recorderSettingsDict error:&error];
        
        if (recorder) {
            recorder.meteringEnabled = YES;
            [recorder prepareToRecord];
            [recorder record];
            
            //启动定时器
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(levelTimer:) userInfo:nil repeats:YES];
            
        } else
        {
            int errorCode = CFSwapInt32HostToBig ([error code]);
            NSLog(@"Error: %@ [%4.4s])" , [error localizedDescription], (char*)&errorCode);
            
        }
    }
    
}
- (IBAction)speekUnPressed:(id)sender {
    [speech stopListening];
    
    
    //录音停止
    [recorder stop];
    recorder = nil;
    //结束定时器
    [timer invalidate];
    timer = nil;
    //图片重置
    [speekButton setImage:[UIImage imageNamed:[volumImages objectAtIndex:0]] forState:UIControlStateNormal];
    
}

-(void)onResults:(NSArray *)results isLast:(BOOL)isLast{
    
    NSArray * temp = [[NSArray alloc]init];
    NSString * str = [[NSString alloc]init];
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    NSLog(@"听写结果：%@",result);
    //---------讯飞语音识别JSON数据解析---------//
    NSError * error;
    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"data: %@",data);
    NSDictionary * dic_result =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
         NSArray * array_ws = [dic_result objectForKey:@"ws"];
    //遍历识别结果的每一个单词
    for (int i=0; i<array_ws.count; i++) {
            temp = [[array_ws objectAtIndex:i] objectForKey:@"cw"];
        for (int j=0; j<temp.count; j++) {
            NSDictionary * dic_cw = [temp objectAtIndex:j];/////////////////////
            NSString *new = [dic_cw objectForKey:@"w"];
            //
            str=[str stringByAppendingString:new];
            //str = [str  stringByAppendingString:[dic_cw objectForKey:@"w"]];
            NSLog(@"识别结果:%@",new);
        }
        
    }
    NSLog(@"最终的识别结果:%@",str);
    //[self.texts setObject:str forKey:str];
    //[self reloadData];
    if (str != nil && ![str isEqual: @""]) {
        self.searchText.text = str;
    }
    
    //去掉识别结果最后的标点符号
    //if ([str isEqualToString:@"。"] || [str isEqualToString:@"？"] || [str isEqualToString:@"！"]) {
    //    NSLog(@"末尾标点符号：%@",str);
    //}
   /// else{
    ///    self.content.text = str;
    //}
    //_result = str;
    
    
    
    
    
    
    
}
-(void)onError:(IFlySpeechError *)errorCode{
}

-(void)levelTimer:(NSTimer*)timer_
{
    //call to refresh meter values刷新平均和峰值功率,此计数是以对数刻度计量的,-160表示完全安静，0表示最大输入值
    [recorder updateMeters];
    const double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    lowPassResults = ALPHA * peakPowerForChannel + (1.0 - ALPHA) * lowPassResults;
    
    NSLog(@"Average input: %f Peak input: %f Low pass results: %f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], lowPassResults);
    
    if (lowPassResults>=0.4) {
        [speekButton setImage:[UIImage imageNamed:[volumImages objectAtIndex:4]] forState:UIControlStateHighlighted];
        
    }else if(lowPassResults>=0.3){
        [speekButton setImage:[UIImage imageNamed:[volumImages objectAtIndex:3]] forState:UIControlStateHighlighted];
        
    }else if(lowPassResults>=0.2){
        [speekButton setImage:[UIImage imageNamed:[volumImages objectAtIndex:2]] forState:UIControlStateHighlighted];
        
    }else{
        [speekButton setImage:[UIImage imageNamed:[volumImages objectAtIndex:1]] forState:UIControlStateHighlighted];
        
    }
    
}

//判断是否允许使用麦克风7.0新增的方法requestRecordPermission
-(BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:nil
                                                    message:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"
                                                   delegate:nil
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil] show];
                    });
                }
            }];
        }
    }
    
    return bCanRecord;
}



/*
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.texts count];
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
    
    cell.textLabel.text = [[self.texts allKeys] objectAtIndex:indexPath.row];
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.searchText.text = [[self.texts allKeys] objectAtIndex:indexPath.row];
    
    //gntvTabBarController *tab = [self.storyboard instantiateViewControllerWithIdentifier:@"TAB"];
    //[self.navigationController pushViewController:tab animated:YES];
    
    //gntvAppDelegate * del= [[UIApplication sharedApplication] delegate];
    //del.ip =[[IPs allKeys] objectAtIndex:indexPath.row];
    
}*/

-(void)sendText:(NSString *)boxip
        str:(NSString *)str
{
    //int i;
    Byte content[3];
    
    
    
    //NSData * packet = [[NSData alloc] initWithBytes:content length:4];
    
    NSData *data =[str dataUsingEncoding:NSUTF8StringEncoding];
    content[1]=4; // type
    content[2]=2; // opertation
    content[0]=3+data.length; // data sum
    NSMutableData *pack = [[NSMutableData alloc] initWithBytes:content length:sizeof(content)];
    [pack appendData:data];
    
   // NSData *contentdata = [data bytes];
    
    
    
    
    //NSMutableData *temp = [[NSMutableData alloc] initWithBytes:content length:3];
    //[temp appendData:contentdata];
    
    [self.vCommSoc sendData:pack toHost:boxip port:6000 withTimeout:80 tag:0];
    
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
