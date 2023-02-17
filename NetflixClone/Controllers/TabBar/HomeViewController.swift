//
//  HomeViewController.swift
//  NetflixClone
//
//  Created by Lore P on 09/02/2023.
//  This product uses the TMDB API but is not endorsed or certified by TMDB.

import UIKit

// MARK: Sections enum
enum Sections: Int {
    case trendingMovies = 0
    case trendingTv = 1
    case popular = 2
    case upcoming = 3
    case topRated = 4
}


class HomeViewController: UIViewController {
    
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderView?
    
    private let spacing: UIView = {
       
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 210).isActive = true        
        return view
    }()
    
    // String for header titles
    let sectionTitles: [String] = [
        "Trending Movies",
        "Trending TV",
        "Popular",
        "Upcoming Movies",
        "Top rated"
    ]
    
    // MARK: TableView
    // Anonymous closure pattern to initialize TableView
    private let homeFeedTableView: UITableView = {
        
        let table                          = UITableView(frame: .zero, style: .grouped)
        table.showsVerticalScrollIndicator = false
        
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    
    
    // MARK: View did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTableView)

        homeFeedTableView.delegate   = self
        homeFeedTableView.dataSource = self
        
        configureNavigationBar()
        

        headerView                        = HeroHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 550))
        homeFeedTableView.tableHeaderView = headerView
        configureHeaderView()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        homeFeedTableView.frame = view.bounds
    }

    
    // MARK: Configure Header and Navigation Bar
    private func configureHeaderView() {
        
        APICaller.shared.getTrendingMovies { [weak self] result in
            
            switch result {
                
            case .success(let titles):
                
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(posterURL: selectedTitle?.poster_path ?? "", originalName: selectedTitle?.original_name ?? selectedTitle?.original_title ?? ""))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavigationBar() {
        
        var image = UIImage(named: "netflixLogo")
        image = image?.withRenderingMode(.alwaysOriginal)
        
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(image: image, style: .done, target: self, action: nil),
            UIBarButtonItem(customView: spacing)
        ]
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .red
    }
}



// MARK: Data Source and delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Unwrap and dequeue a reusable custom cell CollectionViewTableViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        // DELEGATE PROTOCOL
        cell.delegate = self
        
        // Switch between sections, for each section
        // configure cell.titles in case the result from APICaller.shared.getTrending is .success
        switch indexPath.section {
            
        case Sections.trendingMovies.rawValue:
            
            // Call the custom method (URLSession - do/catch - task.resume)
            APICaller.shared.getTrendingMovies { result in
                
                // SINCE: Result<Success, Failure>
                // Switch result between .success and .failure
                switch result {
                    
                case .success(let titles):
                    
                    // Configure titles (by setting self.titles and casting a spell)
                    cell.configureTitles(with: titles)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
        case Sections.trendingTv.rawValue:
            
            APICaller.shared.getTrendingTV { result in
                switch result {
                case .success(let titles):
                    cell.configureTitles(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
        case Sections.popular.rawValue:
            
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let titles):
                    cell.configureTitles(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
        case Sections.upcoming.rawValue:
            
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configureTitles(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
            
        case Sections.topRated.rawValue:
            
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let titles):
                    cell.configureTitles(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
            
        default:
            
            return UITableViewCell()
        }
        
        return cell
    }
    
    
    // MARK: Header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.textLabel?.text       = header.textLabel?.text?.capitalizeFirstLetter()
        header.textLabel?.font       = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor  = .white
        header.textLabel?.frame      = CGRect(
            x     : header.bounds.origin.x + 20,
            y     : header.bounds.origin.y,
            width : 100,
            height: header.bounds.height
        )
    }

    
    // MARK: Heights row/section
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // MARK: Scroll up makes NB disapper
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let defaultOffset = view.safeAreaInsets.top
        let offset        = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}


// MARK: DelegProt method definition
extension HomeViewController: CollectionViewTableViewCellDelegate {
    
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewModel) {
        
        DispatchQueue.main.async { [weak self] in
            
            let viewController = TitleTrailerViewController()
            
            viewController.configureController(with: viewModel)
            
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
}
