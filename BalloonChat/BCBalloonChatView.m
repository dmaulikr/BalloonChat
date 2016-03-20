//
//  BCBalloonChatView.m
//  BalloonChat
//
//  Created by Jeong YunWon on 2016. 3. 17..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

#import <CocoaExtension/CocoaExtension.h>

#import "BCBalloonChatView.h"


//@interface BCBalloonChatView()<BCBalloonTextViewDelegate>
//
//@end
//
//
//@implementation BCBalloonChatView
//// Table view: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/TableView/TableViewOverview/TableViewOverview.html
//// Scroll view: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/NSScrollViewGuide/Articles/Basics.html
//
//- (void)_initBCBalloonChatView {
//    if (self.tableView == nil) {
//        NSTableView *tableView = [[NSTableView alloc] initWithFrame:self.bounds];
//        tableView.headerView = nil;
//        self.documentView = tableView;
//
//        NSTableColumn *chatColumn = [[NSTableColumn alloc] initWithIdentifier:@"chat"];
//        tableView.delegate = self;
//        tableView.dataSource = self;
//        [tableView addTableColumn:chatColumn];
//
//        self.backgroundColor = [NSColor blackColor];
//        self.tableView.backgroundColor = [NSColor grayColor];
//    }
//}
//
//- (instancetype)initWithCoder:(NSCoder *)coder {
//    self = [super initWithCoder:coder];
//    [self _initBCBalloonChatView];
//    return self;
//}
//
//- (instancetype)initWithFrame:(NSRect)frameRect {
//    self = [super initWithFrame:frameRect];
//    [self _initBCBalloonChatView];
//    return self;
//}
//
//
//#pragma mark - table view
//
//- (NSTableView *)tableView {
//    return self.documentView;
//}
//
//- (void)loadTextView:(BCBalloonTextView *)view {
//    if (view.backgroundImage == nil) {
//        view.backgroundImage = [NSImage imageNamed:@"BalloonSampleRight"];
//        view.backgroundCapInsets = NSEdgeInsetsMake(8, 8, 27, 16);
//        view.contentInsets = NSEdgeInsetsMake(8, 8, 8, 16);
//        view.alignment = NSTextAlignmentRight;
//    }
//}
//
//- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
//    BCBalloonTextCellView *view = [tableView makeViewWithIdentifier:@"cell" owner:self];
//    BCBalloonTextView *textView = view.balloonView;
//    [self loadTextView:textView];
//    textView.string = @"Left hand (smile)";
//    [textView sizeToFit];
//    return view;
//}
//
//- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
//    return 100;
//}
//
//
//- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
//    BCBalloonTextView *view = [[BCBalloonTextView alloc] initWithFrame:NSRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
//    [self loadTextView:view];
//    view.string = @"Right hand (Special)";
//    return [view sizeThatFits:NSSizeMake(tableView.frame.size.width, 0.0f)].height;
//}
//
//- (BOOL)selectionShouldChangeInTableView:(NSTableView *)tableView {
//    return NO;
//}
//
//@end


@implementation BCBalloonTextCellView

- (void)_initChatView {
    BCBalloonTextView *view = [[BCBalloonTextView alloc] initWithFrame:NSRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
    [self addSubview:view];
    self->_balloonView = view;
}

- (instancetype)initWithFrame:(NSRect)frameRect {
    self = [super initWithFrame:frameRect];
    [self _initChatView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if (self.balloonView == nil) {
         [self _initChatView];
    }
}

@end
