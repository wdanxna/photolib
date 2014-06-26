//
//  ImportCardController.h
//  Photolib
//
//  Created by bravo on 14-6-20.
//  Copyright (c) 2014年 bravo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExportCardController;
@protocol ExportCardProtocol <NSObject>

-(void) exportCardControllerDidCancle:(ExportCardController*)controller;
-(void) exportCardController:(ExportCardController*)controller didImportDatas:(NSArray*)datas;

@end

@interface ExportCardController : UIViewController

@property(nonatomic, strong) id<ExportCardProtocol> delegate;
-(void) setDataSourceObj:(id)obj;

@end
