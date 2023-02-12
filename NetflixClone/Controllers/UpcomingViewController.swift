//
//  UpcomingViewController.swift
//  NetflixClone
//
//  Created by Lore P on 09/02/2023.
//  This product uses the TMDB API but is not endorsed or certified by TMDB.

import UIKit

class UpcomingViewController: UIViewController {
    
    
    var titles: [Title] = []
    
    let upcomingTableView: UITableView = {
        
        let tableView = UITableView()
        tableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        
        return tableView
        
    }()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(upcomingTableView)
        
        // Set title
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        upcomingTableView.delegate = self
        upcomingTableView.dataSource = self
        
        fetchUpcoming()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        upcomingTableView.frame = view.bounds
    }

    
    
    private func fetchUpcoming() {
        
        APICaller.shared.getUpcomingMovies { result in
            
            switch result {
                
            case .success(let titles):
                
                self.titles = titles
                
                DispatchQueue.main.async {
                    self.upcomingTableView.reloadData()
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
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else { return UITableViewCell() }
        
        let titleName = titles[indexPath.row]
        
        cell.configureCell(with: TitleViewModel(posterURL: titleName.poster_path ?? "", originalName: titleName.original_name ?? titleName.original_title ?? ""))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
