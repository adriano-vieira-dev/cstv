//
//  PandaScoreService.swift
//  CSTV
//
//  Created by Adriano Vieira on 30/08/24.
//

import Foundation

typealias CompletionHandler<T> = (Result<T, Error>) -> Void

class PandaScoreService {
    // MARK: - Singleton Instance

    static let shared = PandaScoreService()

    // Private initializer to ensure singleton
    private init() {}

    func fetchMatches(completion: @escaping CompletionHandler<Matches>) {
        guard let apiKey = ProcessInfo.processInfo.environment["PANDA_SCORE_API_KEY"] else {
            return completion(.failure(CSTVError.missingApiKey))
        }

        let url = URL(string: "https://api.pandascore.co/csgo/matches")!
        print(url.absoluteString)
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        let queryItems: [URLQueryItem] = [
//            URLQueryItem(name: "filter[begin_at]", value: "2024-08-30T16%3A30%3A00Z"),
            URLQueryItem(name: "sort", value: "begin_at"),
            URLQueryItem(name: "page", value: "1"),
            URLQueryItem(name: "per_page", value: "1"),
        ]
        components.queryItems = components.queryItems.map { $0 + queryItems } ?? queryItems

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "authorization": "Bearer \(apiKey)",
        ]

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error {
                return completion(.failure(error))
            }

            guard let data else {
                return completion(.failure(CSTVError.noData))
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            guard let matches = try? decoder.decode(Matches.self, from: data) else {
                return completion(.failure(CSTVError.decodingError))
            }
            
            return completion(.success(matches))
        }

        task.resume()
    }
}
