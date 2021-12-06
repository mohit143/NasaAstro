//
//  PictureModel.swift
//  MohitMathurWalE
//
//  Created by Mohit Mathur on 01/12/21.
//

import Foundation

// MARK: - PictureModel
struct PictureModel: Codable {
    let date, explanation: String?
    let hdurl: String?
    let mediaType, serviceVersion, title: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}
