//
//  ViewController.h
//  Git Manager
//
//  Created by jiyun on 15/9/10.
//  Copyright (c) 2015年 Yji. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef NS_ENUM(NSInteger, HandleType) {
    kHandleNone = 0,
    kHandleClone,
    kHandleFetch,
    kHandleStatus,
    kHandleSetLocalBrName,
    kHandleAddAll,
    kHandleCommit,
    kHandlePush
};

@interface ViewController : NSViewController

- (IBAction)selectClonePath:(id)sender;
- (IBAction)execute:(id)sender;
- (IBAction)setRemoteBr:(id)sender;

- (IBAction)localBrState:(id)sender;
- (IBAction)remoteBrState:(id)sender;

@end

