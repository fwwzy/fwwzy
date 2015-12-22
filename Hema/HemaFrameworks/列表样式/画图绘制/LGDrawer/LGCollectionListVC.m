//
//  LGCollectionListVC.m
//  Hema
//
//  Created by LarryRodic on 15/10/18.
//  Copyright (c) 2015年 Hemaapp. All rights reserved.
//
#define kSide 60.f
#define kSize CGSizeMake(60.f, 60.f)
#define kImageSide 90.f
#define kImageSize CGSizeMake(90.f, 90.f)
#define kBackgroundColor [UIColor colorWithWhite:0.9 alpha:1.f]
#define kOffset CGPointMake(-1.f, -1.f)
#define kRotate 0.f
#define kCornerRadius 12.f
#define kFillColor [UIColor colorWithRed:0.f green:0.5 blue:1.f alpha:1.f]
#define kStrokeColor        [UIColor whiteColor]
#define kStrokeThickness    2.f
#define kStrokeDash         @[@4.f, @2.f]
#define kStrokeType         LGDrawerStrokeTypeCenter
#define kShadowColor    [UIColor colorWithWhite:0.f alpha:0.6]
#define kShadowOffset   CGPointMake(2.f, 2.f)
#define kShadowBlur     6.f
#define kShadowType     LGDrawerShadowTypeFill
#define kThinckness     12.f

#import "LGCollectionListVC.h"
#import "RCollectionCell.h"
#import "LGDrawer.h"

@interface LGCollectionListVC ()
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation LGCollectionListVC
@synthesize dataSource;

