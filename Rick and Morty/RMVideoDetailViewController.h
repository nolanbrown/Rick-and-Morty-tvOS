//
//  RMVideoDetailViewController.h
//  Rick and Morty
//
//  Created by Nolan Brown on 11/27/15.
//
//

#import <UIKit/UIKit.h>
#import "RMVideo.h"

@interface RMVideoDetailViewController : UIViewController
@property (nonatomic, strong) RMVideo *video;

- (void) setCurrentVideo: (RMVideo *) video;

@end
