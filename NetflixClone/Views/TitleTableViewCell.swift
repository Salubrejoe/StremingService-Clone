//
//  TitleTableViewCell.swift
//  NetflixClone
//
//  Created by Lore P on 12/02/2023.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    static let identifier = "TitleTableViewCell"
    
    
    public let playTitleButton: UIButton = {
       
        let button                                       = UIButton()
        button.tintColor                                 = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        return button
    }()
    public let titleLabel: UILabel = {
       
        let label                                       = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines                             = 2
        return label
    }()
    public let titlePosterImageView: UIImageView = {
       
        let imageView                                       = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds                             = true
        return imageView
    }()
    private func applyContraints() {
        
        let titlePosterImageViewContraints = [
            
            titlePosterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titlePosterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titlePosterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            titlePosterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let playTitleButtonContraints = [
            
            playTitleButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playTitleButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playTitleButton.widthAnchor.constraint(equalToConstant: 40)
    
        ]
        
        let titleLabelContraints = [
            
            titleLabel.leadingAnchor.constraint(equalTo: titlePosterImageView.trailingAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: playTitleButton.leadingAnchor, constant: -20)
        
        ]
        
        
        
        NSLayoutConstraint.activate(titlePosterImageViewContraints)
        NSLayoutConstraint.activate(titleLabelContraints)
        NSLayoutConstraint.activate(playTitleButtonContraints)
        
    }
    
    
    // INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titlePosterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(playTitleButton)
        
        applyContraints()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: Cell configuration from model
    public func configureCell(with model: TitleViewModel) {
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL ?? "")") else { return }
        
        titlePosterImageView.sd_setImage(with: url)
        
        titleLabel.text = model.originalName
    }  
}

