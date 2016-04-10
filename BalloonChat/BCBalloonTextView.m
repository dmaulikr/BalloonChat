//
//  BCBalloonTextView.m
//  BalloonChat
//
//  Created by Jeong YunWon on 2016. 3. 13..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

#import "BCBalloonTextView.h"

#import <cdebug/debug.h>


@implementation NSMutableAttributedString (BCBalloonTextViewReplacing)

- (void)replaceByRegularExpressionPatternsAndBlocks:(NSDictionary *)blocks {
    for (NSString *pattern in blocks.keyEnumerator) {
        NSString *plain = [self string];

        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        if (regex == nil) {
            @throw error;
        }

        __block NSMutableArray *rangeStrings = [NSMutableArray array];
        NSRange searchRange = NSMakeRange(0, plain.length);
        [regex enumerateMatchesInString:plain options:0 range:searchRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            [rangeStrings addObject:NSStringFromRange(result.range)];
        }];

        __block BCBalloonTextViewReplacingBlock replacingBlock = blocks[pattern];
        for (NSString *rangeString in rangeStrings.reverseObjectEnumerator) {
            NSRange range = NSRangeFromString(rangeString);
            NSString *occurance = [plain substringWithRange:range];
            NSAttributedString *replacement = replacingBlock(occurance);
            [self replaceCharactersInRange:range withAttributedString:replacement];
        }
    }
}

@end


@interface BCBalloonTextView () {
    __strong NSFont *_font;
    BOOL _autoresizeToFit;
}

@end


@implementation BCNinePartImageView

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        self.layer = [CAANinePartImageLayer layer];
//    }
//    return self;
//}
//
//- (void)drawRect:(NSRect)dirtyRect {
//    CAANinePartImageLayer *layer = (CAANinePartImageLayer *)self.layer;
//    layer.image = self.image;
//    layer.capInsets = self.capInsets;
//    [layer setNeedsDisplay];
//    [layer displayIfNeeded];
//}

@end


@implementation BCBalloonTextView

