//
//  PictureViewModel.swift
//  MohitMathurWalE
//
//  Created by Mohit Mathur on 01/12/21.
//

import Foundation

class PictureViewModel : NSObject {
    
    private var showErrorAlert = false
    
    private(set) var pictureData : PictureModel! {
        didSet {
            self.bindPictureViewModelToController(pictureData as Any, showErrorAlert)
        }
    }
    
    private(set) var pictureLocalData : AstroPicture! {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [self] in
                self.bindPictureViewModelToController(pictureLocalData as Any, showErrorAlert)
            }
        }
    }
    
    var bindPictureViewModelToController : ((Any, Bool) -> ()) = {_,_  in }
    var apiService : APIServiceProtocol?
    
    init(serviceObject: APIServiceProtocol = ApiServiceManager.shared) {
        super.init()
        apiService = serviceObject
        if NetworkMonitor.shared.isReachable == true{
            callFuncToGetPictureData()
        }
        else{
            callFuncToGetPictureDataFromLocal()
        }
    }
    
    func callFuncToGetPictureData() {
        apiService!.get(urlString: ApiUrls.nasaApodApi, completionBlock: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error):
                print ("failure", error)
            case .success(let data) :
                let decoder = JSONDecoder()
                do
                {
                    self.showErrorAlert = false
                    self.pictureData = try decoder.decode(PictureModel.self, from: data)
                } catch {
                    // deal with error from JSON decoding!
                }
            }
        })
    }
    func callFuncToGetPictureDataFromLocal(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let currentDateLocalPicture = LocalDbManager.sharedManager.fetchPicture(date: dateFormatter.string(from: Date())){
            self.showErrorAlert = false
            self.pictureLocalData = currentDateLocalPicture
        }
        else{
            self.showErrorAlert = true
            self.pictureLocalData = LocalDbManager.sharedManager.fetchLastViewedPicture()
        }
    }
}
