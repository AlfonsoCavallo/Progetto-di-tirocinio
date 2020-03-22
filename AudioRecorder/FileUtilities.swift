//
//  FileUtilities.swift
//  AudioRecorder
//
//  Created by Alfonso Cavallo on 25/02/2020.
//  Copyright © 2020 Alfonso Cavallo. All rights reserved.
//

import UIKit

class FileUtilities
{
    //Ottiene una directory dove salvare l'audio
    static func getDirectory() -> URL
    {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let documentDirectory = path
        return documentDirectory
    }
}
    
