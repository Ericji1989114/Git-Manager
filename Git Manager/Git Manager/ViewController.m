//
//  ViewController.m
//  Git Manager
//
//  Created by jiyun on 15/9/10.
//  Copyright (c) 2015年 Yji. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController {
    IBOutlet    NSTextField *_txdCDPath;
    IBOutlet    NSTextField *_txdGloneSoucePath;
    IBOutlet    NSTextField *_txdLocalBrName;
    IBOutlet    NSTextField *_txdCommitMess;
    IBOutlet    NSTextView  *_errView;
    
    IBOutlet    NSMatrix    *_matSelect;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_errView setString:@""];
    NSButtonCell *btnCell = [_matSelect cellAtRow:6 column:0];
    [_matSelect setToolTip:@"ローカル分枝対応のリモート分枝をプッシーする" forCell:btnCell];
}

- (IBAction)selectClonePath:(id)sender {
    [self errorReset];
    NSOpenPanel *openPanel = [NSOpenPanel openPanel];
    [openPanel setAllowsMultipleSelection:NO];
    [openPanel setCanChooseDirectories:YES];
    [openPanel setCanChooseFiles:NO];
    
    if ([openPanel runModal] == NSModalResponseOK) {
        NSURL *tempUrl = [[openPanel URLs] objectAtIndex:0];
        NSString *tempStr = [tempUrl path];
        [_txdCDPath setStringValue:tempStr];
    }
    
}

- (IBAction)execute:(id)sender {
    [self errorReset];
    HandleType handleType = [self getHandleType];
    switch (handleType) {
        case kHandleClone:
            [self clone];
            break;
        case kHandleSetLocalBrName:
            [self setLocalBrName];
            break;
        case kHandleFetch:
            [self fetchSource];
            break;
        case kHandleStatus:
            [self getStatus];
            break;
        case kHandleAddAll:
            [self addAll];
            break;
        case kHandleCommit:
            [self commitSource];
            break;
        case kHandlePush:
            [self pushSource];
            break;
        default:
            break;
    }
}

-(void)clone {
    if ([[_txdCDPath stringValue] length] == 0 || [[_txdGloneSoucePath stringValue] length] == 0) {
        [_errView setString:@"クローンできない！！指定とクローン源パス入力をチェックする！！"];
        return;
    }
    
    NSString *cloneSoucePath = [_txdGloneSoucePath stringValue];
    NSString *result_str;
    result_str = [self resultFromCommand:[NSString stringWithFormat:@"clone %@",cloneSoucePath]];
    
    if ([result_str length] == 0 || [result_str hasPrefix:@"Cloning into"]) {
        [_errView setString:@"完成!!!"];
    } else {
        [_errView setString:result_str];
    }
}

-(void)setLocalBrName {
    if ([[_txdCDPath stringValue] length] == 0 || [[_txdLocalBrName stringValue] length] == 0) {
        [_errView setString:@"ロカール分枝設定できない！！指定パスとロカール名前の入力をチェックする！！"];
        return;
    }
    NSString *localBrName = [_txdLocalBrName stringValue];
    NSString *result_str;
    result_str = [self resultFromCommand:[NSString stringWithFormat:@"checkout -b %@",localBrName]];
    if ([result_str length] == 0) {
        [_errView setString:@"完成！！！"];
    } else {
        [_errView setString:result_str];

    }
}

- (IBAction)setRemoteBr:(id)sender {
    if ([[_txdCDPath stringValue] length] == 0 || [[_txdLocalBrName stringValue] length] == 0) {
        [_errView setString:@"ロカール分枝設定できない！！指定パスとロカール名前の入力をチェックする！！"];
        return;
    }
    NSString *remoteBrName = [_txdLocalBrName stringValue];
    NSString *result_str;
    result_str = [self resultFromCommand:[NSString stringWithFormat:@"push -u origin %@",remoteBrName]];
    if ([result_str length] == 0) {
        [_errView setString:@"完成！！！"];
    } else {
        [_errView setString:result_str];
    }
}

- (IBAction)localBrState:(id)sender {
    if ([[_txdCDPath stringValue] length] == 0) {
        [_errView setString:@"指定パスの入力をチェックする！！"];
        return;
    }
    NSString *result_str;
    result_str = [self resultFromCommand:@"branch"];
    [_errView setString:result_str];
}

