//  Created by tashigaofei on 13/08/26.
//  Change  by LJT         on 17/01/15

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class MPVolumeObserver;
@protocol MPVolumeObserverProtocol <NSObject>
-(void) volumeButtonCameraClick:(MPVolumeObserver *) button;
-(void) volumeButtonStarVideoClick:(MPVolumeObserver *) button;
-(void) volumeButtonEndVideoClick:(MPVolumeObserver *) button;


@end


@interface MPVolumeObserverPro : NSObject
@property (nonatomic, assign) id<MPVolumeObserverProtocol> delegate;

+(MPVolumeObserverPro*) sharedInstance;
-(void)startObserveVolumeChangeEvents;
-(void)stopObserveVolumeChangeEvents;

@end

