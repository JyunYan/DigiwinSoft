//
//  ASFileManager.m
//  DigiwinSoft
//
//  Created by elion chung on 2015/6/18.
//  Copyright (c) 2015年 Jyun. All rights reserved.
//

#import "ASFileManager.h"

@implementation ASFileManager

static ASFileManager* _manager = nil;

+(ASFileManager*) sharedInstance
{
    @synchronized([ASFileManager class])
    {
        if( !_manager)
        {
            _manager=[[ASFileManager alloc] init];
        }
        return _manager;
    }
    
    return nil;
}

+(void)saveImage:(UIImage*)image FileName:(NSString*)filename
{
    [self createTargetDirectory];
    NSString* path = [self getTargetPath:filename];
    
    NSData* data = UIImagePNGRepresentation(image);
    [data writeToFile:path atomically:YES];
}

+(UIImage*)loadImageWithFileName:(NSString*)filename
{
    NSString* path = [self getTargetPath:filename];
    BOOL isDir;
    if(![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir])
        return nil;
    return [UIImage imageWithContentsOfFile:path];
}

+(void)createTargetDirectory
{
    NSString* path = [self getTmpDirectory];
    path = [path stringByAppendingPathComponent:@"/DigiwinSoft/"];
    
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
    }
}

+(NSString*)getTargetPath:(NSString*)filename
{
    NSString* path = [self getTmpDirectory];
    path = [path stringByAppendingPathComponent:@"/DigiwinSoft/"];
    path = [path stringByAppendingPathComponent:filename];
    
    return path;
}

+(NSString*)getTmpDirectory
{
    return NSTemporaryDirectory();
}

@end
