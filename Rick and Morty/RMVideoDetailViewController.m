//
//  RMVideoDetailViewController.m
//  Rick and Morty
//
//  Created by Nolan Brown on 11/27/15.
//
//

#import "RMVideoDetailViewController.h"

@interface RMVideoDetailViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *descriptionLabel;

@end

@implementation RMVideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height / 2)];
    self.imageView.translatesAutoresizingMaskIntoConstraints = YES;
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.imageView.clipsToBounds = YES;
    ///self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.imageView];
    
    
    self.descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, self.imageView.frame.size.height + 20, self.view.frame.size.width - 40, 200)];
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.font = [UIFont systemFontOfSize:40];
    self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = YES;
    self.descriptionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.descriptionLabel];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) setCurrentVideo: (RMVideo *) video
{
    self.video = video;
    self.descriptionLabel.text = self.video.details;
    self.imageView.image = nil;
    self.imageView.contentMode = UIViewContentModeCenter;

    [self.video loadPreviewImage:^(UIImage *image) {
        
        self.imageView.contentMode = UIViewContentModeCenter;
        self.imageView.image = image;

    }];
}

@end
