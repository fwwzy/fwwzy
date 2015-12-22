//
//  Player.h
//  Player
//
//  Created by Zac on 15/11/6.
//  Copyright © 2015年 lanou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface Player : UIView
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
- (instancetype)initWithFrame:(CGRect)frame URL:(NSString *)URL;
@property(nonatomic,strong)void(^PlayerBack)(Player *playView);//返回block回调
@end
