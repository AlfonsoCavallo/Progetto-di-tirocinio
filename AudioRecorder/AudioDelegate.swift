//
//  AudioDelegate.swift
//  AudioRecorder
//
//  Created by Alfonso Cavallo on 25/02/2020.
//  Copyright © 2020 Alfonso Cavallo. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class AudioDelegate : NSObject, AVAudioRecorderDelegate, AVAudioPlayerDelegate, SFSpeechRecognizerDelegate
{
    var vc : ViewController
    
    init(vc: ViewController)
    {
        self.vc = vc
    }
}
