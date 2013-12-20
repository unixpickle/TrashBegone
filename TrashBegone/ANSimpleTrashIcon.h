//
//  ANSimpleTrashIcon.h
//  TrashBegone
//
//  Created by Alex Nichol on 12/19/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANImageBitmapRep.h"

@interface ANSimpleTrashIcon : NSObject

@property (nonatomic) NSImage * full, * full2x;
@property (nonatomic) NSImage * empty, * empty2x;

+ (void)restartNecessaryServices;
+ (instancetype)trashWithFull:(NSImage *)full2x empty:(NSImage *)empty2x;
+ (instancetype)trashForDirectory:(NSString *)resources;

- (BOOL)writeToDirectory:(NSString *)directory;

@end
