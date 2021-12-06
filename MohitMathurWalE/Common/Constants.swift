//
//  Constants.swift
//  MohitMathurWalE
//
//  Created by Mohit Mathur on 01/12/21.
//

import Foundation

struct ApiUrls {
    static let nasaApiKey = "NRMxhCTS01OF0WFTHe8K172xg5rbaCeMmjhdo1sc"
    static let nasaApodApi = "https://api.nasa.gov/planetary/apod?api_key=\(nasaApiKey)"
}

struct AlertMessages {
    static let currentPictureNotAvailable = "We are not connected to the internet, showing you the last image we have."
}

struct AlertTitles {
    static let errorTItle = "Error"
}
