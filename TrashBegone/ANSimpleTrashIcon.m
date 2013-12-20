//
//  ANTrashIcon.m
//  TrashBegone
//
//  Created by Alex Nichol on 12/19/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANSimpleTrashIcon.h"

static BOOL BMPointEquals(BMPoint p1, BMPoint p2);
static NSData * pngData(NSImage * image);

@implementation ANSimpleTrashIcon

+ (void)restartNecessaryServices {
    NSArray * list = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/folders" error:nil];
    for (NSString * _userDir in list) {
        NSString * userDir = [@"/var/folders" stringByAppendingPathComponent:_userDir];
        NSArray * files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:userDir error:nil];
        for (NSString * theFile in files) {
            NSString * baseDir = [userDir stringByAppendingPathComponent:theFile];
            NSString * cachePath = [baseDir stringByAppendingPathComponent:@"C/com.apple.dock.iconcache"];
            NSString * altPath = [baseDir stringByAppendingPathComponent:@"com.apple.dock.iconcache"];
            [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
            [[NSFileManager defaultManager] removeItemAtPath:altPath error:nil];
        }
    }
    
    system("killall Dock");
    system("open /System/Library/CoreServices/Dock.app");
}

+ (instancetype)trashWithFull:(NSImage *)full2x empty:(NSImage *)empty2x {
    if (!full2x || !empty2x) return nil;
    ANImageBitmapRep * iRep1 = [[ANImageBitmapRep alloc] initWithImage:full2x];
    ANImageBitmapRep * iRep2 = [[ANImageBitmapRep alloc] initWithImage:empty2x];
    BMPoint halfSize = BMPointMake(128, 128);
    BMPoint fullSize = BMPointMake(256, 256);
    if (!BMPointEquals(iRep1.bitmapSize, fullSize)) return nil;
    if (!BMPointEquals(iRep2.bitmapSize, fullSize)) return nil;
    ANSimpleTrashIcon * icon = [[self alloc] init];
    [iRep1 setSize:halfSize];
    [iRep2 setSize:halfSize];
    icon.full = iRep1.image;
    icon.empty = iRep2.image;
    icon.full2x = full2x;
    icon.empty2x = empty2x;
    return icon;
}

+ (instancetype)trashForDirectory:(NSString *)resources {
    NSMutableArray * images = [NSMutableArray array];
    NSArray * names = @[@"trashempty@2x.png", @"trashfull@2x.png"];
    for (NSString * name in names) {
        NSString * path = [resources stringByAppendingPathComponent:name];
        NSImage * image = [[NSImage alloc] initWithContentsOfFile:path];
        if (!image) return nil;
        [images addObject:image];
    }
    return [self trashWithFull:images[1] empty:images[0]];
}

- (BOOL)writeToDirectory:(NSString *)directory {
    NSArray * names = @[@"trashempty@2x.png", @"trashfull@2x.png",
                        @"trashempty.png", @"trashfull.png"];
    
    NSMutableArray * paths = [NSMutableArray array];
    for (NSString * name in names) {
        [paths addObject:[directory stringByAppendingPathComponent:name]];
    }
    
    if (![pngData(self.empty2x) writeToFile:paths[0] atomically:YES]) return NO;
    if (![pngData(self.full2x) writeToFile:paths[1] atomically:YES]) return NO;
    if (![pngData(self.empty) writeToFile:paths[2] atomically:YES]) return NO;
    if (![pngData(self.full) writeToFile:paths[3] atomically:YES]) return NO;
    
    NSArray * removeNames = @[@"trashemptyreflection.png", @"trashemptyreflection@2x.png",
                              @"trashfullreflection.png", @"trashfullreflection@2x.png"];
    for (NSString * name in removeNames) {
        NSString * path = [directory stringByAppendingPathComponent:name];
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    
    return YES;
}

@end

static BOOL BMPointEquals(BMPoint p1, BMPoint p2) {
    return p1.x == p2.x && p1.y == p2.y;
}

static NSData * pngData(NSImage * image) {
    CGImageRef cgRef = [image CGImageForProposedRect:NULL
                                             context:nil
                                               hints:nil];
    NSBitmapImageRep * newRep = [[NSBitmapImageRep alloc] initWithCGImage:cgRef];
    NSData * pngData = [newRep representationUsingType:NSPNGFileType properties:nil];
    return pngData;
}
