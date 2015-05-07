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
//  MFJsonReadHelper.m
//  MFCore
//
//

#import "MFJsonReader.h"
#import "MFApplication.h"
#import "MFJsonMapperServiceProtocol.h"

@implementation MFJsonReader

NSString * const NODE_BEGIN = @":{";
NSString * const NODE_COMPLETION = @"}";
NSString * const ARRAY_BEGIN = @":[";
NSString * const ARRAY_COMPLETION = @"]";
NSString * const STRING_DELIMITER = @"\"";
NSString * const TAG_DELIMITER = @":";

NSString *leftToProcess;
id <MFJsonMapperServiceProtocol> jsonMapper;
int lastReachedPosition, lastCursorPosition, currentPathRank, currentDepth, currentArrayDepth, lastObjectType;
char lastChar, currentChar;
NSMutableArray *currentPath;
BOOL firstOpener;

#pragma mark méthodes publiques
-(id) init
{
    if (self = [super init]) {
        self.object = [[MFJsonObject alloc] init];
        jsonMapper = [[MFApplication getInstance] getBeanWithKey:@"MFJsonMapperServiceProtocol"];
        leftToProcess = [NSString string];
        lastReachedPosition = 0;
        currentPath = [NSMutableArray array];
        currentPathRank = 0;
        firstOpener = true;
        lastObjectType = -1;
    }
    return self;
}

-(BOOL) processMessagePart:(NSString *) p_message
{
    if (p_message == nil || [p_message length] == 0 || [p_message length] <= lastReachedPosition) {
        return false;
    } else {
        leftToProcess = p_message;
        return true;
    }
}

-(BOOL) hasNext
{
    [self processObject];
    return [self.object isComplete];
}

-(NSString *) getCurrentPath
{
    NSString *pathStr = @"root";
    for (int index=0 ; index < [currentPath count] ; index++) {
        if ([[currentPath objectAtIndex:index] length] > 0)
            pathStr = [NSString stringWithFormat:@"%@%@", pathStr, [NSString stringWithFormat:@".%@",[currentPath objectAtIndex:index]]];
    }
    return pathStr;
}

#pragma mark méthodes privéees
/**
 * @brief cherche à reconstituer un objet json
 */
