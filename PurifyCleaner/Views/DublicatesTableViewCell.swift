//
//  DublicatesTableViewCell.swift
//  Cleaner
//
//  Created by Neon Apps on 19.07.2020.
//  Copyright © 2020 Neon Apps. All rights reserved.
//

import UIKit
import Photos

protocol DublicatesTableViewCellDelegate {
    func deleteAssetes(toDelete: [PHAsset])
}

class DublicatesTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var dubsCollectionView: UICollectionView!
    

    var duplicates: [PHAsset]?
    var currentId = 0
    var previewAsset: PHAsset?
    var previewId = 0
    var delegate: DublicatesTableViewCellDelegate?
    
    var selectedImageIndex = 0
    
    @IBAction func saveThisAction() {

    }
    
    var alertWindow: UIWindow?
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        dubsCollectionView.delegate = self
        dubsCollectionView.dataSource = self
        dubsCollectionView.backgroundColor = .clear
    }
    
    func reload(duplicates: [PHAsset]) {
        if duplicates == self.duplicates { return }
        self.duplicates = duplicates
        self.dubsCollectionView.reloadData()
        self.setPreview()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func willRemoveSubview(_ subview: UIView) {
        ImageManager.cancelImageRequest(id: currentId)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! DublicateCollectionViewCell
        
        NotificationCenter.default.post(name: Notification.Name("ClosePopup"), object: nil)
     
        self.dubsCollectionView.reloadData()
        
        
        UIView.animate(withDuration: 0.05, animations: {cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)}) { _ in
            UIView.animate(withDuration: 0.20) {
                cell.transform = .identity
            }
        }
        
        self.layoutSubviews()
        if let asset = cell.photoAsset {
            if asset == self.previewAsset { return }
            self.previewAsset = asset
            self.setPreview()
        }
    }
    
    
    override func prepareForReuse() {
        self.previewAsset = nil
    }
    
    func setPreview() {
        self.previewAsset = self.previewAsset ?? self.duplicates?.first
        self.currentId = ImageManager.takeImageFromAsset(asset: self.previewAsset!, completion: { photo, id in
            DispatchQueue.main.async {
                if self.currentId == id {
                    self.previewImageView.image = photo
                    self.layoutIfNeeded()
                    self.layoutSubviews()
                }
            }
        })
        
        
      
      
        
        
        
        
    }
    
    @objc func cancelClicked(){
        
        NotificationCenter.default.post(name: Notification.Name("ClosePopup"), object: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return duplicates?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DublicateCollectionViewCell
        ImageManager.cancelImageRequest(id: cell.currentId)
        
        cell.photoAsset = self.duplicates![indexPath.row]
        cell.reload()
        
        
      
        // Cross btn degisken yeri
        
            
            cell.crossImage.image = UIImage(named: "btn_cross_imgUI")
            cell.crossImage.frame  = CGRect(x: 49, y: 5, width: 30, height: 30)
            cell.crossImage.backgroundColor = .clear
            cell.adapt_height_to_SW()
            
        
    
    
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(deleteImage))
        cell.crossImage.isUserInteractionEnabled = true
        cell.crossImage.addGestureRecognizer(recognizer)
        cell.crossImage.tag = indexPath.row
     
      
        if cell.photoAsset?.localIdentifier == self.previewAsset?.localIdentifier {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
            cell.imageView.borderColor = UIColor().mainColorFirst()
            cell.imageView.borderWidth = 3.0
        } else {
            cell.imageView.borderColor = UIColor().bgFloat()
            cell.imageView.borderWidth = 2.0
        }
        
        cell.imageView.cornerRadiusSize = 0
       
        return cell
    }
    
    @objc func deleteImage(recognizer : UITapGestureRecognizer){
        
       
    
     
        let index = recognizer.view!.tag
        let indexPath = IndexPath(item: index, section: 0)
//        let cell = collectionView.cellForItem(at: indexPath) as! DublicateCollectionViewCell
      
        
     
        self.delegate?.deleteAssetes(toDelete: [duplicates![index]])
        
        
        let cell = dubsCollectionView.cellForItem(at: indexPath) as! DublicateCollectionViewCell
        self.dubsCollectionView.reloadData()
        
        
        UIView.animate(withDuration: 0.05, animations: {cell.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)}) { _ in
            UIView.animate(withDuration: 0.20) {
                cell.transform = .identity
            }
        }
        
        self.layoutSubviews()
        if let asset = cell.photoAsset {
            if asset == self.previewAsset { return }
            self.previewAsset = asset
            self.setPreview()
        }

 
    }
      
}
