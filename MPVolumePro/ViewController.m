
#import "ViewController.h"
#import "MPVolumeObserverPro.h"

@interface ViewController ()<MPVolumeObserverProtocol>

    

@end
@class AVSystemController;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    [MPVolumeObserverPro sharedInstance].delegate = self;
    [[MPVolumeObserverPro sharedInstance]startObserveVolumeChangeEvents];

    
}


-(void) volumeButtonCameraClick:(MPVolumeObserver *) button
{
    NSLog(@"+take Photo+");
    
}


-(void) volumeButtonStarVideoClick:(MPVolumeObserver *) button
{
    NSLog(@"+start video+");
}


-(void) volumeButtonEndVideoClick:(MPVolumeObserver *) button
{
    NSLog(@"+end video+");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
