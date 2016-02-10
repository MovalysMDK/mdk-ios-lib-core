/**
 * Copyright (C) 2010 Sopra (support_movalys@sopra.com)
 *
 * This file is part of Movalys MDK.
 * Movalys MDK is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * Movalys MDK is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 * You should have received a copy of the GNU Lesser General Public License
 * along with Movalys MDK. If not, see <http://www.gnu.org/licenses/>.
 */
//
//
//  MFCSVParser.h
//  MFCore
/*!
 https://github.com/davedelong/CHCSVParser
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

extern NSString *const MFCSVErrorDomain;

enum {
    MFCSVErrorCodeInvalidFormat = 1,
};

typedef NSInteger MFCSVErrorCode;

@class MFCSVParser;
@protocol MFCSVParserDelegate <NSObject>

@optional

- (void)parserDidBeginDocument:(MFCSVParser *)parser;

- (void)parserDidEndDocument:(MFCSVParser *)parser;

- (void)parser:(MFCSVParser *)parser didBeginLine:(NSUInteger)recordNumber;

- (void)parser:(MFCSVParser *)parser didEndLine:(NSUInteger)recordNumber;

- (void)parser:(MFCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex;

- (void)parser:(MFCSVParser *)parser didReadComment:(NSString *)comment;

- (void)parser:(MFCSVParser *)parser didFailWithError:(NSError *)error;

@end

@interface MFCSVParser : NSObject

@property (nonatomic,weak) id<MFCSVParserDelegate> delegate;

@property (assign) BOOL recognizesBackslashesAsEscapes; // default is NO

@property (assign) BOOL sanitizesFields; // default is NO

@property (assign) BOOL recognizesComments; // default is NO

@property (readonly) NSUInteger totalBytesRead;

	// designated initializer
- (id)initWithInputStream:(NSInputStream *)stream usedEncoding:(NSStringEncoding *)encoding delimiter:(unichar)delimiter;

- (id)initWithCSVString:(NSString *)csv;
- (id)initWithContentsOfCSVFile:(NSString *)csvFilePath;

- (void)parse;
- (void)cancelParsing;

@end

@interface MFCSVWriter : NSObject

- (instancetype)initForWritingToCSVFile:(NSString *)path;
- (instancetype)initWithOutputStream:(NSOutputStream *)stream encoding:(NSStringEncoding)encoding delimiter:(unichar)delimiter;

- (void)writeField:(NSString *)field;
- (void)finishLine;

- (void)writeLineOfFields:(id<NSFastEnumeration>)fields;

- (void)writeComment:(NSString *)comment;

- (void)closeStream;

@end

#pragma mark - Convenience Categories

typedef NS_OPTIONS(NSUInteger, MFCSVParserOptions) {
    MFCSVParserOptionsRecognizesBackslashesAsEscapes = 1 << 0,
    MFCSVParserOptionsSanitizesFields = 1 << 1,
    MFCSVParserOptionsRecognizesComments = 1 << 2
};

@interface NSArray (MFCSVAdditions)

+ (instancetype)arrayWithContentsOfCSVFile:(NSString *)csvFilePath;
+ (instancetype)arrayWithContentsOfCSVFile:(NSString *)csvFilePath options:(MFCSVParserOptions)options;
- (NSString *)CSVString;

@end

@interface NSString (MFCSVAdditions)

- (NSArray *)CSVComponents;
- (NSArray *)CSVComponentsWithOptions:(MFCSVParserOptions)options;

@end
