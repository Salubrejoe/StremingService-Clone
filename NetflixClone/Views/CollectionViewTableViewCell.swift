//
//  CollectionViewTableViewCell.swift
//  NetflixClone
//
//  Created by Lore P on 09/02/2023.
//  This product uses the TMDB API but is not endorsed or certified by TMDB.

import UIKit

// MARK: Delegate protocol
protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewModel)
}


class CollectionViewTableViewCell: UITableViewCell {
    // MARK: Delegate property
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    
    static let identifier = "CollectionViewTableViewCell"
    
    private var titles: [Title] = []
    
    

    private let collectionView: UICollectionView = {
        
        // Create Layout
        let layout                                    = UICollectionViewFlowLayout()
        layout.itemSize                               = CGSize(width: 140, height: 200)
        layout.scrollDirection                        = .horizontal
        // Create and register
        let collectionView                            = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(collectionView)
        
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




// MARK: CV Data Source and Delegate
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else { return }
        
        APICaller.shared.getMovie(with: titleName + "trailer") { [weak self] result in
            
            switch result {
            case .success(let videoElement):
            
                guard let titleOverview = title.overview else { return }
                guard let strongSelf    = self else { return }
                
                let viewModel = TitlePreviewModel(title: title.original_title ?? title.original_name ?? "", youTubeVideo: videoElement, overview: titleOverview)
                
                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
