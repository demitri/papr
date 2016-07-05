//
//  AbstractCardView.m
//  Papr
//
//  Created by Demitri Muna on 6/22/16.
//  Copyright © 2016 Demitri Muna. All rights reserved.
//

#import "AbstractCardView.h"

@interface AbstractCardView ()
- (void)_setup;
@end

#pragma mark -

@implementation AbstractCardView

- (instancetype)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self != nil) {
		[self _setup];
	}
	return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self != nil) {
		[self _setup];
	}
	return self;
}

- (void)dealloc
{
	if (self.entry != nil)
		[self removeObserver:self forKeyPath:@"entry"];
}

#pragma mark -

- (void)_setup
{
	[self addObserver:self
		   forKeyPath:@"entry"
			  options:NSKeyValueObservingOptionNew
			  context:nil];

}
/*
- (void)setup
{
//	_imageView = [[UIImageView alloc]init];
//	_imageView.backgroundColor = [UIColor orangeColor];
//
//	_imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height * 0.8);
//	[self addSubview:_imageView];
	
	UIBezierPath *maskPath;
	maskPath = [UIBezierPath bezierPathWithRoundedRect:_imageView.bounds
									 byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
										   cornerRadii:CGSizeMake(7.0, 7.0)];
	
	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	maskLayer.frame = _imageView.bounds;
	maskLayer.path = maskPath.CGPath;
	_imageView.layer.mask = maskLayer;
	
	_selectedView = [[UIView alloc]init];
	_selectedView.frame = _imageView.frame;
	_selectedView.backgroundColor = [UIColor clearColor];
	_selectedView.alpha = 0.0;
	[_imageView addSubview:_selectedView];
	
	_label = [[UILabel alloc]init];
	_label.backgroundColor = [UIColor clearColor];
	_label.frame = CGRectMake(10, self.frame.size.height * 0.8, self.frame.size.width - 20, self.frame.size.height * 0.2);
	_label.font = [UIFont fontWithName:@"Futura-Medium" size:14];
	[self addSubview:_label];
}
*/

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
	if (object == self) {
		if ([keyPath isEqualToString:@"entry"]) {
			self.abstractTitle.text = self.entry.title;
			self.abstractSummary.text = self.entry.summary;
			self.authorLabel.text = [[self.entry.authors anyObject] name];
		}
	}
}


@end
