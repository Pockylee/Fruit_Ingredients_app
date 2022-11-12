//
//  ViewController.swift
//  CoreMLImage
//
//  Created by Ahmed Fathi Bekhit on 23/1/2018.
//  Copyright © 2018 AppCoda. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let mlModel = foods()
    
    var welcomeLbl:UILabel = {
        let lb2 = UILabel()
        lb2.text = "WELCOME!!"
        lb2.frame = CGRect(x: 0, y: 0, width: 350, height: 100)
        lb2.textColor = .black
        lb2.textAlignment = .center
        lb2.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/5)
        return lb2
    }()
    
    var importButton:UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Import", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .black
        btn.frame = CGRect(x: 0, y: 0, width: 110, height: 60)
        btn.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height*0.90)
        btn.layer.cornerRadius = btn.bounds.height/2
        btn.tag = 0
        return btn
    }()
    
    var previewImg:UIImageView = {
        let img = UIImageView()
        img.frame = CGRect(x: 0, y: 0, width: 350, height: 350)
        img.contentMode = .scaleAspectFit
        img.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/3)
        return img
    }()
    
    var descriptionLbl:UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true;
        lbl.text = "No Image Content"
        lbl.frame = CGRect(x: 0, y: 0, width: 350, height: 50)
        lbl.textColor = .blue
        lbl.textAlignment = .center
        lbl.center = CGPoint(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/1.5)
        return lbl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        importButton.addTarget(self, action: #selector(importFromCameraRoll), for: .touchUpInside)
        self.view.addSubview(previewImg)
        self.view.addSubview(descriptionLbl)
        self.view.addSubview(importButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func importFromCameraRoll() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            previewImg.image = image
            if let buffer = image.buffer(with: CGSize(width:224, height:224)) {
                guard let prediction = try? mlModel.prediction(image: buffer) else {fatalError("Unexpected runtime error")}
                descriptionLbl.text = prediction.label
                if prediction.label == "banana"{
                    descriptionLbl.text = "香蕉，熱量:91卡；  碳水:23.5公克；  蛋白質：1.3公克"
                }
                else if prediction.label == "apple"{
                    descriptionLbl.text = "蘋果，熱量:卡；  碳水:公克；  蛋白質：公克"
                }
                else if prediction.label == "bluberry"{
                    descriptionLbl.text = "藍莓，熱量:卡；  碳水:公克；  蛋白質：公克"
                }
                else if prediction.label == "watermelon"{
                    descriptionLbl.text = "西瓜，熱量:卡；  碳水:公克；  蛋白質：公克"
                }
                print(prediction.labelProbability)
            }else{
                print("failed buffer")
            }
        }
        dismiss(animated:true, completion: nil)
    }
}


