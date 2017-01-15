//
//  HomeViewController.h
//  TanChiShe
//
//  Created by apple on 15/8/14.
//  Copyright (c) 2015年 lanqiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface HomeViewController : UIViewController
{
    IBOutlet UIView*_viewContent;
    IBOutlet UIView*GameOver;
    AVAudioPlayer*_audioPlayer;//播放器
}
-(IBAction)chongLai:(id)sender;
@end
