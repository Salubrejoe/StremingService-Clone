//
//  TitleCollectionViewCell.swift
//  NetflixClone
//
//  Created by Lore P on 11/02/2023.
//  This product uses the TMDB API but is not endorsed or certified by TMDB.

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    
    static let identifier = "TitleCollectionViewCell"
    
    
    private let posterImageView: UIImageView = {
        
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(posterImageView)
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        posterImageView.frame = contentView.bounds
    }
    
    
    
    // MARK: Configure Cell
    // by setting the image from the unwrapped url
    public func configureImageView(with posterPath: String) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)") else { return }
        
        posterImageView.sd_setImage(with: url, completed: nil)
    }
    
    
}
