//  Created by tashigaofei on 13/08/26.
//  Change  by LJT         on 17/01/15

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class MPVolumeObserverPro;
@protocol MPVolumeObserverProtocol <NSObject>
-(void) volumeButtonCameraClick:(MPVolumeObserverPro *) button;
-(void) volumeButtonStarVideoClick:(MPVolumeObserverPro *) button;
-(void) volumeButtonEndVideoClick:(MPVolumeObserverPro *) button;


@end


@interface MPVolumeObserverPro : NSObject
@property (nonatomic, assign) id<MPVolumeObserverProtocol> delegate;

+(MPVolumeObserverPro*) sharedInstance;
-(void)startObserveVolumeChangeEvents;
-(void)stopObserveVolumeChangeEvents;

@end

