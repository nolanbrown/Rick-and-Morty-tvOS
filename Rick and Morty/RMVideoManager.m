//
//  RMVideoManager.m
//  Rick and Morty
//
//  Created by Nolan Brown on 11/26/15.
//
//

#import "RMVideoManager.h"
#define kRMVideoHTMLPage @"http://www.adultswim.com/videos/rick-and-morty/"

@interface RMVideoManager()
@property (nonatomic, strong) NSArray *videos;
@end
@implementation RMVideoManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self __getJSONFromHTML:^(NSDictionary *json) {
            self.videos = [self __loadVideosFromJSON:json];
            if(self.onLoadCompletion) {
                self.onLoadCompletion();
            }
        }];
    }
    return self;
}

- (NSArray *) getSeason: (RMVideoSeason) season {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"season = %d",season];
    NSArray *vids = [self.videos filteredArrayUsingPredicate:pred];
    
    return [vids sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        RMVideo *vid1 = obj1;
        RMVideo *vid2 = obj2;
        if ( vid1.episode < vid2.episode ) {
            return (NSComparisonResult)NSOrderedAscending;
        } else if ( vid1.episode > vid2.episode ) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    
}

- (NSArray *) getAllVideos {
    
    return self.videos;
}

- (NSArray *) __loadVideosFromJSON: (NSDictionary *) json {
    NSArray *seasons = json[@"show"][@"collections"];

    NSMutableArray *videoArray = [NSMutableArray array];
    for(NSDictionary *season in seasons) {

        for(NSDictionary *episode in season[@"videos"]) {
            RMVideo *ep = [[RMVideo alloc] initWithJSON:episode];
            if(ep) {
                [videoArray addObject:ep];
            }
        }
    }
    
    return videoArray;
}


- (void) __getJSONFromHTML:  (void (^)(NSDictionary *json)) completion {
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:kRMVideoHTMLPage]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                NSDictionary *parsedJSON = nil;
                if(!error) {
                    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSString *jsonString = [self __extractJSONFromHTML:html];
                    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                    parsedJSON = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                }
                if(completion) {
                    completion(parsedJSON);
                }
                
            }] resume];
}


- (NSString *) __extractJSONFromHTML: (NSString *) str {
    return [self __extractFirstMatchWithString:str withRegexString:@"<script>\\s*.*= (.*);\\s*<\\/script>"];
}

// Regex Helper
- (NSString *) __extractFirstMatchWithString:(NSString *) str withRegexString: (NSString *) regexStr {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *arrayOfAllMatches = [regex matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    if(arrayOfAllMatches.count > 0) {
        NSTextCheckingResult *match = arrayOfAllMatches[0];
        
        if(match.numberOfRanges > 1) {
            NSString* fileToken = [str substringWithRange:[match rangeAtIndex:1]];
            return fileToken;
        }
        
    }
    return nil;
}





@end
