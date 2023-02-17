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
    
    
    private let titleLabel: UILabel = {
       
        let label                                       = UILabel()
        label.textColor                                 = .white
        label.font                                      = .systemFont(ofSize: 10, weight: .light)
        label.numberOfLines                             = 2
        label.shadowColor                               = .black
        label.clipsToBounds                             = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let posterImageView: UIImageView = {
        
        let image         = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    func addConstraints() {
        let titleLabelContraints = [
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 80)
        ]
        
        NSLayoutConstraint.activate(titleLabelContraints)
    }
    
    
    
    // MARK: Initialiser
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
    // and the label
    public func configureLabel(with originalName: String) {
        
        self.titleLabel.text = originalName
        contentView.addSubview(titleLabel)
        addConstraints()
    }
    
    
    
}