-(void)loadSet
{
    [self.navigationItem setNewTitle:@"LG绘图"];
    self.mytable.numColsPortrait = 4;
    [self forbidPullRefresh];
}
-(void)loadData
{
    dataSource = [[NSMutableArray alloc]init];
    
    [dataSource addObject:[LGDrawer drawRectangleWithImageSize:kImageSize
                                                          size:kSize
                                                        offset:kOffset
                                                        rotate:kRotate
                                                roundedCorners:UIRectCornerBottomLeft|UIRectCornerTopRight
                                                  cornerRadius:kCornerRadius
                                               backgroundColor:kBackgroundColor
                                                     fillColor:kFillColor
                                                   strokeColor:kStrokeColor
                                               strokeThickness:kStrokeThickness
                                                    strokeDash:kStrokeDash
                                                    strokeType:kStrokeType
                                                   shadowColor:kShadowColor
                                                  shadowOffset:kShadowOffset
                                                    shadowBlur:kShadowBlur]];
    
    [dataSource addObject:[LGDrawer drawEllipseWithImageSize:kImageSize
                                                        size:kSize
                                                      offset:kOffset
                                                      rotate:kRotate
                                             backgroundColor:kBackgroundColor
                                                   fillColor:kFillColor
                                                 strokeColor:kStrokeColor
                                             strokeThickness:kStrokeThickness
                                                  strokeDash:kStrokeDash
                                                  strokeType:kStrokeType
                                                 shadowColor:kShadowColor
                                                shadowOffset:kShadowOffset
                                                  shadowBlur:kShadowBlur]];
    
    [dataSource addObject:[LGDrawer drawTriangleWithImageSize:kImageSize
                                                         size:CGSizeMake(kSide+kCornerRadius/2, kSide+kCornerRadius/2)
                                                       offset:kOffset
                                                       rotate:kRotate
                                                 cornerRadius:kCornerRadius/2
                                                    direction:LGDrawerDirectionTop
                                              backgroundColor:kBackgroundColor
                                                    fillColor:kFillColor
                                                  strokeColor:kStrokeColor
                                              strokeThickness:kStrokeThickness
                                                   strokeDash:kStrokeDash
                                                  shadowColor:kShadowColor
                                                 shadowOffset:kShadowOffset
                                                   shadowBlur:kShadowBlur]];
    
    [dataSource addObject:[LGDrawer drawPlusWithImageSize:kImageSize
                                                     size:kSize
                                                   offset:kOffset
                                                   rotate:kRotate
                                                thickness:kThinckness
                                           roundedCorners:UIRectCornerBottomLeft|UIRectCornerTopRight
                                             cornerRadius:kCornerRadius
                                          backgroundColor:kBackgroundColor
                                                fillColor:kFillColor
                                              strokeColor:kStrokeColor
                                          strokeThickness:kStrokeThickness
                                               strokeDash:kStrokeDash
                                               strokeType:kStrokeType
                                              shadowColor:kShadowColor
                                             shadowOffset:kShadowOffset
                                               shadowBlur:kShadowBlur]];
    
    [dataSource addObject:[LGDrawer drawCrossWithImageSize:kImageSize
                                                      size:kSize
                                                    offset:kOffset
                                                    rotate:kRotate
                                                 thickness:kThinckness
                                            roundedCorners:UIRectCornerBottomLeft|UIRectCornerTopRight
                                              cornerRadius:kCornerRadius
                                           backgroundColor:kBackgroundColor
                                                 fillColor:kFillColor
                                               strokeColor:kStrokeColor
                                           strokeThickness:kStrokeThickness
                                                strokeDash:kStrokeDash
                                                strokeType:kStrokeType
                                               shadowColor:kShadowColor
                                              shadowOffset:kShadowOffset
                                                shadowBlur:kShadowBlur]];
    
    [dataSource addObject:[LGDrawer drawTickWithImageSize:kImageSize
                                                     size:kSize
                                                   offset:kOffset
                                                   rotate:kRotate
                                                thickness:kThinckness*0.66
                                          backgroundColor:kBackgroundColor
                                                    color:kFillColor
                                                     dash:nil
                                              shadowColor:kShadowColor
                                             shadowOffset:kShadowOffset
                                               shadowBlur:kShadowBlur]];
    
    [dataSource addObject:[LGDrawer drawArrowWithImageSize:kImageSize
                                                      size:CGSizeMake(kSide*0.66, kSide)
                                                    offset:kOffset
                                                    rotate:kRotate
                                                 thickness:kThinckness*0.66
                                                 direction:LGDrawerDirectionLeft
                                           backgroundColor:kBackgroundColor
                                                     color:kFillColor
                                                      dash:nil
                                               shadowColor:kShadowColor
                                              shadowOffset:kShadowOffset
                                                shadowBlur:kShadowBlur]];
    
    [dataSource addObject:[LGDrawer drawArrowTailedWithImageSize:kImageSize
                                                            size:kSize
                                                          offset:kOffset
                                                          rotate:kRotate
                                                       thickness:kThinckness*0.66
                                                       direction:LGDrawerDirectionBottomRight
                                                 backgroundColor:kBackgroundColor
                                                           color:kFillColor
                                                            dash:nil
                                                     shadowColor:kShadowColor
                                                    shadowOffset:kShadowOffset
                                                      shadowBlur:kShadowBlur]];
    
    [dataSource addObject:[LGDrawer drawLineWithImageSize:kImageSize
                                                   length:kSide
                                                   offset:kOffset
                                                   rotate:kRotate
                                                thickness:kThinckness
                                                direction:LGDrawerLineDirectionVertical
                                          backgroundColor:kBackgroundColor
                                                    color:kFillColor
                                                     dash:kStrokeDash
                                              shadowColor:kShadowColor
                                             shadowOffset:kShadowOffset
                                               shadowBlur:kShadowBlur]];
    
    [dataSource addObject:[LGDrawer drawPlusWithImageSize:kImageSize
                                                     size:kSize
                                                   offset:kOffset
                                                   rotate:kRotate
                                                thickness:kThinckness*0.66
                                          backgroundColor:kBackgroundColor
                                                    color:kFillColor
                                                     dash:kStrokeDash
                                              shadowColor:kShadowColor
                                             shadowOffset:kShadowOffset
                                               shadowBlur:kShadowBlur]];
    
    [dataSource addObject:[LGDrawer drawCrossWithImageSize:kImageSize
                                                      size:kSize
                                                    offset:kOffset
                                                    rotate:kRotate
                                                 thickness:kThinckness*0.66
                                           backgroundColor:kBackgroundColor
                                                     color:kFillColor
                                                      dash:kStrokeDash
                                               shadowColor:kShadowColor
                                              shadowOffset:kShadowOffset
                                                shadowBlur:kShadowBlur]];
    
    [dataSource addObject:[LGDrawer drawHeartWithImageSize:kImageSize
                                                      size:kSize
                                                    offset:kOffset
                                                    rotate:kRotate
                                           backgroundColor:kBackgroundColor
                                                 fillColor:[UIColor colorWithRed:1.f green:0.f blue:0.3 alpha:1.f]
                                               strokeColor:kStrokeColor
                                           strokeThickness:kStrokeThickness
                                                strokeDash:kStrokeDash
                                               shadowColor:kShadowColor
                                              shadowOffset:kShadowOffset
                                                shadowBlur:kShadowBlur]];
    
    [dataSource addObject:[LGDrawer drawStarWithImageSize:kImageSize
                                                     size:kSize
                                                   offset:kOffset
                                                   rotate:kRotate
                                          backgroundColor:kBackgroundColor
                                                fillColor:[UIColor yellowColor]
                                              strokeColor:kFillColor
                                          strokeThickness:kStrokeThickness
                                               strokeDash:kStrokeDash
                                              shadowColor:kShadowColor
                                             shadowOffset:kShadowOffset
                                               shadowBlur:kShadowBlur]];
    
    CGSize size = CGSizeMake(kSide*0.8, kSide*0.6);
    CGFloat thickness = size.height/4;
    
    [dataSource addObject:[LGDrawer drawMenuWithImageSize:kImageSize
                                                     size:size
                                                   offset:kOffset
                                                   rotate:kRotate
                                                thickness:thickness
                                                   dotted:YES
                                             dotsPosition:LGDrawerMenuDotsPositionLeft
                                         dotsCornerRadius:thickness/2
                                        linesCornerRadius:thickness/2
                                          backgroundColor:kBackgroundColor
                                                fillColor:kFillColor
                                              strokeColor:nil
                                          strokeThickness:0.f
                                               strokeDash:nil
                                              shadowColor:kShadowColor
                                             shadowOffset:kShadowOffset
                                               shadowBlur:kShadowBlur]];
    
    // -----
    
    size = CGSizeMake(kImageSide*0.9, kImageSide*0.9);
    
    UIImage *image1 = [LGDrawer drawEllipseWithImageSize:kImageSize
                                                    size:size
                                                  offset:CGPointZero
                                                  rotate:0.f
                                         backgroundColor:kBackgroundColor
                                               fillColor:kFillColor
                                             strokeColor:nil
                                         strokeThickness:0.f
                                              strokeDash:nil
                                              strokeType:0
                                             shadowColor:nil
                                            shadowOffset:CGPointZero
                                              shadowBlur:0.f];
    
    size = CGSizeMake(kImageSide*0.55, kImageSide*0.55);
    
    UIImage *image2 = [LGDrawer drawRectangleWithImageSize:size
                                                      size:size
                                                    offset:CGPointZero
                                                    rotate:0.f
                                            roundedCorners:UIRectCornerAllCorners
                                              cornerRadius:5.f
                                           backgroundColor:nil
                                                 fillColor:kBackgroundColor
                                               strokeColor:[UIColor colorWithRed:1.f green:0.f blue:0.3 alpha:1.f]
                                           strokeThickness:2.f
                                                strokeDash:nil
                                                strokeType:0
                                               shadowColor:nil
                                              shadowOffset:CGPointZero
                                                shadowBlur:0.f];
    
    size = CGSizeMake(kImageSide*0.35, kImageSide*0.35);
    
    UIImage *image3 = [LGDrawer drawHeartWithImageSize:size
                                                  size:size
                                                offset:CGPointZero
                                                rotate:0.f
                                       backgroundColor:nil
                                             fillColor:[UIColor colorWithRed:1.f green:0.f blue:0.3 alpha:1.f]
                                           strokeColor:nil
                                       strokeThickness:0.f
                                            strokeDash:nil
                                           shadowColor:nil
                                          shadowOffset:CGPointZero
                                            shadowBlur:0.f];
    
    [dataSource addObject:[LGDrawer drawImageOnImage:@[image1,
                                                       image2,
                                                       image3]]];
    
    // -----
    
    size = CGSizeMake(kImageSide*0.9, kImageSide*0.9);
    
    image1 = [LGDrawer drawTriangleWithImageSize:kImageSize
                                            size:size
                                          offset:CGPointZero
                                          rotate:0.f
                                    cornerRadius:0.f
                                       direction:LGDrawerDirectionTop
                                 backgroundColor:kBackgroundColor
                                       fillColor:kFillColor
                                     strokeColor:nil
                                 strokeThickness:0.f
                                      strokeDash:nil
                                     shadowColor:nil
                                    shadowOffset:CGPointZero
                                      shadowBlur:0.f];
    
    size = CGSizeMake(kImageSide*0.45, kImageSide*0.45);
    
    image2 = [LGDrawer drawStarWithImageSize:size
                                        size:size
                                      offset:CGPointZero
                                      rotate:0.f
                             backgroundColor:nil
                                   fillColor:[UIColor yellowColor]
                                 strokeColor:nil
                             strokeThickness:0.f
                                  strokeDash:nil
                                 shadowColor:nil
                                shadowOffset:CGPointZero
                                  shadowBlur:0.f];
    
    size = CGSizeMake(kImageSide*0.35, kImageSide*0.35);
    
    image3 = [LGDrawer drawStarWithImageSize:size
                                        size:size
                                      offset:CGPointZero
                                      rotate:0.f
                             backgroundColor:nil
                                   fillColor:kFillColor
                                 strokeColor:nil
                             strokeThickness:0.f
                                  strokeDash:nil
                                 shadowColor:nil
                                shadowOffset:CGPointZero
                                  shadowBlur:0.f];
    
    size = CGSizeMake(kImageSide*0.3, kImageSide*0.3);
    
    UIImage *image4 = [LGDrawer drawStarWithImageSize:size
                                                 size:size
                                               offset:CGPointZero
                                               rotate:0.f
                                      backgroundColor:nil
                                            fillColor:[UIColor blackColor]
                                          strokeColor:nil
                                      strokeThickness:0.f
                                           strokeDash:nil
                                          shadowColor:nil
                                         shadowOffset:CGPointZero
                                           shadowBlur:0.f];
    
    UIImage *image5 = [LGDrawer drawImagesWithFinishSize:kImageSize
                                                  image1:image1
                                            image1Offset:CGPointZero
                                                  image2:image2
                                            image2Offset:CGPointMake(0.f, 12.f)
                                                   clear:NO];
    
    image5 = [LGDrawer drawImagesWithFinishSize:kImageSize
                                         image1:image5
                                   image1Offset:CGPointZero
                                         image2:image3
                                   image2Offset:CGPointMake(0.f, 12.5)
                                          clear:NO];
    
    image5 = [LGDrawer drawImagesWithFinishSize:kImageSize
                                         image1:image5
                                   image1Offset:CGPointZero
                                         image2:image4
                                   image2Offset:CGPointMake(0.f, 12.5)
                                          clear:YES];
    
    [dataSource addObject:image5];
}
#pragma mark - PSCollectionViewDelegate and DataSource
- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView
{
    return dataSource.count;
}
- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index
{
    RCollectionCell *cell = (RCollectionCell *)[collectionView dequeueReusableViewForClass:[RCollectionCell class]];
    if (!cell)
    {
        cell = [[RCollectionCell alloc] initWithFrame:CGRectZero];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.topImgView.tag = 100+index;
    [cell.topImgView setImage:[dataSource objectAtIndex:index]];
    
    return cell;
}
- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index
{
    return (UI_View_Width-20)/4-5;
}
- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index
{
    
}
@end
