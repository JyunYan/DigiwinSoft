//
//  MVideoPlayerView.m
//  DigiwinSoft
//
//  Created by Jyun on 2015/9/11.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MVideoPlayerView.h"
#import "MConfig.h"
#import "MDirector.h"

@interface MVideoPlayerView ()

@property (nonatomic, strong) AVPlayer* player;
@property (nonatomic, strong) AVPlayerLayer* playerLayer;

@property (nonatomic, strong) UIToolbar* toolbar;
@property (nonatomic, strong) UIBarButtonItem* playButton;
@property (nonatomic, strong) UIBarButtonItem* pauseButton;
@property (nonatomic, strong) UISlider* slider;

@property (nonatomic, strong) id timeObserver;

@property (nonatomic, assign) BOOL isReadyToPlay;

@end

static void *AVPlayerDemoPlaybackViewControllerRateObservationContext = &AVPlayerDemoPlaybackViewControllerRateObservationContext;
static void *AVPlayerDemoPlaybackViewControllerStatusObservationContext = &AVPlayerDemoPlaybackViewControllerStatusObservationContext;
static void *AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext = &AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext;

@implementation MVideoPlayerView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        
        _isReadyToPlay = NO;
        
        //NSURL *url = [NSURL URLWithString:@"http://www.amigosoftware.com.tw/videos/gintama/playlist.m3u8"];
        
        AVAsset *avAsset = [AVURLAsset URLAssetWithURL:nil options:nil];
        AVPlayerItem *avPlayerItem = [[AVPlayerItem alloc] initWithAsset:avAsset];
        [avPlayerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
        _player = [AVPlayer playerWithPlayerItem:avPlayerItem];
        
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
        _playerLayer.frame = CGRectMake(0.0, 0.0, frame.size.width, frame.size.height);
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
        _playerLayer.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:_playerLayer];
        [_player play];
        
        [self initScrubberTimer];
        
        [self initControllBar];
        
        
        UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void) setUrl:(NSString *)url
{
    if(url.length == 0){
        [[MDirector sharedInstance] showAlertDialog:@"無影片路徑"];
        return;
    }
    if(![url hasPrefix:@"http"]){
        [[MDirector sharedInstance] showAlertDialog:@"影片路徑有誤"];
        return;
    }
    
    
    NSURL* URL = [NSURL URLWithString:url];
    AVAsset* asset = [AVURLAsset URLAssetWithURL:URL options:nil];
    AVPlayerItem* playerItem = [[AVPlayerItem alloc] initWithAsset:asset];
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:AVPlayerDemoPlaybackViewControllerStatusObservationContext];
    _player  = [AVPlayer playerWithPlayerItem:playerItem];
    [_player seekToTime:kCMTimeZero];
    [_player play];
    
    [_playerLayer setPlayer:_player];
}

- (void)initControllBar
{
    _playButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(play)];
    _pauseButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPause target:self action:@selector(pause)];
    
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *infoItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(hideControlBr:)];
    
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.75, self.frame.size.height*0.1)];
    _slider.minimumValue = 0;
    _slider.maximumValue = 100;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem* sliderItem = [[UIBarButtonItem alloc] initWithCustomView:_slider];
    
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.frame.size.height*0.8, self.frame.size.width, self.frame.size.height*0.2)];
    _toolbar.items = @[_pauseButton, flexItem, sliderItem, flexItem, infoItem];
    _toolbar.alpha = 0.5;
    _toolbar.hidden = YES;
    [self addSubview:_toolbar];
    
}

- (void)handleSingleTap:(UIGestureRecognizer*)sender
{
    if(!_isReadyToPlay)
        return;
    
    _toolbar.hidden = NO;
}

- (void)hideControlBr:(id)sender
{
    _toolbar.hidden = YES;
}

- (void)sliderValueChanged:(UISlider*)sender
{
    NSLog(@"%.0f", sender.value);
    
    CMTime time = CMTimeMakeWithSeconds(sender.value, 1);
    [_player.currentItem seekToTime:time];
}

- (void)play
{
    [_player play];
    [self showPauseButton];
}

- (void)pause
{
    [_player pause];
    [self showPlayButton];
}

