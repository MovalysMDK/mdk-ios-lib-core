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

#import <Foundation/Foundation.h>


/*!
 * @brief Définit un bloc permettant de lancer l'enregistrement d'une action en tant que listener
 * Les paramètres dépendent des macros, (à voir dans les 3 macros précédentes)
 */
typedef void (^MFActionListenerBlock)(id, id, id, id);


/********************************************************/
/* MFActionEventDefinition                              */
/********************************************************/

/*!
 * @class MFActionEventDefinition
 * @brief Describes an action event
 */
@interface MFActionEventDefinition : NSObject

/**
 * @brief The object that asks the callback
 */
@property (weak, nonatomic) id objectWithCallBack;

/**
 * @brief The callback to execute
 */
@property (copy) MFActionListenerBlock callBack;

@end




/********************************************************/
/* MFActionMethodDefinition                              */
/********************************************************/

/*!
 * @class MFActionMethodDefinition
 * @brief Describes a method to execute after the action
 */
@interface MFActionMethodDefinition : NSObject

/**
 * @brief The method we want to keep to execute it after the action
 */
@property (nonatomic) SEL selector;

@end



/********************************************************/
/* MFActionClassDefinition                              */
/********************************************************/


/*!
 * @class MFActionClassDefinition
 * @brief Describes a class that launches actions
 */
@interface MFActionClassDefinition : NSObject

/**
 * @brief Contains the listener-methods to execute after the action
 */
@property (strong, nonatomic, readonly) NSMutableArray *methods;

/**
 * @brief Contains the events the class is listening to.
 */
@property (strong, nonatomic, readonly) NSMutableArray *events;

@end