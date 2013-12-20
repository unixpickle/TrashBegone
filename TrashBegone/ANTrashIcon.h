//
//  ANTrashIcon.h
//  TrashBegone
//
//  Created by Alex Nichol on 12/19/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ANSimpleTrashIcon.h"

@interface ANTrashIcon : ANSimpleTrashIcon

@property (nonatomic) NSImage * full, * full2x;
@property (nonatomic) NSImage * fullRef, * fullRef2x;
@property (nonatomic) NSImage * empty, * empty2x;
@property (nonatomic) NSImage * emptyRef, * emptyRef2x;

+ (id)trashAppropriateForDirectory:(NSString *)dir;
+ (ANTrashIcon *)trashWithFull:(NSImage *)full2x fullRef:(NSImage *)fullRef2x
                         empty:(NSImage *)empty2x emptyRef:(NSImage *)empty2x;


@end