- (void)showPlayButton
{
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[_toolbar items]];
    [toolbarItems replaceObjectAtIndex:0 withObject:_playButton];
    _toolbar.items = toolbarItems;
}

- (void)showPauseButton
{
    NSMutableArray *toolbarItems = [NSMutableArray arrayWithArray:[_toolbar items]];
    [toolbarItems replaceObjectAtIndex:0 withObject:_pauseButton];
    _toolbar.items = toolbarItems;
}

- (void)observeValueForKeyPath:(NSString*) path
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    /* AVPlayerItem "status" property value observer. */
    if (context == AVPlayerDemoPlaybackViewControllerStatusObservationContext)
    {
        AVPlayerItemStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        switch (status)
        {
                /* Indicates that the status of the player is not yet known because
                 it has not tried to load new media resources for playback */
            case AVPlayerItemStatusUnknown:
            {
                [self removePlayerTimeObserver];
                [self syncScrubber];
            }
                break;
                
            case AVPlayerItemStatusReadyToPlay:
            {
                _isReadyToPlay = YES;
                
                Float64 maxtime = CMTimeGetSeconds(_player.currentItem.duration);
                _slider.maximumValue = maxtime;
                _toolbar.hidden = NO;
                
                [self initScrubberTimer];
            }
                break;
                
            case AVPlayerItemStatusFailed:
            {
                [self removePlayerTimeObserver];
                [self syncScrubber];
            }
                break;
        }
    }
    /* AVPlayer "rate" property value observer. */
    else if (context == AVPlayerDemoPlaybackViewControllerRateObservationContext)
    {
        NSLog(@"rate = %.0f", _player.rate);
    }
    /* AVPlayer "currentItem" property observer.
     Called when the AVPlayer replaceCurrentItemWithPlayerItem:
     replacement will/did occur. */
    else if (context == AVPlayerDemoPlaybackViewControllerCurrentItemObservationContext)
    {
        AVPlayerItem *newPlayerItem = [change objectForKey:NSKeyValueChangeNewKey];
        
        /* Is the new player item null? */
        if (newPlayerItem == (id)[NSNull null])
        {
           
        }
        else /* Replacement of player currentItem has occurred */
        {
            /* Set the AVPlayer for which the player layer displays visual output. */
           
            
            /* Specifies that the player should preserve the video’s aspect ratio and
             fit the video within the layer’s bounds. */
        }
    }
    else
    {
       
    }
}

-(void)initScrubberTimer
{
    double interval = .1f;
    
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        return;
    }
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        CGFloat width = CGRectGetWidth([_slider bounds]);
        interval = 0.5f * duration / width;
    }
    
    /* Update the scrubber during normal playback. */
    __weak MVideoPlayerView *weakSelf = self;
    _timeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(interval, NSEC_PER_SEC)
                                                          queue:NULL /* If you pass NULL, the main queue is used. */
                                                     usingBlock:^(CMTime time)
                     {
                         [weakSelf syncScrubber];
                     }];
}

/* Set the scrubber based on the player current time. */
- (void)syncScrubber
{
    CMTime playerDuration = [self playerItemDuration];
    if (CMTIME_IS_INVALID(playerDuration))
    {
        _slider.minimumValue = 0.0;
        return;
    }
    
    double duration = CMTimeGetSeconds(playerDuration);
    if (isfinite(duration))
    {
        float minValue = [_slider minimumValue];
        float maxValue = [_slider maximumValue];
        double time = CMTimeGetSeconds([_player currentTime]);
        
        [_slider setValue:(maxValue - minValue) * time / duration + minValue];
    }
}

- (CMTime)playerItemDuration
{
    AVPlayerItem *playerItem = [_player currentItem];
    if (playerItem.status == AVPlayerItemStatusReadyToPlay)
    {
        return([playerItem duration]);
    }
    
    return(kCMTimeInvalid);
}

-(void)removePlayerTimeObserver
{
    if (_timeObserver)
    {
        [_player removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
}

- (void)dealloc
{
    [self removePlayerTimeObserver];
    [_player.currentItem removeObserver:self forKeyPath:@"status"];
    [_player pause];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
