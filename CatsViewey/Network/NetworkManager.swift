//
//  NetworkManager.swift
//  CatsViewey
//
//  Created by Andrii on 07.10.2021.
//

import Foundation

class NetworkManager {
    typealias ResponseHandler = (Result<ImageData, Error>) -> ()

    private var runningTasks = [UUID: URLSessionDataTask]()
    private var page = 0
    private var imagesPerPage = 500
    private var pageLoadTask: URLSessionDataTask?

    private var requestBase = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=046f2e7a9013f972a03d67c0747f5193"
    private let tag = "kitty"
    private let imageUrlBase = "https://live.staticflickr.com/"
    
    private func createUrl(for page: Int) -> URL? {
        let stringUrl = requestBase + "&tags=\(tag)" + "&per_page=\(imagesPerPage)" + "&page=\(page)" + "&format=json&nojsoncallback=1"

        return URL(string: stringUrl)
    }
    
    private func stopAllTasks() {
        for (k, _) in runningTasks {
            runningTasks[k]?.cancel()
            runningTasks.removeValue(forKey: k)
        }
    }
    
    func fetchImages(page: Int = 1, handler: @escaping ResponseHandler) {
        if let _ = pageLoadTask { return }

        guard let imagesUrl = createUrl(for: page) else { return }

        let sesion = URLSession(configuration: .default)
        let task = sesion.dataTask(with: imagesUrl) { [weak self] data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let data = try decoder.decode(ImageData.self, from: data)
                    self?.stopAllTasks()
                    handler(.success(data))
                } catch {
                    handler(.failure(error))
                }
            }
            self?.pageLoadTask = nil
        }
        task.resume()
        pageLoadTask = task
    }
    
    func fetchImage(server: String, id: String, secret: String, caller: UUID, handler: @escaping (Data)->()) {
        let imageUrl = imageUrlBase + "\(server)/\(id)_\(secret).jpg"
        if let url = URL(string: imageUrl) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    handler(data)
                }
            }
            task.resume()
            runningTasks[caller] = task
        }
    }
    
    func cancelTask(taskFor key: UUID) {
        if let task = runningTasks[key] {
            task.cancel()
            runningTasks.removeValue(forKey: key)
        }
    }

}
