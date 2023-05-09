//
//  CacheService.swift
//  SnsrViewer
//
//  Created by Илья Малахов on 09.05.2023.
//

import Foundation

enum CacheResult<T: Codable> {
    case successLoad(T)
    case failure
}

protocol CacheServiceProtocol {
    func saveToCache(data: Codable, fileName: String) async throws
    func loadFromCache<T: Codable>(
        fileName: String,
        completion: @escaping ((CacheResult<T>) -> Void)) async throws
}

final class FileCacheService: CacheServiceProtocol {
    func saveToCache(data: Codable, fileName: String) async throws {
        let task = Task {
            let data = try JSONEncoder().encode(data)
            let outfile = try fileURL(fileName)
            try data.write(to: outfile)
        }
        
        _ = try await task.value
    }
    
    func loadFromCache<T: Codable>(
        fileName: String,
        completion: @escaping ((CacheResult<T>) -> Void)
    ) async throws {
        let task = Task<T?, Error> { [weak self] in
            guard let fileURL = try self?.fileURL(fileName) else {
                completion(.failure)
                return nil
            }
            
            guard let data = try? Data(contentsOf: fileURL) else {
                completion(.failure)
                return nil
            }
            
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        }
        
        guard let loaded = try await task.value else {
            completion(.failure)
            return
        }
        
        completion(.successLoad(loaded))
    }
    
    private func fileURL(_ cacheFileName: String) throws -> URL {
        return try FileManager
            .default
            .url(for: .documentDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: false)
            .appendingPathComponent("\(cacheFileName).data")
    }
}
