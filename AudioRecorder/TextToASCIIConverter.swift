//
//  TextToASCIIConverter.swift
//  AudioRecorder
//
//  Created by Alfonso Cavallo on 27/02/2020.
//  Copyright © 2020 Alfonso Cavallo. All rights reserved.
//

import UIKit

class TextToASCIIConverter: NSObject {
    
    //L'array di parole di convertire in caratteri ASCII
    var string : String = ""
    var words : [String]
    
    init(_ string : String)
    {
        //Rimuove le maiuscole
        self.string = string.lowercased()
        self.string = TextToASCIIConverter.introduceWhiteBetweenSpecialChar(self.string)
        //Divide la string in parole
        words = self.string.components(separatedBy: " ")
    }
    
    func stringToWords(_ string: String) -> [String]
    {
        return string.lowercased().components(separatedBy: " ")
    }
    
    func wordsToString(_ words: [String]) -> String
    {
        var outputString = ""
        for word in words
        {
            outputString.append("\(word) ")
        }
        return outputString
    }

    //Introduce lo spazio tra i caratteri speciali
    static func introduceWhiteBetweenSpecialChar(_ str: String) -> String
    {
        let output = str.replacingOccurrences(of: "\n", with: " \n ").replacingOccurrences(of: ",", with: " , ").replacingOccurrences(of: ")", with: " ) ").replacingOccurrences(of: "(", with: " ( ")
        return output
    }
    
    //Rimuove lo spazio tra i caratteri speciali
    static func removeWhiteBetweenSpecialChar(_ str: String) -> String
    {
        let output = str.replacingOccurrences(of: "\n ", with: "\n").replacingOccurrences(of: " , ", with: ", ").replacingOccurrences(of: " ( ", with: "(").replacingOccurrences(of: " ) ", with: ") ")
        return output
    }
    
    //Converte tutte le definizioni della stringa nei corrispondenti caratteri e operatori
    //Tiene anche conto di alcuno problemi di formattazione dovuti alle new line
    func convert() -> String
    {
        return TextToASCIIConverter.removeWhiteBetweenSpecialChar(wordsToString(ENCharStringList.convertArray(words: words)))
    }
}
