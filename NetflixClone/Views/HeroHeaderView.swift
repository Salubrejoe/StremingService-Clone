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
        
        let button                                       = UIButton()
        button.layer.borderColor                         = UIColor.white.cgColor
        button.layer.borderWidth                         = 1
        button.layer.cornerRadius                        = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Download", for: .normal)
        return button
    }()
    private let playButton: UIButton = {
        
       let button                                        = UIButton()
        button.configuration                             = .filled()
        button.tintColor                                 = .white
        button.layer.cornerRadius                        = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play", for: .normal)
        return button
    }()
    private func applyContraints() {
        
        let playButtonContraints = [
            
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let downloadButtonContraints = [
            
            downloadButton.leadingAnchor.constraint(equalTo: playButton.trailingAnchor, constant: 20),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(playButtonContraints)
        NSLayoutConstraint.activate(downloadButtonContraints)
    }
    
    
    
    // MARK: ImageView and Gradient
    private var heroImageView: UIImageView = {
       
        let imageView           = UIImageView()
        imageView.contentMode   = .scaleToFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    private func addGradient() {
        let gradientLayer    = CAGradientLayer()
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
    
    
    // MARK: Call to sd_set image to configure the headerImageView
    public func configure(with model: TitleViewModel) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL ?? "")") else { return }
        
        heroImageView.sd_setImage(with: url, completed: nil)
    }
}