- (IBAction)remoteBrState:(id)sender {
    if ([[_txdCDPath stringValue] length] == 0) {
        [_errView setString:@"指定パスの入力をチェックする！！"];
        return;
    }
    NSString *result_str;
    result_str = [self resultFromCommand:@"branch -r"];
    [_errView setString:result_str];
}

- (void)fetchSource {
    if ([[_txdCDPath stringValue] length] == 0) {
        [_errView setString:@"指定パスの入力をチェックする！！"];
        return;
    }
    NSString *result_str;
    result_str = [self resultFromCommand:@"fetch"];
    
    if ([result_str length] == 0) {
        [_errView setString:@"完成！！！"];
    } else {
        [_errView setString:result_str];
        
    }
}

- (void)getStatus {
    if ([[_txdCDPath stringValue] length] == 0) {
        [_errView setString:@"指定パスの入力をチェックする！！"];
        return;
    }
    NSString *result_str;
    result_str = [self resultFromCommand:@"status"];
    [_errView setString:result_str];
}

-(void)addAll {
    if ([[_txdCDPath stringValue] length] == 0) {
        [_errView setString:@"指定パスの入力をチェックする！！"];
        return;
    }
    NSString *result_str;
    result_str = [self resultFromCommand:@"add -A"];
    if ([result_str length] == 0) {
        [_errView setString:@"完成！！！"];
    } else {
        [_errView setString:result_str];
    }
}

- (void)commitSource {
    if ([[_txdCDPath stringValue] length] == 0 || [[_txdCommitMess stringValue] length] == 0) {
        [_errView setString:@"ソースコメントできない！！指定パスとコメントメッセージの入力をチェックする！！"];
        return;
    }
    NSString *result_str;
    result_str = [self resultFromCommand:[NSString stringWithFormat:@"commit -m \"%@\"",[_txdCommitMess stringValue]]];
    [_errView setString:result_str];
    
}

-(void)pushSource {
    if ([[_txdCDPath stringValue] length] == 0) {
        [_errView setString:@"ソースプッシーできない！！入力をチェックする！！"];
        return;
    }
    NSString *result_str;
    result_str = [self resultFromCommand:@"push"];
    [_errView setString:result_str];
    
}

-(void)errorReset {
    [_errView setString:@""];
}

-(HandleType)getHandleType {
    NSButtonCell *btnCell = [_matSelect selectedCell];
    NSString *btnIdentify = btnCell.identifier;
    HandleType handleType = kHandleNone;
    if ([btnIdentify isEqualToString:@"Clone"]) {
        handleType = kHandleClone;
    } else if ([btnIdentify isEqualToString:@"Fetch"]) {
        handleType = kHandleFetch;
    } else if ([btnIdentify isEqualToString:@"Status"]) {
        handleType = kHandleStatus;
    } else if ([btnIdentify isEqualToString:@"LocalBranch"]) {
        handleType = kHandleSetLocalBrName;
    } else if ([btnIdentify isEqualToString:@"Add"]) {
        handleType = kHandleAddAll;
    } else if ([btnIdentify isEqualToString:@"Commit"]) {
        handleType = kHandleCommit;
    } else if ([btnIdentify isEqualToString:@"Push"]) {
        handleType = kHandlePush;
    }
    return handleType;
}

-(NSString *)resultFromCommand:(NSString *)strCom {
    NSTask *aTask = [[NSTask alloc] init];
    NSPipe *pipe = [NSPipe pipe];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    NSString *cdPath = [_txdCDPath stringValue];
    NSArray *args = [self arrFromStringBySpace:strCom];
    
    [aTask setArguments:args];
    [aTask setCurrentDirectoryPath:cdPath];
    [aTask setLaunchPath:@"/usr/local/git/bin/git"];
    [aTask setStandardOutput:pipe];
    [aTask setStandardError:pipe];
    [aTask launch];
    [aTask waitUntilExit];
    
    NSData *data;
    data = [file readDataToEndOfFile];
    [file closeFile];
    
    NSString *result_str;
    result_str = [[NSString alloc] initWithData:data
                                       encoding:NSUTF8StringEncoding];
    
    return result_str;
}

-(NSArray *)arrFromStringBySpace:(NSString *)strCom {
    if ([strCom length] == 0) {
        return nil;
    }
    NSArray *args = [strCom componentsSeparatedByString:@" "];
    return args;
}


@end
