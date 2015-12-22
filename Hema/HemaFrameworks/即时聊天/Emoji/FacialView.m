//
//  FacialView.m
//  KeyBoardTest
//
//  Created by wangqiulei on 11-8-16.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FacialView.h"


@implementation FacialView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self)
    {
        //faces=[EmojiEmoticons allEmoticons];
        //faces=[Emoji allEmoji];
        //NSLog(@"数据：%d,%@",faces.count,faces);
//        faces=[EmojiPictographs allPictographs];
        /*
        faces = [NSArray arrayWithObjects:[Emoji emojiWithCode:0x1F319],
                 [Emoji emojiWithCode:0x1F31f],[Emoji emojiWithCode:0x1F334],[Emoji emojiWithCode:0x1F339],
                 [Emoji emojiWithCode:0x1F340],[Emoji emojiWithCode:0x1F349],[Emoji emojiWithCode:0x1F34a],
                 [Emoji emojiWithCode:0x1F34e],[Emoji emojiWithCode:0x1F353],[Emoji emojiWithCode:0x1F35c],
                 [Emoji emojiWithCode:0x1F35d],[Emoji emojiWithCode:0x1F35e],[Emoji emojiWithCode:0x1F35f],
                 [Emoji emojiWithCode:0x1F37a],[Emoji emojiWithCode:0x1F384],[Emoji emojiWithCode:0x1F3a4],
                 [Emoji emojiWithCode:0x1F3b5],[Emoji emojiWithCode:0x1F3b8],[Emoji emojiWithCode:0x1F3be],
                 [Emoji emojiWithCode:0x1F3c0],[Emoji emojiWithCode:0x1F40d],[Emoji emojiWithCode:0x1F40e],
                 [Emoji emojiWithCode:0x1F414],[Emoji emojiWithCode:0x1F419],[Emoji emojiWithCode:0x1F41a],
                 [Emoji emojiWithCode:0x1F41b],[Emoji emojiWithCode:0x1F420],[Emoji emojiWithCode:0x1F424],
                 [Emoji emojiWithCode:0x1F427],[Emoji emojiWithCode:0x1F428],[Emoji emojiWithCode:0x1F42c],
                 [Emoji emojiWithCode:0x1F42d],[Emoji emojiWithCode:0x1F42e],[Emoji emojiWithCode:0x1F42f],
                 [Emoji emojiWithCode:0x1F433],[Emoji emojiWithCode:0x1F435],[Emoji emojiWithCode:0x1F436],
                 [Emoji emojiWithCode:0x1F437],[Emoji emojiWithCode:0x1F438],[Emoji emojiWithCode:0x1F440],
                 [Emoji emojiWithCode:0x1F444],[Emoji emojiWithCode:0x1F446],[Emoji emojiWithCode:0x1F447],
                 [Emoji emojiWithCode:0x1F448],[Emoji emojiWithCode:0x1F449],[Emoji emojiWithCode:0x1F44a],
                 [Emoji emojiWithCode:0x1F44c],[Emoji emojiWithCode:0x1F44d],[Emoji emojiWithCode:0x1F44e],
                 [Emoji emojiWithCode:0x1F44f],[Emoji emojiWithCode:0x1F466],[Emoji emojiWithCode:0x1F467],
                 [Emoji emojiWithCode:0x1F468],[Emoji emojiWithCode:0x1F469],[Emoji emojiWithCode:0x1F47f],
                 [Emoji emojiWithCode:0x1F493],[Emoji emojiWithCode:0x1F494],[Emoji emojiWithCode:0x1F525],
                 [Emoji emojiWithCode:0x1F601],[Emoji emojiWithCode:0x1F602],[Emoji emojiWithCode:0x1F603],
                 [Emoji emojiWithCode:0x1F604],[Emoji emojiWithCode:0x1F609],[Emoji emojiWithCode:0x1F60a],
                 [Emoji emojiWithCode:0x1F60c],[Emoji emojiWithCode:0x1F60d],[Emoji emojiWithCode:0x1F60f],
                 [Emoji emojiWithCode:0x1F612],[Emoji emojiWithCode:0x1F613],[Emoji emojiWithCode:0x1F614],
                 [Emoji emojiWithCode:0x1F616],[Emoji emojiWithCode:0x1F618],[Emoji emojiWithCode:0x1F61a],
                 [Emoji emojiWithCode:0x1F61c],[Emoji emojiWithCode:0x1F61d],[Emoji emojiWithCode:0x1F61e],
                 [Emoji emojiWithCode:0x1F620],[Emoji emojiWithCode:0x1F621],[Emoji emojiWithCode:0x1F622],
                 [Emoji emojiWithCode:0x1F623],[Emoji emojiWithCode:0x1F628],[Emoji emojiWithCode:0x1F62a],
                 [Emoji emojiWithCode:0x1F62d],[Emoji emojiWithCode:0x1F630],[Emoji emojiWithCode:0x1F631],
                 [Emoji emojiWithCode:0x1F632],[Emoji emojiWithCode:0x1F633],[Emoji emojiWithCode:0x1F637],
                 [Emoji emojiWithCode:0x2600],[Emoji emojiWithCode:0x2601],[Emoji emojiWithCode:0x2615],
                 [Emoji emojiWithCode:0x261d],[Emoji emojiWithCode:0x263a],[Emoji emojiWithCode:0x26a1],
                 [Emoji emojiWithCode:0x26bd],[Emoji emojiWithCode:0x2708],[Emoji emojiWithCode:0x270a],
                 [Emoji emojiWithCode:0x270b],[Emoji emojiWithCode:0x270c],[Emoji emojiWithCode:0x2728],nil];
         */
        faces = [[NSArray alloc]initWithObjects:
                 [Emoji emojiWithCode:0x1F601],[Emoji emojiWithCode:0x1F602],[Emoji emojiWithCode:0x1F603],
                 [Emoji emojiWithCode:0x1F604],[Emoji emojiWithCode:0x1F609],[Emoji emojiWithCode:0x1F60a],
                 [Emoji emojiWithCode:0x1F60c],[Emoji emojiWithCode:0x1F60d],[Emoji emojiWithCode:0x1F60f],
                 [Emoji emojiWithCode:0x1F612],[Emoji emojiWithCode:0x1F613],[Emoji emojiWithCode:0x1F614],
                 [Emoji emojiWithCode:0x1F616],[Emoji emojiWithCode:0x1F618],[Emoji emojiWithCode:0x1F61a],
                 [Emoji emojiWithCode:0x1F61c],[Emoji emojiWithCode:0x1F61d],[Emoji emojiWithCode:0x1F61e],
                 [Emoji emojiWithCode:0x1F620],[Emoji emojiWithCode:0x1F621],[Emoji emojiWithCode:0x1F622],
                 [Emoji emojiWithCode:0x1F623],[Emoji emojiWithCode:0x1F628],[Emoji emojiWithCode:0x1F62a],
                 [Emoji emojiWithCode:0x1F62d],[Emoji emojiWithCode:0x1F630],[Emoji emojiWithCode:0x1F631],
                 [Emoji emojiWithCode:0x1F632],[Emoji emojiWithCode:0x1F633],[Emoji emojiWithCode:0x1F637],
                 [Emoji emojiWithCode:0x1F319],
                 [Emoji emojiWithCode:0x1F31f],[Emoji emojiWithCode:0x1F334],[Emoji emojiWithCode:0x1F339],
                 [Emoji emojiWithCode:0x1F340],[Emoji emojiWithCode:0x1F349],[Emoji emojiWithCode:0x1F34a],
                 [Emoji emojiWithCode:0x1F34e],[Emoji emojiWithCode:0x1F353],[Emoji emojiWithCode:0x1F35c],
                 [Emoji emojiWithCode:0x1F35d],[Emoji emojiWithCode:0x1F35e],[Emoji emojiWithCode:0x1F35f],
                 [Emoji emojiWithCode:0x1F37a],[Emoji emojiWithCode:0x1F384],[Emoji emojiWithCode:0x1F3a4],
                 [Emoji emojiWithCode:0x1F3b5],[Emoji emojiWithCode:0x1F3b8],[Emoji emojiWithCode:0x1F3be],
                 [Emoji emojiWithCode:0x1F3c0],[Emoji emojiWithCode:0x1F40d],[Emoji emojiWithCode:0x1F40e],
                 [Emoji emojiWithCode:0x1F414],[Emoji emojiWithCode:0x1F419],[Emoji emojiWithCode:0x1F41a],
                 [Emoji emojiWithCode:0x1F41b],[Emoji emojiWithCode:0x1F420],[Emoji emojiWithCode:0x1F424],
                 [Emoji emojiWithCode:0x1F427],[Emoji emojiWithCode:0x1F428],[Emoji emojiWithCode:0x1F42c],
                 [Emoji emojiWithCode:0x1F42d],[Emoji emojiWithCode:0x1F42e],[Emoji emojiWithCode:0x1F42f],
                 [Emoji emojiWithCode:0x1F433],[Emoji emojiWithCode:0x1F435],[Emoji emojiWithCode:0x1F436],
                 [Emoji emojiWithCode:0x1F437],[Emoji emojiWithCode:0x1F438],[Emoji emojiWithCode:0x1F440],
                 [Emoji emojiWithCode:0x1F444],[Emoji emojiWithCode:0x1F446],[Emoji emojiWithCode:0x1F447],
                 [Emoji emojiWithCode:0x1F448],[Emoji emojiWithCode:0x1F449],[Emoji emojiWithCode:0x1F44a],
                 [Emoji emojiWithCode:0x1F44c],[Emoji emojiWithCode:0x1F44d],[Emoji emojiWithCode:0x1F44e],
                 [Emoji emojiWithCode:0x1F44f],[Emoji emojiWithCode:0x1F466],[Emoji emojiWithCode:0x1F467],
                 [Emoji emojiWithCode:0x1F468],[Emoji emojiWithCode:0x1F469],[Emoji emojiWithCode:0x1F47f],
                 [Emoji emojiWithCode:0x1F493],[Emoji emojiWithCode:0x1F494],[Emoji emojiWithCode:0x1F525],
                 
                 [Emoji emojiWithCode:0x1F4a3],[Emoji emojiWithCode:0x1F4a4],[Emoji emojiWithCode:0x1F4a9],
                 [Emoji emojiWithCode:0x1F4b0],[Emoji emojiWithCode:0x1F4bb],[Emoji emojiWithCode:0x1F4de],
                 [Emoji emojiWithCode:0x1F4f1],[Emoji emojiWithCode:0x1F6ac],[Emoji emojiWithCode:0x1F48d],
                 [Emoji emojiWithCode:0x1F49d],[Emoji emojiWithCode:0x1F680],[Emoji emojiWithCode:0x1F683],
                 [Emoji emojiWithCode:0x1F684],[Emoji emojiWithCode:0x1F691],[Emoji emojiWithCode:0x1F692],
                 [Emoji emojiWithCode:0x1F693],[Emoji emojiWithCode:0x1F697],
                 nil];
    }
    return self;
}

