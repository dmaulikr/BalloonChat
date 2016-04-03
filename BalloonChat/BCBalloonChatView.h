//
//  BCBalloonChatView.h
//  BalloonChat
//
//  Created by Jeong YunWon on 2016. 3. 17..
//  Copyright © 2016년 youknowone.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <BalloonChat/BCBalloonTextView.h>


#if !__has_feature(nullability) && !defined(NS_ASSUME_NONNULL_BEGIN)
#define NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_END
#define _Nullable
#define nullable
#endif

NS_ASSUME_NONNULL_BEGIN


//@protocol BCBalloonChatViewDelegate;
//@protocol BCBalloonChatViewDataSource;
//
//
//@interface BCBalloonChatView : NSScrollView<NSTableViewDelegate, NSTableViewDataSource>
//
//@property(nonatomic,readonly) NSTableView *tableView;
//@property(nonatomic,weak) NSObject<BCBalloonChatViewDelegate> *delegate;
//@property(nonatomic,weak) NSObject<BCBalloonChatViewDataSource> *dataSource;
//
//@end
//
//
//@protocol BCBalloonChatViewDelegate <NSObject>
//
//@optional
//- (CGFloat)chatView:(BCBalloonChatView *)chatView heightForRow:(NSInteger)row;
//- (NSView *)chatView:(BCBalloonChatView *)chatView modelViewForRow:(NSInteger)row;
//- (void)chatView:(BCBalloonTextView *)chatView setContent:(id)content forView:(NSView *)view;
//
//@end
//
//
//@protocol BCBalloonChatViewDataSource <NSObject>
//
//@required
//- (NSInteger)numberOfScrollableRowOfChatView:(BCBalloonChatView *)chatView;
//
//@end


@interface BCBalloonTableView : NSTableView

@property(nonatomic,assign) NSInteger columnIndexToFitWhenResizing;
@property(nonatomic,assign) BOOL tracksContentWhenResizing;

@end


@interface BCBalloonTextCellView : NSTableCellView

@property(nonatomic,strong) IBOutlet BCBalloonTextView *balloonView;

@end

NS_ASSUME_NONNULL_END
