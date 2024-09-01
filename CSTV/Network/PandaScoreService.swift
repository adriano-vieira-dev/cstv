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

    func fetchMatches(
        page: Int,
        pageSize: Int,
        completion: @escaping CompletionHandler<Matches>
    ) {
        guard let apiKey = ProcessInfo.processInfo.environment["PANDA_SCORE_API_KEY"] else {
            return completion(.failure(CSTVError.missingApiKey))
        }

        let url = URL(string: "https://api.pandascore.co/csgo/matches?filter[status]=running,not_started&sort=begin_at&page=\(page)&per_page=\(pageSize)")!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10

        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "authorization": "Bearer \(apiKey)",
        ]

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error { return completion(.failure(error)) }

            guard let data else { return completion(.failure(CSTVError.noData)) }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            guard let matches = try? decoder.decode(Matches.self, from: data) else {
                return completion(.failure(CSTVError.decodingError))
            }

            return completion(.success(matches))
        }

        task.resume()
    }
    
    func fetchTeams(
        _ ids: [Int],
        completion: @escaping CompletionHandler<Teams>
    ) {
        guard let apiKey = ProcessInfo.processInfo.environment["PANDA_SCORE_API_KEY"] else {
            return completion(.failure(CSTVError.missingApiKey))
        }
        
        let url = URL(string: "https://api.pandascore.co/csgo/teams?filter[id]=\(ids.map { String($0) }.joined(separator: ","))")!
        var request = URLRequest(url: url)

        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "authorization": "Bearer \(apiKey)",
        ]

        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error { return completion(.failure(error)) }

            guard let data else { return completion(.failure(CSTVError.noData)) }

            guard let teams = try? JSONDecoder().decode(Teams.self, from: data) else {
                return completion(.failure(CSTVError.decodingError))
            }

            return completion(.success(teams))
        }

        task.resume()
    }
    
}
