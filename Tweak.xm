#define kBundlePath @"/Library/Application Support/HomeCardIconLabel/HomeCardIconLabelBundle.bundle"

@interface SBDisplayItem : NSObject
@property (nonatomic,copy,readonly) NSString * displayIdentifier;
@end

@interface SBDeckSwitcherIconImageContainerView : UIView
@end

@interface SBDeckSwitcherItemContainer : UIView
@property (nonatomic,readonly) SBDisplayItem * displayItem;
-(CGRect)_frameForIconTitle:(id)arg1;
@end

@interface SBDeckSwitcherViewController : UIViewController
-(id)_itemContainerForDisplayItem:(id)arg1;
@end

@interface SBReduceMotionDeckSwitcherViewController : SBDeckSwitcherViewController
@end

%hook SBDeckSwitcherViewController
-(BOOL)shouldShowIconAndLabelOfContainer:(id)arg1 {
	return YES;
}
%end

%hook SBDeckSwitcherItemContainer
-(void)prepareToBecomeVisibleIfNecessary {
	%orig();

	UILabel *_iconTitle = MSHookIvar<UILabel *>(self, "_iconTitle");
	SBDeckSwitcherIconImageContainerView *_iconImageView = MSHookIvar<SBDeckSwitcherIconImageContainerView *>(self, "_iconImageView");
	if (_iconTitle != nil && _iconImageView != nil && [self.displayItem.displayIdentifier isEqualToString:@"com.apple.springboard"]) {
		NSBundle *bundle = [[NSBundle alloc] initWithPath:kBundlePath];
		UIImageView* _imageView = MSHookIvar<UIImageView *>(_iconImageView, "_imageView");
		[_imageView setImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"Home" ofType:@"png"]]];
		[bundle release];

		[_iconTitle setText:@"Home"];
		[_iconTitle setFrame:[self _frameForIconTitle:_iconTitle]];
	}
}
%end

%hook SBReduceMotionDeckSwitcherViewController
-(id)_iconTitleContainerForDisplayItem:(SBDisplayItem *)arg1 {
	id result = %orig(arg1);
	if ([arg1.displayIdentifier isEqualToString:@"com.apple.springboard"]) {
		for (id view in [result subviews]) {
			if ([[view class] isEqual:[UILabel class]]) {
				[(UILabel *)view setText:@"Home"];
				[(UILabel *)view setFrame:[[self _itemContainerForDisplayItem:arg1] _frameForIconTitle:(UILabel *)view]];
			} else if ([[view class] isEqual:[%c(SBDeckSwitcherIconImageContainerView) class]]) {
				NSBundle *bundle = [[NSBundle alloc] initWithPath:kBundlePath];
				UIImageView* _imageView = MSHookIvar<UIImageView *>(view, "_imageView");
				[_imageView setImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"Home" ofType:@"png"]]];
				[bundle release];
			}
		}
	}
	return result;
}
%end