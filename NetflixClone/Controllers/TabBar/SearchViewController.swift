//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Lore P on 09/02/2023.
//  This product uses the TMDB API but is not endorsed or certified by TMDB.

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
  
    private var discoveriesTitles = [Title]()
    
    private let discoveriesTableView = UITableView()

    
    // MARK: Search Controller
    private let searchController: UISearchController = {
       
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder    = "Search for Movies or TV shows"
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
    }()
    
    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // Set Table View
        view.addSubview(discoveriesTableView)
        discoveriesTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        discoveriesTableView.delegate   = self
        discoveriesTableView.dataSource = self
        
        // Set Navigation Controller
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles     = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor              = .white
        
        // Set the Search Controller
        navigationItem.searchController               = searchController
        searchController.searchResultsUpdater         = self

        
        fetchDiscoveriesTitles()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        discoveriesTableView.frame = view.bounds
    }
    
    
    // MARK: APICaller
    func fetchDiscoveriesTitles() {
        
        APICaller.shared.getDiscoverMovies { [weak self] result in
            
            switch result {
            
            case .success(let discoveries):
            
                self?.discoveriesTitles = discoveries
                
                DispatchQueue.main.async {
                    self?.discoveriesTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: Protocol stubs
    func updateSearchResults(for searchController: UISearchController) {
            let searchBar = searchController.searchBar
            
            guard let query = searchBar.text,
                  // Each white space will be trimmed
                  !query.trimmingCharacters(in: .whitespaces).isEmpty,
                  query.trimmingCharacters(in: .whitespaces).count >= 3,
                  let resultsController = searchController.searchResultsController as? SearchResultsViewController
            else { return }
            
        resultsController.delegate = self
            
            APICaller.shared.search(with: query) { result in
                
                DispatchQueue.main.async {
                    
                    switch result {
                        
                    case .success(let titles):
                        resultsController.searchResultTitles = titles
                        resultsController.searchResultsCollectionView.reloadData()
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
    }
    
    func didSelectSearchResult(_ viewModel: TitlePreviewModel) {
        
        DispatchQueue.main.async { [weak self] in
            let vc = TitleTrailerViewController()
            vc.configureController(with: viewModel)
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}




// MARK: Data Source and Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveriesTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let titleName = discoveriesTitles[indexPath.row]
        
        cell.configureCell(with: TitleViewModel(posterURL: titleName.poster_path ?? "", originalName: titleName.original_name ?? titleName.original_title ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = discoveriesTitles[indexPath.row]
        guard let titleName = title.original_name ?? title.original_title else { return }
        
        APICaller.shared.getMovie(with: titleName + "trailer") { [weak self] result in
            
            switch result {
            case .success(let videoElement):
                
                DispatchQueue.main.async {
                    
                    let vc = TitleTrailerViewController()
                    vc.configureController(with: TitlePreviewModel(title: titleName, youTubeVideo: videoElement, overview: title.overview ?? ""))
                    
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}


