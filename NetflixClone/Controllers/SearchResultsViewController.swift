//
//  SearchResultsViewController.swift
//  NetflixClone
//
//  Created by Lore P on 13/02/2023.
//

import UIKit

// MARK: Delegate protocol
protocol SearchResultsViewControllerDelegate: AnyObject {
    func didSelectSearchResult(_ viewModel: TitlePreviewModel)
}



class SearchResultsViewController: UIViewController {
    // MARK: Delegate variable
    weak var delegate: SearchResultsViewControllerDelegate?
    
    
    public var searchResultTitles = [Title]()
    
    public let searchResultsCollectionView: UICollectionView = {
       
        var layout                     = UICollectionViewFlowLayout()
        layout.itemSize                = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        
        return collectionView
    }()

    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = .systemBackground
        
        // Set Collection View
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.dataSource = self
        searchResultsCollectionView.delegate = self

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        searchResultsCollectionView.frame = view.bounds
    }
}


// MARK: Data Source and Delegate
extension SearchResultsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        
        let title = searchResultTitles[indexPath.row]
        
        cell.configureImageView(with: title.poster_path ?? "")
        cell.configureLabel(with: title.original_name ?? title.original_title ?? "")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = searchResultTitles[indexPath.row]
        let titleName = title.original_name ?? "" + "trailer"
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            
            switch result {
                
            case .success(let videoElement):
                
                self?.delegate?.didSelectSearchResult(TitlePreviewModel(title: title.original_name ?? title.original_title ?? "", youTubeVideo: videoElement, overview: title.overview ?? ""))
            
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
