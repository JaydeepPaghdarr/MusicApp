//
//  ListCell.swift
//  MusicDemo
//
//  Created by  on 23/09/19.


import UIKit

class ListCell: UITableViewCell {

    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var imgProfile:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var obj : SongsArray! {
        didSet{
            self.imgProfile.image = UIImage(named: obj.albbumImage!)
            self.lblTitle.text = obj.name
            self.imgProfile.layer.cornerRadius = self.imgProfile.frame.height / 2
            self.imgProfile.clipsToBounds = true
        }
    }

}
