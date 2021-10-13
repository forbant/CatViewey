//
//  MainViewModel.swift
//  CatsViewey
//
//  Created by Andrii on 12.10.2021.
//

import Foundation

class MainViewModel {
    private let networkManager = NetworkManager()
    private var photos = [Photo]() {
        didSet {
            updateView?()
        }
    }
    private var images = [Int: Data]()
    private var nextPage = 1

    var updateView: (()->())?
    
    func getImageList() {
        networkManager.fetchImages(page: nextPage) { [weak self] responseResult in
            switch(responseResult) {
            case .success(let images):
                self?.addPhotosToList(newList: images.photos.photo)
            case .failure(let error):
                debugPrint("Fetch error:\n\(error.localizedDescription)")
            }
            self?.nextPage += 1
        }
    }
    
    func getImageForCell(index: Int, cell: UUID, handler: @escaping (Data)->()) {
        if index >= photos.count - 200 {
            getImageList()
        }
        
        let photo = photos[index]
        networkManager.fetchImage(
            server: photo.server,
            id: photo.id,
            secret: photo.secret,
            caller: cell
        ) { data in
            handler(data)
        }
        
    }
    
    func cellReused(_ uuid: UUID) {
        networkManager.cancelTask(taskFor: uuid)
    }
    
    func getTextForCell(index: Int) -> String {
        return String(index)
    }
    
    func getPhotosCount() -> Int {
        return photos.count
    }
    
    private func addPhotosToList(newList: [Photo]) {
        photos.append(contentsOf: newList)
    }
}