-(void) processObject
{
    BOOL done = false;
    
    if ([self.object isComplete]) {
        lastObjectType = self.object.type;
        self.object = [[MFJsonObject alloc] init];
    }

    if ([leftToProcess length] <= lastReachedPosition) return;
    
    while (!done) {
        [self read];
        switch (lastChar) {
            case '{':
                if (firstOpener) {
                    // on est sur le premier chevron du message
                    firstOpener = false;
                    self.object.type = JSonObjectTypes.CLASS;
                    self.object.contentCompleted = true;
                    self.object.nameCompleted = true;
                    done = true;
                } else {
                    if (self.object.type == JSonObjectTypes.ROW) {
                        // si on est sur une ligne d'un tableau, le caractère doit être traité comme n'importe quel autre
                        self.object.content = [NSString stringWithFormat:@"%@%c", self.object.content, currentChar];
                        self.object.depth++;
                    } else {
                        if ([self.object.name length] == 0) {
                            // on est sur une ligne d'un tableau
                            self.object.type = JSonObjectTypes.ROW;
                            lastObjectType =  JSonObjectTypes.ROW;
                            self.object.nameCompleted = true; // l'objet n'aura pas de nom
                            self.object.content = [NSString stringWithFormat:@"%@%c", self.object.content, currentChar];
                            self.object.depth++; // on avance d'un cran dans la "profondeur"
                        } else {
                            // on devrait être dans une classe et donc avoir "xxxx":{
                            self.object.type = JSonObjectTypes.CLASS;
                            self.object.contentCompleted = true;
                            done = true;
                        }
                    }
                }
                break;
                
            case '}':
                if (self.object.type == JSonObjectTypes.ROW) {
                    // si on est sur une ligne d'un tableau, le caractère doit être traité comme n'importe quel autre
                    self.object.content = [NSString stringWithFormat:@"%@%c", self.object.content, currentChar];
                    self.object.depth--;
                    if (self.object.depth == 0) {
                        // dans ce cas la ligne du tableau est traitée
                        self.object.contentCompleted = true;
                        done = true;
                    }
                } else {
                    if ([self.object isNew]) {
                        // on cloture un objet qui n'est pas le précédent
                        // on indique qu'un a traité un objet pour cloturer un chemin éventuel
                        lastObjectType = JSonObjectTypes.CLASS;
                    } else {
                        // on doit etre dans une ligne d'un tableau
                        self.object.contentCompleted = true;
                        done = true;
                    }
                }
                break;
            case '[':
                if (self.object.type == JSonObjectTypes.ROW) {
                    // si on est sur une ligne d'un tableau, le caractère doit être traité comme n'importe quel autre
                    self.object.content = [NSString stringWithFormat:@"%@%c", self.object.content, currentChar];
                    self.object.depth++;
                } else {
                    if ([self.object isNew]) {
                        // on ne devrait jamais arriver ici
                    } else {
                        // on entre dans le tableau, on va maintenant traiter ses lignes
                        self.object.type = JSonObjectTypes.ARRAY;
                        self.object.contentCompleted = true;
                        done = true;
                    }
                }
                break;
                
            case ']':
                if (self.object.type == JSonObjectTypes.ROW) {
                    // si on est sur une ligne d'un tableau, le caractère doit être traité comme n'importe quel autre
                    self.object.content = [NSString stringWithFormat:@"%@%c", self.object.content, currentChar];
                    self.object.depth--;
                } else {
                    // on indique qu'un a traité un objet pour cloturer un chemin éventuel
                    lastObjectType = JSonObjectTypes.ARRAY;
                }
                break;
                
            case ':':
                if (self.object.type == JSonObjectTypes.ROW) {
                    // si on est sur une ligne d'un tableau, le caractère doit être traité comme n'importe quel autre
                    self.object.content = [NSString stringWithFormat:@"%@%c", self.object.content, currentChar];
                } else {
                    // on a fini de traiter le nom de l'objet
                    self.object.inName = false;
                }
                break;
                
            case ',':
                if (self.object.type == JSonObjectTypes.ROW) {
                    // si on est sur une ligne d'un tableau, le caractère doit être traité comme n'importe quel autre
                    self.object.content = [NSString stringWithFormat:@"%@%c", self.object.content, currentChar];
                }
                // sinon on ne fait rien
                break;
                
            case '"':
                if (self.object.type == JSonObjectTypes.ROW) {
                    // si on est sur une ligne d'un tableau, le caractère doit être traité comme n'importe quel autre
                    self.object.content = [NSString stringWithFormat:@"%@%c", self.object.content, currentChar];
                } else {
                    if ([self.object.name length] == 0) {
                        self.object.inName = true;
                    } else {
                        self.object.inName = false;
                        self.object.nameCompleted = true;
                    }
                }
                break;
                
            default:
                if (currentChar != '\0') {
                    if (self.object.inName && self.object.type != JSonObjectTypes.ROW) {
                        self.object.name = [NSString stringWithFormat:@"%@%c", self.object.name, currentChar];
                    } else {
                        if (self.object.type == -1)
                            self.object.type = JSonObjectTypes.PROPERTY;
                        self.object.content = [NSString stringWithFormat:@"%@%c", self.object.content, currentChar];
                    }
                }
                break;
        }
        
        if (done) {
            // on a composé l'objet
            self.object.path = [self getCurrentPath];
            if (self.object.type == JSonObjectTypes.ROW) {
                // si c'est une ligne de tableau, on la parse
                self.object.content = [jsonMapper fromJson:self.object.content];
            }
        }
        
        done |= (lastReachedPosition >= [leftToProcess length]);
    }
}

/**
 * @brief lit un caractère et reconstitue le cas échéant le "chemin" en cours dans le flux json
 */
-(char) read
{
    currentChar = [leftToProcess characterAtIndex:lastReachedPosition];
    
    if (lastObjectType != JSonObjectTypes.ROW) { // si on traite les lignes d'un tableau, le chemin ne doit pas être impacté
        if (currentChar == '{' || currentChar == '[') {
            if (lastChar == ':' && [[self.object name] length] > 0) {
                currentPathRank++;
                [currentPath addObject:[self.object name]];
            }
            currentDepth++;
        } else if (lastChar == '}' || lastChar == ']') {
            if (currentPathRank > 0) {
                currentPathRank--;
                [currentPath removeObjectAtIndex:currentPathRank];
            }
            currentDepth--;
        }
    }
    
    lastReachedPosition++;
    
    lastChar = currentChar;
    
    return currentChar;
}

@end
