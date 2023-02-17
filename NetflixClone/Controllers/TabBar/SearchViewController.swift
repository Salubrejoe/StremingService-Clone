//
//  SearchViewController.swift
//  NetflixClone
//
//  Created by Lore P on 09/02/2023.
//  This product uses the TMDB API but is not endorsed or certified by TMDB.

import UIKit

class SearchViewController: UIViewController, UISearchResultsUpdating {
    
  
    private var titles = [Title]()
    
    
    private let searchController: UISearchController = {
       
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for Movies or TV shows"
        controller.searchBar.searchBarStyle = .minimal
        
        return controller
    }()
    
    private let discoverTableView: UITableView = {

        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // Set Table View
        view.addSubview(discoverTableView)
        discoverTableView.delegate = self
        discoverTableView.dataSource = self
        
        // Set title
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // Set the Search Controller
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self

        
        fetchDiscoveries()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        discoverTableView.frame = view.bounds
    }
    
    
    func fetchDiscoveries() {
        
        APICaller.shared.getDiscoverMovies { [weak self] result in
            switch result {
            case .success(let discoveries):
                self?.titles = discoveries
                DispatchQueue.main.async {
                    self?.discoverTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: UISearchResultsUpdating stubs
    func updateSearchResults(for searchController: UISearchController) {
            let searchBar = searchController.searchBar
            
            guard let query = searchBar.text,
                  
                // Each white space will be trimmed
                  !query.trimmingCharacters(in: .whitespaces).isEmpty,
                  query.trimmingCharacters(in: .whitespaces).count >= 3,
                  let resultsController = searchController.searchResultsController as? SearchResultsViewController else { return }
            
            APICaller.shared.search(with: query) { result in
                
                DispatchQueue.main.async {
                    
                    switch result {
                        
                    case .success(let titles):
                        resultsController.titles = titles
                        resultsController.searchResultsCollectionView.reloadData()
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }

}


// MARK: Data Source and Delegate
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let titleName = titles[indexPath.row]
        
        cell.configureCell(with: TitleViewModel(posterURL: titleName.poster_path ?? "", originalName: titleName.original_name ?? titleName.original_title ?? ""))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
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


