//
//  CaptchaReader.swift
//  CaptchaReader
//
//  Created by Maksymilian Galas on 18/07/2021.
//  Copyright © 2021 Infinity Pi Ltd. All rights reserved.
//

import UIKit
import Vision

final class CaptchaReader {

    enum CaptchaReaderError: Error {
        case missingCGImage
        case failedReadingCaptcha
    }

    // MARK: Properties

    private let textRecognitionWorkQueue: DispatchQueue
    private var textRecognitionRequest: VNRecognizeTextRequest!

    private var completionHandler: ((Result<String, Error>) -> Void)?

    // MARK: Initialization

    init() {
        textRecognitionWorkQueue = DispatchQueue(label: "TextRecognitionQueue", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)

        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: vnRequestCompletionHandler)
        textRecognitionRequest.minimumTextHeight = 0.04
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.customWords = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".map(String.init)
    }

    // MARK: Methods

    private func vnRequestCompletionHandler(request: VNRequest, error: Error?) {
        let observations = request.results as? [VNRecognizedTextObservation]
        let candidates = observations?.map { $0.topCandidates(1).first?.string }

        if let captcha = candidates?.first??.replacingOccurrences(of: " ", with: ""), captcha.count == 5 {
            completionHandler?(.success(captcha))
        } else {
            completionHandler?(.failure(CaptchaReaderError.failedReadingCaptcha))
        }
    }

    func readCaptcha(_ image: UIImage, completionHandler: @escaping (Result<String, Error>) -> Void) {
        guard let cgImage = image.cgImage else {
            completionHandler(.failure(CaptchaReaderError.missingCGImage))
            return
        }

        self.completionHandler = completionHandler

        textRecognitionWorkQueue.async { [weak self] in
            guard let self = self else { return }
            let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try requestHandler.perform([self.textRecognitionRequest])
            } catch {
                completionHandler(.failure(error))
            }
        }
    }

}
