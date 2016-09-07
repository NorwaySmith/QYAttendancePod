//
//  QYTextView.m
//  ConferenceCall
//
//  Created by 田 on 13-6-7.
//  Copyright (c) 2013年 田. All rights reserved.
//

#import "QYTextView.h"

@implementation QYTextView
@synthesize placeholder;
@synthesize placeholderColor;
@synthesize _placeHolderLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
-(void)textChanged:(NSNotification*)notification{

    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }

}
- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
 if( [[self placeholder] length] > 0 )
 {
 if (_placeHolderLabel == nil )
 {
 self._placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,8,self.bounds.size.width - 16,0)];
 _placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
 _placeHolderLabel.numberOfLines = 0;
 _placeHolderLabel.font = self.font;
 _placeHolderLabel.backgroundColor = [UIColor clearColor];
 _placeHolderLabel.textColor = self.placeholderColor;
 _placeHolderLabel.alpha = 0;
 _placeHolderLabel.tag = 999;
 [self addSubview:_placeHolderLabel];
 }
 
 _placeHolderLabel.text = self.placeholder;
 [_placeHolderLabel sizeToFit];
 [self sendSubviewToBack:_placeHolderLabel];
 }
 
 if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
 {
 [[self viewWithTag:999] setAlpha:1];
 }
 
 [super drawRect:rect];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    
    // Use Interface Builder User Defined Runtime Attributes to set
    // placeholder and placeholderColor in Interface Builder.
    if (!self.placeholder) {
        [self setPlaceholder:@""];
    }
    
    if (!self.placeholderColor) {
        [self setPlaceholderColor:[UIColor lightGrayColor]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];

}
- (void)dealloc{
    //[super dealloc];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if __has_feature(objc_arc)
#else
    [_placeHolderLabel release]; _placeHolderLabel = nil;
    [placeholderColor release]; placeholderColor = nil;
    [placeholder release]; placeholder = nil;
#endif
}
@end
