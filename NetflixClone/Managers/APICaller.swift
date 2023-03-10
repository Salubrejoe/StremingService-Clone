//
//  APICaller.swift
//  NetflixClone
//
//  Created by Lore P on 11/02/2023.
//

import Foundation


struct Constant {
    static let API_KEY = "2315a7d577655cb705a28ac4a707743f"
    static let baseURL = "https://api.themoviedb.org"
    static let youTubeAPI_KEY = "AIzaSyC_4zSCto8LURdYpG1hQ0UL0EOCYRgv9kY"
    static let youTubeBaseURL = "https://youtube.googleapis.com/youtube/v3/search?"
}


enum APIError: Error {
    case failedToGetData
}

class APICaller {
    
    
    static let shared = APICaller()
    
    
    // The function works if we do (String) -> Void
    // Result<Success, Failure>
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constant.baseURL)/3/trending/movie/day?api_key=\(Constant.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _ , error in
            
            guard let data = data,
                    error == nil  else { return }
            
            do {
                // Next line fetches the Object
                //let results = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                //print(results)
                
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(response.results))
                
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func getTrendingTV(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constant.baseURL)/3/trending/tv/day?api_key=\(Constant.API_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _ , error in
            
            // Check for data - error
            guard let data = data,
                  error == nil else { return }
            
            
            // Do-Catch JsonDecoder -> ClassResponse
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(response.results))
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        // Resume
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/upcoming?api_key=\(Constant.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data,
                  error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(response.results))
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/popular?api_key=\(Constant.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data,
                  error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(response.results))
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func getTopRated(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        
        guard let url = URL(string: "\(Constant.baseURL)/3/movie/top_rated?api_key=\(Constant.API_KEY)&language=en-US&page=1") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data,
                  error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(response.results))
                
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func getDiscoverMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        
        guard let url = URL(string: "\(Constant.baseURL)/3/discover/movie?api_key=\(Constant.API_KEY)&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page=1&with_watch_monetization_types=flatrate") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data,
                  error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    
    func search(with query: String, completion: @escaping (Result<[Title], Error>) -> Void) {
        
        // Create a query with magic
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        
        guard let url = URL(string: "\(Constant.baseURL)/3/search/movie?api_key=\(Constant.API_KEY)&query=\(query)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data,
                  error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(Response.self, from: data)
                completion(.success(response.results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }
    
    func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void)  {
        
        // Create a query <=> %20
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
        
        
        guard let url = URL(string: "\(Constant.youTubeBaseURL)q=\(query)&key=\(Constant.youTubeAPI_KEY)") else { return }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            
            guard let data = data,
                  error == nil else { return }
            
            do {
                let response = try JSONDecoder().decode(YouTubeSearchResponse.self, from: data)
                completion(.success(response.items[0]))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
            
        }
        
        task.resume()
    }
}

 

