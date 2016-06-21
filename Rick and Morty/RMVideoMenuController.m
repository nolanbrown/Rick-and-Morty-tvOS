//
//  RMVideoMenuController.m
//  Rick and Morty
//
//  Created by Nolan Brown on 11/26/15.
//
//

#import "RMVideoMenuController.h"
#import "RMVideoManager.h"
#import "RMVideoDetailViewController.h"

#import <AVKit/AVKit.h>


@interface RMVideoMenuController ()
@property (nonatomic, strong) RMVideoManager *manager;

@end

@implementation RMVideoMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;

    self.manager = [[RMVideoManager alloc] init];
    self.manager.onLoadCompletion = ^{
        [weakSelf.tableView reloadData];
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Season 1";
            break;
        case 1:
            return @"Season 2";
            break;
        default:
            break;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.manager getSeason:(section + 1)].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    NSArray *videos = [self.manager getSeason:(indexPath.section + 1)];
    RMVideo *video = videos[indexPath.row];
    cell.textLabel.text = video.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Episode %@ (%@)",video.episode,video.formmattedTime];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *videos = [self.manager getSeason:(indexPath.section + 1)];
    RMVideo *video = videos[indexPath.row];
    
    AVPlayerViewController *player = [[AVPlayerViewController alloc] init];
    player.player = [[AVPlayer alloc] initWithURL:video.streamURL];
    
    [self.splitViewController.navigationController pushViewController:player animated:YES];
    [player.player play];
}

- (void)tableView:(UITableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    
    NSIndexPath *indexPath = context.nextFocusedIndexPath;
    if(indexPath.row && indexPath.section) {
        NSArray *videos = [self.manager getSeason:(indexPath.section + 1)];
        RMVideo *video = videos[indexPath.row];
        
        RMVideoDetailViewController *detail = self.splitViewController.viewControllers[1];
        [detail setCurrentVideo:video];
    }

}


@end
