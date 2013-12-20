//
//  ANAppDelegate.h
//  TrashBegone
//
//  Created by Alex Nichol on 12/19/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ANTrashIcon.h"

@interface ANAppDelegate : NSObject <NSApplicationDelegate> {
    IBOutlet NSImageView * currentImage;
    IBOutlet NSImageView * backupImage;
    IBOutlet NSImageView * fullImage;
    IBOutlet NSImageView * emptyImage;
    
    ANSimpleTrashIcon * backup;
    ANSimpleTrashIcon * current;
}

@property (assign) IBOutlet NSWindow * window;

+ (NSString *)backupPath;
+ (NSString *)dockResourcesPath;

- (IBAction)setIconPressed:(id)sender;
- (IBAction)makeBackup:(id)sender;
- (IBAction)restoreFromBackup:(id)sender;
- (IBAction)backToMacPro:(id)sender;

- (void)setTrashIcon:(ANSimpleTrashIcon *)icon;

@end
