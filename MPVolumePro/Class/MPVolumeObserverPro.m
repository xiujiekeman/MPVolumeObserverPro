#import "MPVolumeObserverPro.h"


@interface MPVolumeObserverPro()
{
    MPVolumeView   *_volumeView;
    float           launchVolume;
    BOOL            _isObservingVolumeButtons;
    BOOL            _suspended;
    int             Isfirst;
    NSString       *strNowVolume;
    NSTimer        *timeTouchVideo;
    
    NSInteger       secondsLastElapsed;
    NSInteger       secondsElapsed;     //定时器比较
    BOOL            defaultEnter;
    BOOL            isVideoStar;
    BOOL            isVideoEnd;
    
    float           fVolume;  //默认声音大小
}

@end

@implementation MPVolumeObserverPro

+(MPVolumeObserverPro*) sharedInstance;
{
    static MPVolumeObserverPro *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[MPVolumeObserverPro alloc] init];
    });
    return instance;
}


-(id)init
{
    self = [super init];
    if( self ){
        _isObservingVolumeButtons = NO;
        _suspended = NO;
        Isfirst = 0;
        secondsElapsed = 0;
        defaultEnter = YES;
        secondsLastElapsed = 0;
        CGRect frame = CGRectMake(0, -100, 0, 0);
        _volumeView = [[MPVolumeView alloc] initWithFrame:frame];
        [[UIApplication sharedApplication].windows[0] addSubview:_volumeView];
        
    }
    return self;
}


//初始化
-(void)startObserveVolumeChangeEvents
{
    _suspended = NO;
    isVideoStar = YES;
    isVideoEnd = NO;
    fVolume = [self volume];
    [self startObserve];
    timeTouchVideo = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                      target:self
                                                    selector:@selector(onTimeFire)
                                                    userInfo:nil
                                                     repeats:YES];
    [timeTouchVideo setFireDate:[NSDate distantFuture]];
}


-(void) startObserve;
{
    NSLog(@"start add notification");
    if(_isObservingVolumeButtons)
    {
        return;
    }
    
    
    [[AVAudioSession sharedInstance] setActive:NO error: nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionInterruptSpokenAudioAndMixWithOthers error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error: nil];
    
    _isObservingVolumeButtons = YES;
    strNowVolume = [[ NSString stringWithFormat:@"%f",[self volume] ] substringToIndex:4];
    strNowVolume = [strNowVolume  isEqualToString: @"0.00"] ? @"0.05" : strNowVolume;
    strNowVolume = [strNowVolume  isEqualToString: @"1.00"] ? @"0.95" : strNowVolume;
    if ([strNowVolume  isEqual: @"0.05"] || [strNowVolume isEqualToString:@"0.95"])
    {
        [self setVolume:[strNowVolume floatValue]];
    }
    if (!_suspended)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(suspendObserveVolumeChangeEvents:)
                                                     name:UIApplicationWillResignActiveNotification     // -> 离开前台
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(resumeObserveVolumeButtonEvents:)
                                                     name:UIApplicationDidBecomeActiveNotification      // <- 进入前台
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChangeNotification:)
                                                     name:@"SystemVolumeDidChange" object:nil];
    }
}


//声音改变回调
-(void) volumeChangeNotification:(NSNotification *) no
{
    static id sender = nil;
    if (sender == nil && no.object) {
        sender = no.object;
    }
    NSString * NowChangeVolume = [[ NSString stringWithFormat:@"%f",[[no.userInfo objectForKey:@"AudioVolume"] floatValue] ] substringToIndex:4];
    if (no.object != sender || [NowChangeVolume isEqualToString: strNowVolume]) {
        return;
    }
    if (defaultEnter) {
        defaultEnter = NO;
        return;
    }
    NSLog(@"音量变化");
    [self setVolume:[strNowVolume floatValue]];
    secondsElapsed++;
    if (secondsElapsed == 2) {
        //开始录制
        NSLog(@"开始录制");
        [timeTouchVideo setFireDate:[NSDate date]];
    }else{
        if (secondsElapsed>2) {
            NSLog(@"录制中");
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.65 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (secondsElapsed==2) {
                    NSLog(@"进不来");
                }else if(secondsElapsed==1){
                    //拍照
                    NSLog(@"拍照");
                    secondsElapsed = 0;
                }else{
                    //录制
                }
            });

        }
    }
}


//定期加结束
-(void)onTimeFire
{
    NSLog(@"-------%ld=======%ld",secondsLastElapsed,secondsElapsed);
    if (secondsLastElapsed == secondsElapsed) {
        NSLog(@"end video");
        if ([self.delegate respondsToSelector:@selector(volumeButtonEndVideoClick:)]) {
            [self.delegate volumeButtonEndVideoClick:self];
            isVideoEnd = NO;
            isVideoStar = YES;
            [timeTouchVideo setFireDate:[NSDate distantFuture]];
            secondsElapsed = 0;
            secondsLastElapsed = 0;

        }
    }
    secondsLastElapsed++;
    
}


//拍照
- (void)tackPhoto
{
    if (isVideoStar)
    {
        NSLog(@"take Photo");
        if ([self.delegate respondsToSelector:@selector(volumeButtonCameraClick:)]) {
            [self.delegate volumeButtonCameraClick:self];
        }
    }
}


- (void)suspendObserveVolumeChangeEvents:(NSNotification *)notification
{
    if(_isObservingVolumeButtons)
    {
        _suspended = YES; // Call first!
        [self stopObserveVolumeChangeEvents];
        Isfirst = 0;
    }
}



- (void)resumeObserveVolumeButtonEvents:(NSNotification *)notification
{
    if(_suspended)
    {
        [self startObserveVolumeChangeEvents];
        Isfirst = 0;
        _suspended = NO; // Call last!
    }
}



-(void)stopObserveVolumeChangeEvents
{
    
    if(!_isObservingVolumeButtons){
        return;
    }
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"SystemVolumeDidChange" object:nil];
    
    Isfirst = 0;
    //    [timeTouchVideo invalidate];
    secondsElapsed = 0;
    _isObservingVolumeButtons = NO;
    [[AVAudioSession sharedInstance] setActive:NO error: nil];
    
}

- (float)volume
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    CGFloat volume = audioSession.outputVolume;
    return volume;
}


- (void)setVolume:(float)newVolume
{
    MPVolumeView* volumeView = [[MPVolumeView alloc] init];
    
    //find the volumeSlider
    UISlider* volumeViewSlider = nil;
    for (UIView *view in [volumeView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            volumeViewSlider = (UISlider*)view;
            break;
        }
    }
    
    [volumeViewSlider setValue:newVolume animated:YES];
    [volumeViewSlider sendActionsForControlEvents:UIControlEventTouchUpInside];
}


-(void)dealloc
{
    _suspended = NO;
    Isfirst = 0;
}

@end