- (void)_initBCBalloonTextView {
    // image view
    NSImageView *backgroundImageView = [[NSImageView alloc] initWithFrame:self.bounds];
    [self addSubview:backgroundImageView];

    self.backgroundImageView = backgroundImageView;

    //self.layer = [CAANinePartImageLayer layer];
    //self.layer.backgroundColor = [[NSColor colorWithCalibratedRed:0.5 green:0.5 blue:0.5 alpha:0.5] CGColor];

    // text view
    NSTextView *textView = [[NSTextView alloc] initWithFrame:self.bounds];
    textView.editable = NO;
    textView.verticallyResizable = NO;
    textView.textContainer.widthTracksTextView = YES;
    textView.textContainer.lineFragmentPadding = 0.0f;
    textView.backgroundColor = [NSColor clearColor];
    [self addSubview:textView];

    self.textView = textView;

    // general
    self.alignment = textView.alignment; // force to set autoresize masks

    // KVO
    [self addObserver:self forKeyPath:@"backgroundImage" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"backgroundCapInsets" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"contentInsets" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    [self.textView addObserver:self forKeyPath:@"string" options:NSKeyValueObservingOptionNew context:NULL];
    [self.textView addObserver:self forKeyPath:@"font" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    [self _initBCBalloonTextView];
    return self;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    [self _initBCBalloonTextView];
    return self;
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"backgroundImage"];
    [self removeObserver:self forKeyPath:@"backgroundCapInsets"];
    [self removeObserver:self forKeyPath:@"contentInsets"];
    [self removeObserver:self forKeyPath:@"contentSize"];
    [self.textView removeObserver:self forKeyPath:@"string"];
    [self.textView removeObserver:self forKeyPath:@"font"];
    [self removeObserver:self forKeyPath:@"frame"];
}

- (void)setBalloonImage:(NSImage *)image capInsets:(NSEdgeInsets)capInsets {
    self.backgroundImage = image;
    self.backgroundCapInsets = capInsets;
}

- (void)_arrangeBallonImage {
    NSEdgeInsets capInsets = self.backgroundCapInsets;
    NSEdgeInsets contentInsets = self.contentInsets;
    NSSize contentSize = self.contentSize;
    CGFloat originX;
    switch (self.alignment) {
        case NSTextAlignmentRight:
            originX = self.frame.size.width - (contentSize.width + capInsets.left + capInsets.right);
            break;
        case NSTextAlignmentCenter:
            originX = self.frame.size.width - (contentSize.width + capInsets.left + capInsets.right) / 2;
            break;
        default:
            originX = 0.0f;
            break;
    }
    NSRect frame;
    frame.origin = NSMakePoint(originX, 0.0f);
    frame.size = NSMakeSize(contentSize.width + (contentInsets.left + contentInsets.right), contentSize.height + (contentInsets.top + contentInsets.bottom));

    CGFloat minimumWidth = capInsets.left + capInsets.right;
    if (frame.size.width < minimumWidth) {
        frame.size.width = minimumWidth;
    }
    CGFloat minimumHeight = capInsets.top + capInsets.bottom;
    if (frame.size.height < minimumHeight) {
        frame.size.height = minimumHeight;
    }
    self.backgroundImageView.frame = frame;
    if (frame.size.height > 0.0f && frame.size.width > 0.0f) {
        NSImage *image = self.backgroundImage;
        image = [image ninePartImageWithSize:self.backgroundImageView.bounds.size capInsets:self.backgroundCapInsets];
        self.backgroundImageView.image = image;
    }
}

- (void)_arrangeTextView {
    NSEdgeInsets contentInsets = self.contentInsets;
    NSSize contentSize = self.contentSize;
    CGFloat originX;
    switch (self.alignment) {
        case NSTextAlignmentRight:
            originX = self.frame.size.width - (contentSize.width + contentInsets.right);
            break;
        case NSTextAlignmentCenter:
            originX = self.frame.size.width - (contentSize.width + contentInsets.left + contentInsets.right) / 2;
            break;
        default:
            originX = contentInsets.left;
            break;
    }
    NSRect frame;
    frame.origin = NSMakePoint(originX, contentInsets.bottom);
    frame.size = self.contentSize;

    NSEdgeInsets capInsets = self.backgroundCapInsets;
    CGFloat minimumWidth = (capInsets.left + capInsets.right) - (contentInsets.left + contentInsets.right);
    if (frame.size.width < minimumWidth) {
        frame.size.width = minimumWidth;
    }
    CGFloat minimumHeight = (capInsets.top + capInsets.bottom) - (contentInsets.top + contentInsets.bottom);
    if (frame.size.height < minimumHeight) {
        frame.origin.y -= (minimumHeight - frame.size.height) / 2;
        frame.size.height = minimumHeight;
    }

    self.textView.frame = frame;
    //dassert(NSRectEqualToRect(self.textView.frame, frame));
}

- (void)_arrangeMainView {
    NSRect frame = self.frame;
    frame.size.height = self.backgroundImageView.frame.size.height;
    self.frame = frame;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.textView || object == self.textView.textStorage) {
        if (self.autoresizeToFit) {
            [self sizeToFit];
        }
        return;
    }
    else if (object == self.backgroundImageView) {
        [self _arrangeBallonImage];
    }
    else {
        if ([@[@"backgroundImage", @"backgroundCapInsets"] containsObject:keyPath]) {
    //        CAANinePartImageLayer *layer = (CAANinePartImageLayer *)self.layer;
    //        layer.image = self.backgroundImage;
    //        NSEdgeInsets insets = layer.capInsets = self.backgroundCapInsets;
    //
    //        self.textView.frame = CGRectMake(self.bounds.origin.x + insets.left, self.bounds.origin.y + insets.top, self.bounds.size.width - (insets.right + insets.left), self.bounds.size.height - (insets.top + insets.bottom));
    //        [self.layer setNeedsDisplay];
    //        [self setNeedsDisplay:YES];
            [self _arrangeBallonImage];
            return;
        }

        if ([@[@"contentSize", @"contentInsets"] containsObject:keyPath]) {
            [self _arrangeTextView];
            [self _arrangeBallonImage];
            if (self.autoresizeToFit) {
                [self _arrangeMainView];
            }
            return;
        }

        if ([@[@"frame"] containsObject:keyPath]) {
            [self _arrangeTextView];
            [self _arrangeBallonImage];
            return;
        }

    }

    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)setString:(NSString *)string {
    NSAttributedString *attributedString;
    if (self.delegate && [self.delegate respondsToSelector:@selector(textView:attributedStringForString:)]) {
        attributedString = [self.delegate textView:self attributedStringForString:string];
    }
    else if (self.delegate && [self.delegate respondsToSelector:@selector(regularExpressionPatternsAndBlocksForReplacingInTextView:)]) {
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: self.font}];
        NSDictionary *replacers = [self.delegate regularExpressionPatternsAndBlocksForReplacingInTextView:self];
        [mutableAttributedString replaceByRegularExpressionPatternsAndBlocks:replacers];
        attributedString = [mutableAttributedString copy];
    }
    else {
        attributedString = [[NSAttributedString alloc] initWithString:string attributes:@{NSFontAttributeName: self.font}];
    }
    self.textView.editable = YES;
    self.textView.textStorage.attributedString = attributedString;
    [self.textView checkTextInDocument:nil];
    self.textView.editable = NO;
    if (self.autoresizeToFit) {
        [self sizeToFit];
    }
}

