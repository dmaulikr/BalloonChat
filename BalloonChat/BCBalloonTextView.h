//
//  BCBalloonTextView.h
//  BalloonChat
//
//  Created by Jeong YunWon on 2016. 3. 13..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


NS_ASSUME_NONNULL_BEGIN

@interface BCNinePartImageView: NSView

@property(nonatomic,strong) NSImage *image;
@property(nonatomic,assign) NSEdgeInsets capInsets;

@end


@interface BCBalloonTextView : NSControl

@property(nonatomic,strong) NSTextView *textView;
@property(nonatomic,assign) NSTextAlignment alignment;
@property(nonatomic,assign) NSEdgeInsets contentInsets;
@property(nonatomic,assign) NSSize contentSize;
@property(nonatomic,readonly) NSFont *font;

@property(nonatomic,strong) NSImageView *backgroundImageView;
@property(nullable,nonatomic,strong) NSImage *backgroundImage;
@property(nonatomic,assign) NSEdgeInsets backgroundCapInsets;

- (void)setBalloonImage:(NSImage *)image capInsets:(NSEdgeInsets)capInsets;

@property(nonatomic,assign) BOOL autoresizeToFit;

@property(nonatomic,copy) NSString *string;

@end


@protocol BCBalloonTextViewDelegate<NSObject>

@end

NS_ASSUME_NONNULL_END