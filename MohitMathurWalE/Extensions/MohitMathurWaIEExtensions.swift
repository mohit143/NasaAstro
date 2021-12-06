//
//  MohitMathurWaIEExtensions.swift
//  MohitMathurWalE
//
//  Created by Mohit Mathur on 02/12/21.
//

import Foundation
import UIKit

extension UIImageView {
    func setImage(from url: URL, withPlaceholder placeholder: UIImage? = nil) {
        let imageCache = NSCache<NSString, AnyObject>()
        let activityIndicator = setupActivityIndicator()
        self.image = placeholder
        activityIndicator.startAnimating()
        
        // retrieves image if already available in cache
        if let imageFromCache = imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = imageFromCache
            activityIndicator.stopAnimating()
            return
        }
        // image does not available in cache.. so retrieving it from url...
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print(error as Any)
                DispatchQueue.main.async(execute: {
                    activityIndicator.stopAnimating()
                })
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data)
                imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                self.image = imageToCache
                LocalDbManager.sharedManager.saveToDocumentDirectory(image: imageToCache!, forKey: url.absoluteString)
                activityIndicator.stopAnimating()
            }
        }.resume()
    }
    
    func setupActivityIndicator() -> UIActivityIndicatorView{
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .darkGray
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        return activityIndicator
    }
}
