//
//  RMVideo.h
//  Rick and Morty
//
//  Created by Nolan Brown on 11/26/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, RMVideoSeason) {
    RMVideoSeasonOne   = 1,
    RMVideoSeasonTwo     = 2
};

@interface RMVideo : NSObject
@property (nonatomic, readonly) NSNumber *episode;
@property (nonatomic, readonly) NSNumber *duration;
@property (nonatomic, readonly) RMVideoSeason season;

@property (nonatomic, readonly) NSString *details;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSURL *streamURL;
@property (nonatomic, readonly) NSURL *previewURL;

- (instancetype)initWithJSON: (NSDictionary *) json;

- (NSString *)formmattedTime;
- (void) loadPreviewImage:  (void (^)(UIImage *image)) completion;
@end
