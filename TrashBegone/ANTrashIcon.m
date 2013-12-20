//
//  ANTrashIcon.m
//  TrashBegone
//
//  Created by Alex Nichol on 12/19/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANTrashIcon.h"

static BOOL BMPointEquals(BMPoint p1, BMPoint p2);
static NSData * pngData(NSImage * image);

@implementation ANTrashIcon

+ (id)trashAppropriateForDirectory:(NSString *)dir {
    ANSimpleTrashIcon * can = [ANTrashIcon trashForDirectory:dir];
    if (can) return can;
    return [ANSimpleTrashIcon trashForDirectory:dir];
}

+ (ANTrashIcon *)trashWithFull:(NSImage *)full2x fullRef:(NSImage *)fullRef2x
                         empty:(NSImage *)empty2x emptyRef:(NSImage *)emptyRef2x {
    if (!fullRef2x || !emptyRef2x) return nil;
    ANTrashIcon * icon = [ANTrashIcon trashWithFull:full2x empty:empty2x];
    ANImageBitmapRep * iRep1 = [[ANImageBitmapRep alloc] initWithImage:fullRef2x];
    ANImageBitmapRep * iRep2 = [[ANImageBitmapRep alloc] initWithImage:emptyRef2x];
    BMPoint halfSize = BMPointMake(128, 128);
    BMPoint fullSize = BMPointMake(256, 256);
    if (!BMPointEquals(iRep1.bitmapSize, fullSize)) return nil;
    if (!BMPointEquals(iRep2.bitmapSize, fullSize)) return nil;
    [iRep1 setSize:halfSize];
    [iRep2 setSize:halfSize];
    icon.fullRef2x = fullRef2x;
    icon.emptyRef2x = emptyRef2x;
    icon.fullRef = iRep1.image;
    icon.emptyRef = iRep2.image;
    return icon;
}

+ (ANTrashIcon *)trashForDirectory:(NSString *)resources {
    NSMutableArray * images = [NSMutableArray array];
    NSArray * names = @[@"trashempty@2x.png", @"trashemptyreflection@2x.png",
                        @"trashfull@2x.png", @"trashfullreflection@2x.png"];
    for (NSString * name in names) {
        NSString * path = [resources stringByAppendingPathComponent:name];
        NSImage * image = [[NSImage alloc] initWithContentsOfFile:path];
        if (!image) return nil;
        [images addObject:image];
    }
    return [ANTrashIcon trashWithFull:images[2] fullRef:images[3]
                                empty:images[0] emptyRef:images[1]];
}

- (BOOL)writeToDirectory:(NSString *)directory {
    NSArray * names = @[@"trashempty@2x.png", @"trashemptyreflection@2x.png",
                        @"trashfull@2x.png", @"trashfullreflection@2x.png",
                        @"trashempty.png", @"trashemptyreflection.png",
                        @"trashfull.png", @"trashfullreflection.png"];
    
    NSMutableArray * paths = [NSMutableArray array];
    for (NSString * name in names) {
        [paths addObject:[directory stringByAppendingPathComponent:name]];
    }
    
    if (![pngData(self.empty2x) writeToFile:paths[0] atomically:YES]) return NO;
    if (![pngData(self.emptyRef2x) writeToFile:paths[1] atomically:YES]) return NO;
    if (![pngData(self.full2x) writeToFile:paths[2] atomically:YES]) return NO;
    if (![pngData(self.fullRef2x) writeToFile:paths[3] atomically:YES]) return NO;
    if (![pngData(self.empty) writeToFile:paths[4] atomically:YES]) return NO;
    if (![pngData(self.emptyRef) writeToFile:paths[5] atomically:YES]) return NO;
    if (![pngData(self.full) writeToFile:paths[6] atomically:YES]) return NO;
    if (![pngData(self.fullRef) writeToFile:paths[7] atomically:YES]) return NO;
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
