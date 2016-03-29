//
//  MainViewController.m
//  Navigation
//
//  Created by Tammy Coron on 1/19/13.
//  Copyright (c) 2013 Tammy L Coron. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


#import "MainViewController.h"
#import "CenterViewController.h"
#import "LeftPanelViewController.h"
#import "RightPanelViewController.h"


#define CENTER_TAG 100
#define LEFT_TAG 200
#define RIGHT_PANEL_TAG 300

#define CORNER_RADIUS 4
#define SLIDE_TIMING .25
#define PANEL_WIDTH 60


@interface MainViewController ()<CenterViewControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) CenterViewController *centerViewController;

@property (nonatomic, strong) LeftPanelViewController *leftPanelViewController;
@property (nonatomic, assign) BOOL showingLeftPanel;

@property (nonatomic, strong) RightPanelViewController *rightPanelViewController;
@property (nonatomic, assign) BOOL showingRightPanel;


@property (nonatomic, assign) BOOL showPanel;
@property (nonatomic, assign) CGPoint preVelocity;

@end

@implementation MainViewController

#pragma mark -
#pragma mark View Did Load/Unload

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupView];
    
    [self setupGestures];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

#pragma mark -
#pragma mark View Will/Did Appear

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

#pragma mark -
#pragma mark View Will/Did Disappear

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

#pragma mark -
#pragma mark Setup View

- (void)setupView
{
    // setup center view
    self.centerViewController = [[CenterViewController alloc] initWithNibName:@"CenterViewController" bundle:nil];
    self.centerViewController.view.tag = CENTER_TAG;
    self.centerViewController.delegate = self;
    
    [self.view addSubview:self.centerViewController.view];
    [self addChildViewController:self.centerViewController];
    
    [_centerViewController didMoveToParentViewController:self];
}

- (void)showCenterViewWithShadow:(BOOL)value withOffset:(double)offset{
    if (value) {
        
        [_centerViewController.view.layer setCornerRadius:CORNER_RADIUS];
        [_centerViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
        [_centerViewController.view.layer setShadowOpacity:0.8];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
        
        
    }else {
        [_centerViewController.view.layer setCornerRadius:0.0f];
        [_centerViewController.view.layer setShadowOffset:CGSizeMake(offset, offset)];
    }
}

- (void)resetMainView {
    if (_leftPanelViewController != nil) {
        [self.leftPanelViewController.view removeFromSuperview];
        self.leftPanelViewController = nil;
        
        _centerViewController.leftButton.tag = 1;
        self.showingLeftPanel = NO;
    }
    
    if (_rightPanelViewController != nil) {
        [self.rightPanelViewController.view removeFromSuperview];
        self.rightPanelViewController = nil;
        
        _centerViewController.rightButton.tag = 1;
        self.showingRightPanel = NO;
    }
    
    //remove view shadows
    [self showCenterViewWithShadow:NO withOffset:0];
}

- (UIView *)getLeftView
{    
    if (_leftPanelViewController == nil) {
        self.leftPanelViewController = [[LeftPanelViewController alloc] initWithNibName:@"LeftPanelViewController" bundle:nil];
        self.leftPanelViewController.view.tag = LEFT_TAG;
        self.leftPanelViewController.delegate = _centerViewController;
        
        [self.view addSubview:_leftPanelViewController.view];
        
        [self addChildViewController:_leftPanelViewController];
        [_leftPanelViewController didMoveToParentViewController:self];
        
        _leftPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    }
    
    self.showingLeftPanel = YES;
    
    // set up view shadows
    [self showCenterViewWithShadow:YES withOffset:-2];
    
    UIView *view = _leftPanelViewController.view;
    return view;
}

- (UIView *)getRightView
{
    if (_rightPanelViewController == nil) {
        _rightPanelViewController = [[RightPanelViewController alloc] initWithNibName:@"RightPanelViewController" bundle:nil];
        _rightPanelViewController.view.tag = RIGHT_PANEL_TAG;
        _rightPanelViewController.delegate = _centerViewController;
        
        [self.view addSubview:_rightPanelViewController.view];
        
        [self addChildViewController:_rightPanelViewController];
        [_rightPanelViewController didMoveToParentViewController:self];
        
        _rightPanelViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    }
    self.showingRightPanel = YES;
    
    // set up view shadows
    [self showCenterViewWithShadow:YES withOffset:2];
    
    UIView *view = self.rightPanelViewController.view;
    return view;
}

#pragma mark -
#pragma mark Swipe Gesture Setup/Actions

#pragma mark - setup

- (void)setupGestures {
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(movePanel:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    panRecognizer.delegate = self;
    
    [_centerViewController.view addGestureRecognizer:panRecognizer];
}

-(void)movePanel:(UIPanGestureRecognizer *)sender {
    [sender.view.layer removeAllAnimations];
    
    CGPoint translatedPoint = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:sender.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIView *childView = nil;
        if (velocity.x > 0) {
            if (!_showingRightPanel) {
                childView = [self getLeftView];
            }
        }else {
            if (!_showingLeftPanel) {
                childView = [self getRightView];
            }
        }
        
        // make sure the view you're working with is front and center
        [self.view sendSubviewToBack:childView];
        [[sender view] bringSubviewToFront:sender.view];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (velocity.x > 0) {
             // NSLog(@"gesture went right");
        }else {
            // NSLog(@"gesture went left");
        }
        
        if (!_showPanel) {
            [self movePanelToOriginalPosition];
        }else{
            // 需要显示面板
            if (_showingLeftPanel) {
                [self movePanelRight];
            } else if (_showingRightPanel){
                [self movePanelLeft];
            }
        }
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        if(velocity.x > 0) {
            // NSLog(@"gesture went right");
        } else {
            // NSLog(@"gesture went left");
        }
        
        // 滑动超过一半的时候需要显示面板
        _showPanel = fabs(sender.view.center.x - _centerViewController.view.frame.size.width / 2) > _centerViewController.view.frame.size.width / 2;
        sender.view.center = CGPointMake(sender.view.center.x + translatedPoint.x, sender.view.center.y);
        
        //再把形变设置为0，不然会因为不断调用这个方法，值会不断叠加，，
        //例如从0 - 3的距离应该只移动3，但是却变1+2+3 = 6，移动了6的距离
        // [tap setTranslation:CGPointZero inView:self.mainV];
        
        [sender setTranslation:CGPointMake(0, 0) inView:self.view];
        
        if (velocity.x * _preVelocity.x + velocity.y * _preVelocity.y > 0) {
             // NSLog(@"same direction");
        }else {
            // NSLog(@"opposite direction");
        }
        _preVelocity = velocity;
    }
}

#pragma mark -
#pragma mark Delegate Actions

// to show right panel
- (void)movePanelLeft {
    UIView *childView = [self getRightView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateKeyframesWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _centerViewController.view.frame = CGRectMake(-self.view.frame.size.width + PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        if (finished) {
            _centerViewController.rightButton.tag = 0;
        }
    }];
}

 // to show left panel
- (void)movePanelRight {
    UIView *childView = [self getLeftView];
    [self.view sendSubviewToBack:childView];
    
    [UIView animateWithDuration:SLIDE_TIMING animations:^{
        _centerViewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        if (finished) {
            _centerViewController.leftButton.tag = 0;
        }
    }];
}

- (void)movePanelToOriginalPosition {
    [UIView animateWithDuration:SLIDE_TIMING delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        _centerViewController.view.frame =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        if (finished) {
            [self resetMainView];
        }
    }];
}

#pragma mark -
#pragma mark Default System Code

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}





@end
