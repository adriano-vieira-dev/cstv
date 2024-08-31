//
//  CSTVError.swift
//  CSTV
//
//  Created by Adriano Vieira on 30/08/24.
//

import SwiftUI

enum CSTVError: Error, LocalizedError {
    case missingApiKey
    case noData
    case decodingError
    case customError(message: String?)

    var errorDescription: String? {
        switch self {
        case .missingApiKey:
            "Missing API KEY"
        case .noData:
            "No data available"
        case .decodingError:
            "Decoding Error"
        case .customError(let message):
            message
        }
    }
}
