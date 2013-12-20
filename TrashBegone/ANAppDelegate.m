//
//  ANAppDelegate.m
//  TrashBegone
//
//  Created by Alex Nichol on 12/19/13.
//  Copyright (c) 2013 Alex Nichol. All rights reserved.
//

#import "ANAppDelegate.h"

@implementation ANAppDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    backup = [ANTrashIcon trashAppropriateForDirectory:[self.class backupPath]];
    if (!backup) {
        backup = [ANTrashIcon trashAppropriateForDirectory:[self.class dockResourcesPath]];
        [backup writeToDirectory:[self.class backupPath]];
        current = backup;
    } else {
        current = [ANTrashIcon trashAppropriateForDirectory:[self.class dockResourcesPath]];
    }
    
    currentImage.image = current.empty2x;
    backupImage.image = backup.empty2x;
    [[NSRunningApplication currentApplication] activateWithOptions:NSApplicationActivateIgnoringOtherApps];
}

+ (NSString *)backupPath {
    NSString * path = @"/Users/Shared/.dock_trash_backup";
    if (![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:NULL]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path
                                  withIntermediateDirectories:YES
                                                   attributes:@{NSFilePosixPermissions: @(0777)}
                                                        error:nil];
    }
    return path;
}

+ (NSString *)dockResourcesPath {
    return @"/System/Library/CoreServices/Dock.app/Contents/Resources";
}

- (IBAction)setIconPressed:(id)sender {
    ANSimpleTrashIcon * trash = [ANSimpleTrashIcon trashWithFull:fullImage.image
                                                           empty:emptyImage.image];
    if (!trash) {
        return (void)NSRunAlertPanel(@"Error", @"There was an error processing your input. You must set both images, and they must be 256x256.", @"OK", nil, nil);
    }
    [self setTrashIcon:trash];
}

- (IBAction)makeBackup:(id)sender {
    NSInteger result = NSRunAlertPanel(@"Are you sure?", @"There is already a backup. Making a new backup will overwrite the old one, so if you have replaced your old Trash icon you will not be able to get it back.",
                                       @"Cancel", @"Continue", nil);
    if (result == 1) return;
    backup = [ANTrashIcon trashAppropriateForDirectory:[self.class dockResourcesPath]];
    [backup writeToDirectory:[self.class backupPath]];
    backupImage.image = backup.empty2x;
}

- (IBAction)restoreFromBackup:(id)sender {
    [self setTrashIcon:backup];
}

- (IBAction)backToMacPro:(id)sender {
    fullImage.image = [NSImage imageNamed:@"trashfull@2x.png"];
    emptyImage.image = [NSImage imageNamed:@"trashempty@2x.png"];
}

- (void)setTrashIcon:(ANSimpleTrashIcon *)icon {
    if (![icon writeToDirectory:[self.class dockResourcesPath]]) {
        NSRunAlertPanel(@"Error", @"Failed to overwrite resource.", @"OK", nil, nil);
    } else {
        current = icon;
        currentImage.image = icon.empty2x;
        [ANTrashIcon restartNecessaryServices];
    }
}

@end
