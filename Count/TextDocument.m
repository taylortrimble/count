//
//  TextDocument.m
//  Count
//
//  Created by Taylor Trimble on 9/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TextDocument.h"

@implementation TextDocument

- (id)init
{
    self = [super init];
    if (self) {
        text = [[NSAttributedString alloc] init];
    }
    return self;
}

- (void)dealloc {
    [text release];
    [super dealloc];
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"TextDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    [self count:self];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    NSDictionary *documentAttributes = [NSDictionary dictionaryWithObject:NSPlainTextDocumentType
                                                                   forKey:NSDocumentTypeDocumentAttribute];
    NSData *dataFromText = [text dataFromRange:NSMakeRange(0, [text length])
                            documentAttributes:documentAttributes
                                         error:outError];
    
    if (!dataFromText && outError) {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:nil];
    } 
    
    return dataFromText;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    BOOL readSuccess = NO;
    
    NSAttributedString *textFromData = [[NSAttributedString alloc] initWithData:data
                                                                        options:nil
                                                             documentAttributes:nil
                                                                          error:outError];
    if (textFromData) {
        [self setText:textFromData];
        [textFromData release];
        readSuccess = YES;
    }
    
    if (outError) {
        *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadUnknownError userInfo:nil];
    }
    
    return readSuccess;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

#pragma mark - Accessors and Properties

@synthesize text;

- (NSUInteger)numberOfLines
{
    NSString *string = [text string];
    NSUInteger numberOfLines = 0;
    NSRange searchRange = NSMakeRange(0, 0);
    while (searchRange.location < [string length]) {
        searchRange.location = NSMaxRange([string lineRangeForRange:searchRange]);
        numberOfLines++;
    }
    
//    for (index = 0; index < stringLength; numberOfLines++) {
//        index = NSMaxRange([string lineRangeForRange:NSMakeRange(index, 0)]);
//    }
    
    return numberOfLines;
}

- (NSUInteger)numberOfWords
{
    NSString *string = [text string];
    __block NSUInteger numberOfWords = 0;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                numberOfWords++;
                            }];
     return numberOfWords;
}

- (NSUInteger)numberOfUniqueWords
{
    NSString *string = [[text string] lowercaseString];
    NSMutableSet *uniqueWords = [NSMutableSet set];
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByWords
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                [uniqueWords addObject:substring];
                            }];
    return [uniqueWords count];
}

- (NSUInteger)numberOfCharacters
{
    NSString *string = [text string];
    return [string length];
}

#pragma mark - Count

- (void)count:(id)sender
{
    [[textView window] endEditingFor:nil];
    [lineCount setStringValue:[NSString stringWithFormat:@"Lines: %u", [self numberOfLines]]];
    [wordCount setStringValue:[NSString stringWithFormat:@"Words: %u", [self numberOfWords]]];
    [uniqueWordCount setStringValue:[NSString stringWithFormat:@"Unique words: %u", [self numberOfUniqueWords]]];
    [characterCount setStringValue:[NSString stringWithFormat:@"Characters: %u", [self numberOfCharacters]]];
}

#pragma mark - NSTextView delegate

- (void)textDidChange:(NSNotification *)notification {
    [self setText:[textView textStorage]];
    [self count:self];
}

@end