- (NSString *)string {
    return self.textView.string;
}

- (NSFont *)font {
    return self.textView.font;
}

- (void)setAlignment:(NSTextAlignment)alignment {
    self.textView.alignment = alignment;

    NSAutoresizingMaskOptions autoresizeMaskOptions = NSViewWidthSizable;
    switch (alignment) {
        case NSTextAlignmentRight:
            autoresizeMaskOptions |= NSViewMaxXMargin;
            break;
        case NSTextAlignmentCenter:
            break;
        default:
            autoresizeMaskOptions |= NSViewMinXMargin;
            break;
    }
    self.textView.autoresizingMask = autoresizeMaskOptions;
    self.backgroundImageView.autoresizingMask = autoresizeMaskOptions;

    [self _arrangeTextView];
    [self _arrangeBallonImage];
}

- (NSTextAlignment)alignment {
    return self.textView.alignment;
}

- (BOOL)autoresizeToFit {
    return self->_autoresizeToFit;
}

- (void)setAutoresizeToFit:(BOOL)autoresizeToFit {
    self->_autoresizeToFit = autoresizeToFit;
    if (autoresizeToFit) {
        [self sizeToFit];
    }
}

//- (void)drawRect:(NSRect)dirtyRect {
//    [super drawRect:dirtyRect];
////    [self.layer setNeedsDisplay];
//    [self.layer displayIfNeeded];
//}

- (NSSize)_calcContentSize:(NSSize)size {
    NSEdgeInsets contentInsets = self.contentInsets;
    CGFloat viewWidth = size.width;
    CGFloat maximumWidth = viewWidth - (contentInsets.left + contentInsets.right);

    CGFloat contentWidth = [self.textView.attributedString boundingRectWithSize:NSSizeMake(maximumWidth, 0.0f) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading].size.width;
    contentWidth = ceilf(contentWidth);
    CGFloat contentHeight = [self.textView.layoutManager boundingRectForGlyphRange:NSMakeRange(0, self.textView.attributedString.length) inTextContainer:self.textView.textContainer].size.height;

    return CGSizeMake(contentWidth, contentHeight);
}

- (NSSize)sizeThatFits:(NSSize)size {
    NSEdgeInsets contentInsets = self.contentInsets;
    NSEdgeInsets capInsets = self.backgroundCapInsets;
    NSSize contentSize = [self _calcContentSize:size];
    NSSize viewSize = NSSizeMake(contentInsets.left + contentSize.width + contentInsets.right, contentInsets.top + contentSize.height + contentInsets.bottom);

    CGFloat minimumWidth = capInsets.left + capInsets.right;
    if (viewSize.width < minimumWidth) {
        viewSize.width = minimumWidth;
    }
    CGFloat minimumHeight = capInsets.top + capInsets.bottom;
    if (viewSize.height < minimumHeight) {
        viewSize.height = minimumHeight;
    }

    return viewSize;
}

- (void)sizeToFit {
    self.contentSize = [self _calcContentSize:self.frame.size];
}

@end
