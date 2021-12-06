//
//  PictureViewController.swift
//  MohitMathurWalE
//
//  Created by Mohit Mathur on 01/12/21.
//

import UIKit

class PictureViewController: UIViewController {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgPicture: UIImageView!
    
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var lblPlaceholder: UILabel!
    
    private var pictureViewModel : PictureViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callToViewModelForUIUpdate()
        // Do any additional setup after loading the view.
    }
    
    func callToViewModelForUIUpdate(){
        
        self.pictureViewModel =  PictureViewModel()
        self.pictureViewModel.bindPictureViewModelToController = { (returnedObject, showErrorAlert) in
            print("x")
            DispatchQueue.main.async {
                self.setDataToUI(pictureObject: returnedObject,showErrorAlert: showErrorAlert)
            }
        }
    }
    
    func setDataToUI(pictureObject : Any, showErrorAlert : Bool){
        lblPlaceholder.isHidden = true
        if pictureObject is AstroPicture{
            let localPictureObject = pictureObject as! AstroPicture
            lblTitle.text = localPictureObject.title
            lblDescription.text = localPictureObject.explaination
            
            if let imageUrl = localPictureObject.image{
                imgPicture.image = LocalDbManager.sharedManager.fetchFromDocumentDirectory(forKey: imageUrl)
            }
            if showErrorAlert == true{
                let alert = UIAlertController(title: AlertTitles.errorTItle, message: AlertMessages.currentPictureNotAvailable, preferredStyle: UIAlertController.Style.alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        }
        else{
            lblTitle.text = pictureViewModel.pictureData.title
            lblDescription.text = pictureViewModel.pictureData.explanation
            if let imageUrl = pictureViewModel.pictureData.url{
                imgPicture.setImage(from: URL(string: imageUrl)!, withPlaceholder: nil)
            }
            DispatchQueue.global(qos: .background).async { [self] in
                LocalDbManager.sharedManager.savePicture(pictureModel: pictureViewModel.pictureData)
            }
        }
    }
    
}

