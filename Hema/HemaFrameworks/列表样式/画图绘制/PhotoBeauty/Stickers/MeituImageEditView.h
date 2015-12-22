
#import <UIKit/UIKit.h>
@protocol MeituImageEditViewDelegate;
@interface MeituImageEditView : UIScrollView<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView  *contentView;
@property (nonatomic, strong) UIBezierPath *realCellArea;
@property (nonatomic, strong) UIImageView   *imageview;
@property (nonatomic, assign) id<MeituImageEditViewDelegate> tapDelegate;
- (void)setImageViewData:(UIImage *)imageData;
@end


@protocol MeituImageEditViewDelegate <NSObject>

- (void)tapWithEditView:(MeituImageEditView *)sender;

@end