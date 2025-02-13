//
//  APIService.swift
//  FifaSB
//
//  Created by Murathan Karasu on 12.02.2025.
//
import Foundation

class APIService {
    static let shared = APIService() // Singleton Pattern tek bir nesneyi dağıtarak kullanmamızı sağlıyor shared ile

    private let baseURL = "https://fifaindex.com/api/v1/players"

    func fetchPlayers(completion: @escaping (Result<[Player], Error>) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(.failure(NSError(domain: "Null URL", code: 400, userInfo: nil)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "Empty Data", code: 404, userInfo: nil)))
                return
            }

            do {
                let playersResponse = try JSONDecoder().decode([Player].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(playersResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

