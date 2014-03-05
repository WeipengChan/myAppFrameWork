//
//  common.h
//  恒大
//
//  Created by YunInfo on 13-10-12.
//  Copyright (c) 2013年 YunInfo. All rights reserved.
//

#ifndef ___common_h
#define ___common_h

#define SYMSTEMVERSION  [[[UIDevice currentDevice] systemVersion] floatValue]

//判断屏幕尺寸
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

//极光推送的额外内容字典
#define PUSHEXTRADICT  @"pushExtraDict"
#endif
