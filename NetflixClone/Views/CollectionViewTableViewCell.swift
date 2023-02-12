//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Lore P on 09/02/2023.
//  This product uses the TMDB API but is not endorsed or certified by TMDB.

import UIKit

class CollectionViewTableViewCell: UITableViewCell {
    
    
    static let identifier = "CollectionViewTableViewCell"
    
    private var titles: [Title] = []

    private let collectionView: UICollectionView = {
        
        // Create Layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        
        
        // Create and register
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(collectionView)
        
        // Protocol that allows as to display pictures and data
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        collectionView.frame = contentView.bounds
    }
    
    
    
    // MARK: Configure Cell
    // by assigning the self.titles and casting a spell
    public func configureTitles(with titles: [Title]) {
        self.titles = titles
        
        
        // Since the titles has been updated in an async function
        // data need to be reload inside the main thread
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
        
        
    }
}


// MARK: Data Source
extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Dequeue and unwrap a custom TitleCollectionViewCell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // Check for poster_path and use the custom cell method: TitleCollectionViewCell().configureImageView
        guard let posterPath = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configureImageView(with: posterPath)
        
        
        return cell
    }
}
