//
//  ImageData.swift
//  CatsViewey
//
//  Created by Andrii on 07.10.2021.
//

import Foundation

struct ImageData: Decodable {
    let photos: Photos
    let stat: String
}

// MARK: - Photos
struct Photos: Decodable {
    let page, pages, perpage, total: Int
    let photo: [Photo]
}

// MARK: - Photo
struct Photo: Decodable {
    let id, owner, secret, server: String
    let farm: Int
    let title: String
    let ispublic, isfriend, isfamily: Int
}
