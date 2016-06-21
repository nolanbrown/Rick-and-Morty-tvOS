//
//  RMVideo.m
//  Rick and Morty
//
//  Created by Nolan Brown on 11/26/15.
//
//

#import "RMVideo.h"
#import <UIKit/UIKit.h>

/*
 {
     "ott_expiration_date": "",
     "episode_number": "1",
     "blurb": "",
     "type": "episode",
     "ott_launch_date": 1447435920,
     "season_number": "2",
     "duration": 1373,
     "title": "A Rickle in Time",
     "cma_id": "1101132",
     "launch_date": 1439784900,
     "tv_rating": "tv-14-l",
     "views": 31792,
     "description": "Rick don goofed this time and mussed up the whole time frame broh! Beth and Jerry get romantic!",
     "expiration_date": 1448899200,
     "images": [
         {
         "height": "300",
         "width": "400",
         "name": "legacy",
         "url": "http://i.cdn.turner.com/adultswim/big/video/a-rickle-in-time/rickandmorty_cc_201_pt4.jpg"
         },
         {
         "height": "608",
         "width": "1080",
         "name": "main",
         "url": "http://i.cdn.turner.com/adultswim/big/video/a-rickle-in-time/rickandmorty_cc_201_pt4_1.jpg"
         }
     ],
     "slug": "a-rickle-in-time",
     "auth": false,
     "id": "1GygwzX5SGW_dCv8DOF1BQ",
     "version": 348024,
     "identifier": "EP 1",
     "contentType": "EPI",
     "collectionSlug": "rick-and-morty",
     "linkURL": "/videos/rick-and-morty/a-rickle-in-time/",
     "fbCommentMetadata": {
        "associatedURL": "http://www.adultswim.com/videos/rick-and-morty/a-rickle-in-time"
     },
     "clips": [
         {
         "id": "a-rickle-in-time-0",
         "title": "A Rickle in Time",
         "contentType": "EPI",
         "videoPlaybackID": "1GygwzX5SGW_dCv8DOF1BQ-0"
         },
         {
         "id": "a-rickle-in-time-1",
         "title": "A Rickle in Time",
         "contentType": "EPI",
         "videoPlaybackID": "1GygwzX5SGW_dCv8DOF1BQ-1"
         },
         {
         "id": "a-rickle-in-time-2",
         "title": "A Rickle in Time",
         "contentType": "EPI",
         "videoPlaybackID": "1GygwzX5SGW_dCv8DOF1BQ-2"
         },
         {
         "id": "a-rickle-in-time-3",
         "title": "A Rickle in Time",
         "contentType": "EPI",
         "videoPlaybackID": "1GygwzX5SGW_dCv8DOF1BQ-3"
         }
     ],
     "stream": {
         "id": "a-rickle-in-time-0",
         "title": "A Rickle in Time",
         "contentType": "EPI",
         "videoPlaybackID": "1GygwzX5SGW_dCv8DOF1BQ-0"
     }
 }
 */

@interface RMVideo () <NSXMLParserDelegate>
@property (nonatomic, strong, readwrite) NSNumber *episode;
@property (nonatomic, strong, readwrite) NSNumber *duration;

@property (nonatomic, strong, readwrite) NSString *details;
@property (nonatomic, strong, readwrite) NSString *title;
@property (nonatomic, strong, readwrite) NSURL *streamURL;
@property (nonatomic, strong, readwrite) NSURL *previewURL;
@property (nonatomic, strong, readwrite) UIImage *previewImage;

@property (nonatomic, strong, readwrite) NSURL *assetURL;
@property (nonatomic, strong, readwrite) NSString *playbackID;

@property (nonatomic) RMVideoSeason season;

// Parsing

@property (nonatomic, strong) NSMutableString *currentBestVideoString;
@property (nonatomic) BOOL readString;
@property (nonatomic) BOOL currentBitrate;

@property (nonatomic, strong) void (^parseURLCompletion)(NSURL *url);

@end

#define kAssetURLFormat @"http://www.adultswim.com/videos/api/v0/assets?platform=desktop&id=%@&phds=true"

@implementation RMVideo
@synthesize episode, duration, details, title, streamURL, previewURL;

- (instancetype)initWithJSON: (NSDictionary *) json
{
    if([json[@"auth"] boolValue]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.episode = [NSNumber numberWithInteger:[json[@"episode_number"] integerValue]];
        self.duration = json[@"duration"];
        self.season = [json[@"season_number"] integerValue];
        self.details = json[@"description"];
        self.title = json[@"title"];
        self.playbackID = json[@"stream"][@"videoPlaybackID"];
        
        NSArray *images = json[@"images"];
        for(NSDictionary *image in images) {
            if([image[@"name"] isEqualToString:@"main"]) {
                self.previewURL = [NSURL URLWithString:image[@"url"]];
            }
        }
        self.assetURL = [NSURL URLWithString:[NSString stringWithFormat:kAssetURLFormat,self.playbackID]];
        [self __loadAssetsWithURL: self.assetURL];
    }
    return self;
}

- (NSString *)formmattedTime
{
    NSInteger totalSeconds = self.duration.floatValue;
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

-(void) loadPreviewImage:  (void (^)(UIImage *image)) completion
{
    if(self.previewImage) {
        if(completion)
            completion(self.previewImage);
    }
    else {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.previewURL
                                                                    cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                                timeoutInterval:60];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data,
                                    NSURLResponse *response,
                                    NSError *error) {
                    self.previewImage = nil;
                    if(!error) {
                        self.previewImage = [UIImage imageWithData:data];
                    }
                    if(completion) {
                        completion(self.previewImage);
                    }
                    
                }] resume];
    }
}


- (void) __loadAssetsWithURL: (NSURL *) url {
    
    
    void (^assetURL)(NSURL *url) = ^void(NSURL *url) {
        if(!self.streamURL) {
            self.streamURL = url;
        }
    };

    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:url
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                if(!error) {
                    [self __parseXMLWithData:data onCompletion:assetURL];
                }
                else {
                    assetURL(nil);
                }
                // handle response
                
            }] resume];
}

- (void) __parseXMLWithData: (NSData *) data onCompletion: (void (^)(NSURL *url)) completion{
    self.currentBestVideoString = [[NSMutableString alloc] init];
    self.parseURLCompletion = completion;

    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
}



- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    self.readString = NO;

    if ([elementName isEqualToString:@"file"]) { // we only care about the file attributes
        NSString *type = attributeDict[@"type"];
        if(self.currentBitrate <= [attributeDict[@"bitrate"] integerValue]) { // get max bitrate
            if([type isEqualToString:@"hd"]) { // get hd version
                self.readString = YES;
                self.currentBitrate = [attributeDict[@"bitrate"] integerValue];

            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"file"]) {
        if([[self.currentBestVideoString pathExtension] isEqualToString:@"m3u8"]) { //m3u8 are best versions
            NSURL *url = [NSURL URLWithString:self.currentBestVideoString];
            if(self.parseURLCompletion) {
                self.parseURLCompletion(url);
            }
            
            [parser abortParsing];
        }
        else {
            [self.currentBestVideoString setString:@""];
        }
        
    }
    
    self.readString = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (self.readString) {
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        //
        [self.currentBestVideoString appendString:string];
    }
}
/**
 An error occurred while parsing the earthquake data, pass the error to the main thread for handling.
 (Note: don't report an error if we aborted the parse due to a max limit of earthquakes.)
 */
- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    if ([parseError code] != NSXMLParserDelegateAbortedParseError) {
        if(self.parseURLCompletion) {
            self.parseURLCompletion(nil);
        }
    }
}

@end
