//
//  ViewController.swift
//  AudioRecorder
//
//  Created by Alfonso Cavallo on 25/02/2020.
//  Copyright © 2020 Alfonso Cavallo. All rights reserved.
//

import UIKit
import AVFoundation
import Speech

class ViewController: UIViewController, SFSpeechRecognizerDelegate
{
    //Variabili di conversione
    let lang = NSLocale.current.languageCode ?? "en"
    //Variabili per i file
    var isRecorded = false
    let filename = FileUtilities.getDirectory().appendingPathComponent("audio.m4a")
    
    //Variabili per lo speech to text
    var speechRecognizer : SFSpeechRecognizer?
    var speechRecognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    var speechRecognitionTask : SFSpeechRecognitionTask?
    
    //Variabili per l'audio
    var isPlaying = false
    var audioSession : AVAudioSession!
    var audioEngine = AVAudioEngine()
    var audioRecorder : AVAudioRecorder!
    var audioDelegate : AudioDelegate!
    var audioPlayer : AVAudioPlayer!
    
    //Outlet del Main Storyboard
    @IBOutlet weak var recordButtonLabel: UIButton!
    @IBOutlet weak var playButtonLabel: UIButton!
    @IBOutlet weak var conversionButton: UIButton!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad()
    {
        //Prepara lo speechDelegate
        let audioDelegate = AudioDelegate(vc: self)
        //Prepara il riconoscitore
        speechRecognizer?.delegate = audioDelegate
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: lang))
    }
    
    //Avvia la procedura di registrazione
    func startRecording()
    {
        //Verifica se ci sono tasks in corso
        if speechRecognitionTask != nil{
            speechRecognitionTask?.cancel()
            speechRecognitionTask = nil
        }
        
        //Prepara la sessione audio
        audioSession = AVAudioSession.sharedInstance()
        
        do
        {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true)
        }
        catch
        {
            print("ERROR WITH AUDIO SESSION")
        }
        
        //Prepara la richiesta
        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        //Prepara il riconoscitore
        let inputNode = audioEngine.inputNode
        
        guard let speechRecognitionRequest = speechRecognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        speechRecognitionRequest.shouldReportPartialResults = true
        
        //Assegna il task
        speechRecognitionTask = speechRecognizer?.recognitionTask(with: speechRecognitionRequest)
        {
            (result, error) in
            
            var isFinal = false
            
            //Esegue tutte le operazione di conversione in stringa in tempo reale
            if result != nil
            {
                let converter = TextToASCIIConverter(result?.bestTranscription.formattedString ?? "")
                self.label.text = converter.convert()
                isFinal = (result?.isFinal)!
            }
            
            //Interrompe la registrazione in caso di errore o di tempo scaduto
            if error != nil || isFinal
            {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                print("ENDING THE RECORDING SESSION")
                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil
            }
        }
        
        //Prepara l'audio engine
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.speechRecognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        //Prova ad avviae l'audio engine
        do
        {
            try audioEngine.start()
        }
        catch
        {
            print("AUDIO ENGINE PROBLEM")
        }
        
        label.text = "I'm listening, say something..."
        
    }
    
    //Azione di registrazione del bottone
    @IBAction func record(_ sender: Any) {
        
        var canRecord = true
        //Richiesta per i permessi di registrare
        AVAudioSession.sharedInstance().requestRecordPermission{ (hasPermission) in
            if !hasPermission
            {
                canRecord = false
            }
        }
        
        //Richiesta per i permessi di utilizzare le funzionalità speechToText
        SFSpeechRecognizer.requestAuthorization { (hasPermission) in
            switch hasPermission
            {
            case .notDetermined:
                canRecord = false
                print("Cannot work because of not determined status of request")
            case .denied:
                canRecord = false
                print("Cannot work because request has been refused")
            case .restricted:
                canRecord = false
                print("Cannot work because of restriction on speech request")
            case .authorized:
                canRecord = true
            @unknown default:
                print("Cannot work because this status cannot be handled")
                canRecord = false
            }
        }
        
        //Verifica se il motore audio sta già lavorando
        if canRecord
        {
            if audioEngine.isRunning
            {
                //Procedura che interrompe la registrazione
                audioEngine.stop()
                audioEngine.inputNode.removeTap(onBus: 0)
                speechRecognitionTask?.cancel()
                speechRecognitionTask?.finish()
                speechRecognitionRequest?.endAudio()
            }
        else
            {
                startRecording()
            }
        }
    }
}
