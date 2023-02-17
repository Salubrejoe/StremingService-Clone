//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Lore P on 09/02/2023.
//  This product uses the TMDB API but is not endorsed or certified by TMDB.

import UIKit

class UpcomingViewController: UIViewController {
    
    
    var upcomingTitles: [Title] = []
    
    let upcomingTableView = UITableView()

    
    // MARK: View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(upcomingTableView)
        upcomingTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        
        // Set title
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        fetchUpcomingTitles()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upcomingTableView.frame = view.bounds
    }
    
    
    // MARK: APICaller
    private func fetchUpcomingTitles() {
        
        APICaller.shared.getUpcomingMovies { [weak self] result in
            
            switch result {
                
            case .success(let titles):
                
                self?.upcomingTitles = titles
                
                DispatchQueue.main.async {
                    self?.upcomingTableView.reloadData()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}


// MARK: Data Source and Delegate
extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let titleName = upcomingTitles[indexPath.row]
        
        cell.configureCell(with: TitleViewModel(posterURL: titleName.poster_path ?? "", originalName: titleName.original_name ?? titleName.original_title ?? ""))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = upcomingTitles[indexPath.row]
        
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

}
