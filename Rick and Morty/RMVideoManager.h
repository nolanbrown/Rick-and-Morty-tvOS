//
//  RMVideoManager.h
//  Rick and Morty
//
//  Created by Nolan Brown on 11/26/15.
//
//

#import <Foundation/Foundation.h>
#import "RMVideo.h"

@interface RMVideoManager : NSObject

@property (nonatomic, strong) void (^onLoadCompletion)();

- (NSArray *) getSeason: (RMVideoSeason) season;

- (NSArray *) getAllVideos;

@end
