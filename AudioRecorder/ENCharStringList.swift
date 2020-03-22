//
//  ENCharStringList.swift
//  AudioRecorder
//
//  Created by Alfonso Cavallo on 29/02/2020.
//  Copyright © 2020 Alfonso Cavallo. All rights reserved.
//

import UIKit

class ENCharStringList: NSObject
{
    static var charStringList : [(char: String, definitions: [String])] = [
        //Char
        (" ", ["space"]),
        ("!", ["exclamation mark", "exclamation"]),
        ("\"", ["quote", "apostrophe", "single quote mark"]),
        ("#", ["pound", "number sign"]),
        ("$", ["dollar", "dollar sign"]),
        ("&", ["ampersand"]),
        ("'", ["apostrophe", "single quote mark"]),
        ("(", ["left parenthesis"]),
        (")", ["right parenthesis"]),
        ("%", ["percent", "module"]),
        ("*", ["asterisk"]),
        ("+", ["plus", "plus sign"]),
        (",", ["comma"]),
        ("-", ["minus", "dash"]),
        ("_", ["underscore"]),
        (".", ["period", "decimal point", "full stop", "dot"]),
        ("/", ["slash", "virgule", "solidus"]),
        ("//", ["backslash"]),
        (":", ["colon"]),
        (";", ["semicolon"]),
        ("<", ["less than", "less-than sign", "less than sign", "less"]),
        (">", ["greater than", "greater-than sign", "greater than sign", "greater"]),
        ("=", ["equal", "equals", "equal sign"]),
        ("?", ["question mark"]),
        ("`", ["grave", "grave accent", "spacing grave accent", "back apostrophe"]),
        ("{",["left brace"]),
        ("}", ["right brace"]),
        ("[", ["left bracket"]),
        ("]", ["right bracket"]),
        ("|", ["vertical bar", "bar"]),
        ("~", ["tilde"]),
        //Special Swift Operands
        //Logic
        ("&&", ["and"]),
        ("||", ["or"]),
        ("!", ["not"]),
        ("<=", ["less equal", "less-equal"]),
        (">=", ["greater equal", "greater-equal"]),
        ("==", ["confront", "equal to"]),
        ("===", ["same of"]),
        ("!==", ["different from"]),
        //Declarations
        ("//", ["comment"]),
        ("var", ["variable", "attribute"]),
        ("let", ["constant"]),
        ("struct", ["structure"]),
        ("typealias", ["type alias"]),
        ("init", ["initializer", "initialize"]),
        ("deinit", ["deinitializer", "deinitialize"]),
        ("func", ["function"]),
        ("enum", ["enumeration"]),
        ("->", ["gives"]),
        ("inout", ["input output"]),
        //Types
        ("Int", ["integer"]),
        ("Float", ["float"]),
        ("Double", ["double"]),
        ("Boolean", ["bowl"]), //Per correggere l'incapacità dell'assistente di leggere "Bool"
        ("String", ["string"]),
        ("Char", ["char"]),
        //Expression and tipes
        ("nil", ["nothing"]),
        ("dynamicType", ["dynamic type"]),
        //Specific contests
        ("didSet", ["did set"]),
        ("willSet", ["will set"]),
        ("nonmutating", ["not mutating", "non mutating"]), //Valutare la possibilità di effettura una seconda conversione della stringa per evitare conflitti tra "not" e "not mutating" OPPURE implementare un sistema di priorità
        //Numbers
        ("0", ["zero"]),
        ("1", ["one"]),
        ("2", ["two"]),
        ("3", ["three"]),
        ("4", ["four"]),
        ("5", ["five"]),
        ("6", ["six"]),
        ("7", ["seven"]),
        ("8", ["eight"]),
        ("9", ["nine"]),
        ("10", ["ten"]),
        ]
    
    //Converte un array di parole o espressioni sostituendo i termini con il loro carattere o operatore corrispondente
    static func convertArray(words: [String]) -> [String]
    {
        var i = 0
        var convertedWords = [String]()
        while i < words.count
        {
            convertedWords.append(convertWord(words: words, index: i).str)
            i += 1 + convertWord(words: words, index: i).offset
        }
        return convertedWords
    }
    
    //Converte una parola o un espressione nel carattere o operatore corrispondente
    static func convertWord(words: [String], index: Int) -> (str: String, offset: Int)
    {
        let tuple = compareWord(word: words[index])
        if tuple.term != nil
        {
            var offset = 0
            for word in tuple.term!.lowercased().components(separatedBy: " ")
            {
                if index + offset < words.count && words[index + offset] == word
                {
                    offset += 1
                }
                else
                {
                    return (words[index], 0)
                }
            }
            return  (tuple.char!, offset - 1)
        }
        else
        {
            return (words[index], 0)
        }
    }
    
    //Cerca nella lista un termine che abbia come prima parola la parola passata come parametro e restituisce il termine completa e il carattere corrispondente
    static func compareWord(word: String) -> (term: String?, char: String?)
    {
        for elem in charStringList
        {
            for definition in elem.definitions
            {
                if definition.lowercased().components(separatedBy: " ")[0] == word
                {
                    return (definition, elem.char)
                }
            }
        }
        return (nil, nil)
    }
    
    
}
