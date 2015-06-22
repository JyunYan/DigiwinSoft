//
//  ASFileManager.h
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import <UIkit/UIkit.h>

@interface ASFileManager : NSObject

+(void)saveImage:(UIImage*)image FileName:(NSString*)filename;
+(UIImage*)loadImageWithFileName:(NSString*)filename;

@end
