//
//  ImageCollectionViewCell.swift
//  DemoHome
//
//  Created by supapon pucknavin on 10/22/2559 BE.
//  Copyright © 2559 DW02. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var viContentBackground: UIView!
    
    var layzyImage:PKImV3View! = nil
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        
        viContentBackground.clipsToBounds = true
        
        
        if(self.layzyImage == nil){
            self.layzyImage = PKImV3View(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
            self.viContentBackground.addSubview(self.layzyImage)
            self.viContentBackground.clipsToBounds = true
        }
        
        self.layzyImage.layer.cornerRadius = 2
        
        self.layzyImage.imageView.contentMode = .scaleAspectFill
        
    }

    
    
    func updateFrameSize(size:CGSize) {
        self.layzyImage.updateFrame(newFrame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        //self.layzyImage.updateFrame(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height), ContentMode: UIViewContentMode.scaleAspectFill)
    }
}
