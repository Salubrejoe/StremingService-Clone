//
//  HeroHeaderView.swift
//  NetflixClone
//
//  Created by Lore P on 10/02/2023.
//  This product uses the TMDB API but is not endorsed or certified by TMDB.

import UIKit

class HeroHeaderView: UIView {
    
    
    // MARK: Buttons
    
    private let downloadButton: UIButton = {
        
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        
        // Contraints
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private let playButton: UIButton = {
        
       let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.configuration = .filled()
        button.tintColor = .white
        button.layer.cornerRadius = 5
        
        // Contraints
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    private func applyContraints() {
        
        let playButtonContraints = [
            
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            
            // Width
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let downloadButtonContraints = [
            
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            
            // Width
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(playButtonContraints)
        NSLayoutConstraint.activate(downloadButtonContraints)
    }
    
    
    
    // MARK: ImageView
    private let heroImageView: UIImageView = {
       
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "ninjaTurtlesMovieImage")
        
        return imageView
    }()
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        
        // Add frame
        gradientLayer.frame = bounds
        
        
        // Add the sublayer to layer
        layer.addSublayer(gradientLayer)
    }
    
    
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyContraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // Method to override to give the collection view a frame
    override func layoutSubviews() {
        super.layoutSubviews()
        
        heroImageView.frame = bounds
    }
}
