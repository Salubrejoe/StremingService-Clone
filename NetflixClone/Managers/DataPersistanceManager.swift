//
//  DataPersistanceManager.swift
//  NetflixClone
//
//  Created by Lore P on 17/02/2023.
//

import Foundation
import UIKit
import CoreData

class DataPersistanceManager {
    static let shared = DataPersistanceManager()
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
        case failedToDeleteData
    }
    
    
    func downloadTitle(with viewModel: Title, completion: @escaping (Result<Void,Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        // Now instanciate a TtitleItem under appdelegate supervision
        let item = TitleItem(context: context)
        
        item.original_title          = viewModel.original_title
        item.id                     = Int64(viewModel.id)
        item.original_name          = viewModel.original_name
        item.overview               = viewModel.overview
        item.media_type             = viewModel.media_type
        item.vote_count             = Int64(viewModel.vote_count)
        item.vote_average           = viewModel.vote_average
        item.release_date           = viewModel.release_date
        item.poster_path            = viewModel.poster_path
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    
    func fetchDownloadedTitlesFromDatabase(completion: @escaping (Result<[TitleItem], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // ContextManager is allowed to access database
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TitleItem>
        
        request = TitleItem.fetchRequest()
        
        
        do {
            
            let titles = try context.fetch(request)
            completion(.success(titles))
            
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    
    func deleteTitleWith(model: TitleItem, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        
        do {
            try context.save()
            completion(.success(()))
            
        } catch {
            completion(.failure(DatabaseError.failedToDeleteData))
        }
    }
}
