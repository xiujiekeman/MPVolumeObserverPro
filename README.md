# MPVolumeObserverPro
use system notification to observe volume change<br>
is optimize from MPVolumeObserver<br>
this core can help user to monitor short press or long press , implement similar Snapchat take photo or take video.<br>

Usage:<br>

// start volume notification   <br>    
[MPVolumeObserverPro sharedInstance].delegate = self; <br>
[[MPVolumeObserverPro sharedInstance]startObserveVolumeChangeEvents];<br> 

// delegate <br>
-(void) volumeButtonCameraClick:(MPVolumeObserver *) button<br>
{<br>
    NSLog(@"+take Photo+");<br>
    //you .........<br>
}<br>
-(void) volumeButtonStarVideoClick:(MPVolumeObserver *) button<br>
{<br>
    NSLog(@"+start video+");<br>
    //you .........<br>

}<br>
-(void) volumeButtonEndVideoClick:(MPVolumeObserver *) button<br>
{<br>
    NSLog(@"+end video+");<br>
     //you .........<br>

}<br>

// end volume notification      <br> 
[MPVolumeObserverPro sharedInstance].delegate = nil; <br>
[[MPVolumeObserverPro sharedInstance]stopObserveVolumeChangeEvents];<br> 