-(void)loadFacialView:(int)page size:(CGSize)size
{
	//row number
	for (int i=0; i<4; i++) {
		//column numer
		for (int y=0; y<9; y++)
        {
			UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
            [button setBackgroundColor:[UIColor clearColor]];
            [button setFrame:CGRectMake(y*size.width, i*size.height, size.width, size.height)];
            if (i==3&&y==8)
            {
                [button setImage:[UIImage imageNamed:@"myfaceDelete"] forState:UIControlStateNormal];
                button.tag=10000;
            }else
            {
                [button.titleLabel setFont:[UIFont fontWithName:@"AppleColorEmoji" size:29.0]];
                [button setTitle: [faces objectAtIndex:i*9+y+(page*35)]forState:UIControlStateNormal];
                button.tag=i*9+y+(page*35);
            }
			[button addTarget:self action:@selector(selected:) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:button];
		}
	}
}


-(void)selected:(UIButton*)bt
{
    if (bt.tag>10000)
    {
        return;
    }
    if (bt.tag==10000)
    {
        //NSLog(@"点击删除");
        [delegate selectedFacialView:@"删除"];
    }else
    {
        NSString *str=[faces objectAtIndex:bt.tag];
        //NSLog(@"点击其他%@",str);
        [delegate selectedFacialView:str];
    }	
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/
- (void)dealloc {
    [super dealloc];
}
@end
