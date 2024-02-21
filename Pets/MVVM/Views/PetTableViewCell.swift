//
//  PetTableViewCell.swift
//  Pets
//
//  Created by Cristian Serea on 20.02.2024.
//

import UIKit
import SDWebImage

class PetTableViewCell: UITableViewCell {
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mainView.applyCornerRadius()
        petImageView.applyCornerRadius()
    }
}

extension PetTableViewCell {
    func setupContent(withPet pet: Pet?) {
        petImageView?.sd_setImage(with: pet?.photos.first?.smallURL,
                                  placeholderImage: pet?.placeholderImage)
        titleLabel.text = pet?.name
        subtitleLabel.text = pet?.speciesGender
        dateLabel.text = pet?.published
        distanceLabel.text = pet?.formattedDistance
        distanceLabel.isHidden = pet?.formattedDistance == nil
    }
}
