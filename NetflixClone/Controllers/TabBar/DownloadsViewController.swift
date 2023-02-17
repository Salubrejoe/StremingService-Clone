//
//  DownloadsViewController.swift
//  NetflixClone
//
//  Created by Lore P on 09/02/2023.
//  This product uses the TMDB API but is not endorsed or certified by TMDB.

import UIKit

class DownloadsViewController: UIViewController {
    
    
    private var downloadsTitles = [TitleItem]()
        
    private let downloadsTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemRed
        
        // Set title
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        // Set TableView
        view.addSubview(downloadsTableView)
        downloadsTableView.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        downloadsTableView.delegate = self
        downloadsTableView.dataSource = self
        
        
        fetchLocalStorageForDownload()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        downloadsTableView.frame = view.bounds
    }
    
    
    private func fetchLocalStorageForDownload() {
        DataPersistanceManager.shared.fetchDownloadedTitlesFromDatabase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.downloadsTitles = titles
                self?.downloadsTableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
    
    
// MARK: TV Delegate and Data Source
extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return downloadsTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath)as?TitleTableViewCell else { return UITableViewCell() }
        
        let titleName = downloadsTitles[indexPath.row]
        
        cell.configureCell(with: TitleViewModel(posterURL: titleName.poster_path ?? "", originalName: titleName.original_name ?? titleName.original_title ?? ""))
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            DataPersistanceManager.shared.deleteTitleWith(model: downloadsTitles[indexPath.row]) { [weak self] result in
                switch result {
                case .success(let success):
                    print("Deleted from database")
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
                self?.downloadsTitles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }

        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = downloadsTitles[indexPath.row]
        
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
