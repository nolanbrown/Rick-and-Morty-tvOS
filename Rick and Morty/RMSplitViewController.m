//
//  RMSplitViewController.m
//  Rick and Morty
//
//  Created by Nolan Brown on 11/27/15.
//
//

// Cloned and converted to ObjC from Swift from the TvOS UIKit Sample Code

#import "RMSplitViewController.h"
#import "RMVideoMenuController.h"

@interface RMSplitViewController ()
@property (nonatomic) BOOL preferDetailViewControllerOnNextFocusUpdate;
@property (nonatomic, strong) UIView *focusedView;

@end

@implementation RMSplitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.preferDetailViewControllerOnNextFocusUpdate = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *) preferredFocusedView {
    if(self.preferDetailViewControllerOnNextFocusUpdate) {
        self.focusedView = self.viewControllers.lastObject.preferredFocusedView;
        self.preferDetailViewControllerOnNextFocusUpdate = NO;
    }
    else {
        self.focusedView = super.preferredFocusedView;
    }
    
    return self.focusedView;
}

- (void) updateFocusToDetailViewController {
    self.preferDetailViewControllerOnNextFocusUpdate = YES;

    [self setNeedsFocusUpdate];
    [self updateFocusIfNeeded];
}


@end
