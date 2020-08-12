//
//  AppleTextRecognizer.swift
//  BookZone
//
//  Created by Paianu Vlad-Valentin on 11/08/2020.
//  Copyright © 2020 Paianu Vlad-Valentin. All rights reserved.
//

import UIKit
import Vision

class AppleTextRecognizer {
    
    private var detectedText: [String] = []

     func textRecognize(cgImage: CGImage){
        //guard let cgImage = UIImage(named: "book" )?.cgImage else { return }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
        do {
            // Perform the text-recognition request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the requests: \(error).")
        }
    }

    func recognizeTextHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNRecognizedTextObservation] else {
            return
        }
        let recognizedStrings = observations.compactMap { observation in
            // Return the string of the top VNRecognizedText instance.
            return observation.topCandidates(1).first?.string
        }

        // Process the recognized strings.
        print(recognizedStrings)
        detectedText = recognizedStrings
        
    }
    
    func getStrings () -> [String] {
        return self.detectedText
    }
}
