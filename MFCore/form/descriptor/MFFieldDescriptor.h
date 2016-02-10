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
//  FieldDescriptor.h
//  MFCore
//
//

#import "MFDescriptorCommonProtocol.h"
#import "MFDescriptorCommon.h"

/*!
    Représente la description d'un champ graphiqe.
    Un champ possède plusieurs caractéristiques :
    - un nom
    - un type graphique
    - le caractère obligatoire de saisie du champ d'un point de vue graphique
 */
@interface MFFieldDescriptor : MFDescriptorCommon

#pragma mark - Properties

/*!
 * @brief Le caractère obligatoire du champ
 */
@property NSString *mandatory;

/*!
 * @brief Le caractère éditable ou non du composant
 */
@property (nonatomic, strong) NSString *editable;

/*!
 * @brief La clé utilisée pour le mapping avec le code (si le nom n'est pas défini)
 */
@property(nonatomic, strong) NSString *bindingKey;

/*!
 * @brief Cette propriété représente le nom du sélecteur qui doit être déclenché lorsque
 * la propriété à laquelle il est associé est modifiée.
 */
@property(nonatomic, strong) NSString *vmValueChangedMethodName;

/*!
 * @brief Cette propriété définit l'action à effectuer pour la conversion du champ entre
 * l'affichage graphique et la veleur réelle dans le ViewModel. Ce peut être un convertisseur
 * par défaut (float, date, etc ...) ou le nom d'une méthode à appeler pour effectuer une conversion
 * personnalisée.
 */
@property(nonatomic, strong) id converter;

/*!
 * @brief La couleur de fonc du champ
 */
@property(nonatomic, strong) NSString *backgroundColor;

/*!
 * @brief La couleur du texte du champ
 */
@property(nonatomic, strong) NSString *textColor;

/*!
 * @brief La valeur par défaut
 */
@property(nonatomic, strong) NSString *i18nKey;

/*!
 * @brief Action d'édition
 */
@property(nonatomic, strong) NSString *editItemListener;

/*!
 * @brief Action d'ajout
 */
@property(nonatomic, strong) NSString *addItemListener;

/*!
 * @brief Action de suppression
 */
@property(nonatomic, strong) NSString *deleteItemListener;

/*!
 * @brief Une liste de données spécifiques au champ associé
 */
@property(nonatomic, strong) NSMutableDictionary *parameters;

/*!
 * @brief Une liste de paire MFUIBaseComponent/Couleurs pour les composants contenant d'autres MFUIBasecomponent.
 */
@property(nonatomic, strong) NSDictionary *innerComponentsBackgroundColor;

/*!
 * @brief binding key with the property of the cell
 */
@property(nonatomic, strong) NSString *cellPropertyBinding;

/*!
 * @brief Alignement
 */
@property(nonatomic, strong) NSString *componentAlignment;


#pragma mark - Methods

/*!
 * @brief Retourne le label du champ
 * @return Le label du champ
 */
-(NSString *) getLabel;


@end
