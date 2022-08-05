//
//  MainViewController.swift
//  MovieReview
//
//  Created by Asaf Chen on 24/06/2022.
//

import UIKit
import SafariServices

class MainViewController: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var table: UITableView!
    @IBOutlet var field: UITextField!
    
    var  movies = [Movie]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 //       table.register(MovieTableViewCell.nib(), forCellReuseIdentifier: MovieTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        field.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchMovies()
        return true
    }
    
    func searchMovies() {
        field.resignFirstResponder()
        
        guard let text = field.text, !text.isEmpty else {
            return
        }
        
        movies.removeAll()
        
        URLSession.shared.dataTask(with: URL(string: "https://api.jsonbin.io/b/62b960e3402a5b38023c8cd3")!,
                                   completionHandler: { data, response, error in
                                   
                                    guard let data = data, error == nil else {
                                        return
                                    }
            var result: MovieResult?
            do {
                result = try JSONDecoder().decode(MovieResult.self, from: data)
            }
            catch {
                print("error")
            }
            
            guard let finalResult = result else {
                return
            }
            
         //   print("\(finalResult.Search.first?.Title)")
            
            let newMovies = finalResult.Search
            self.movies.append(contentsOf: newMovies)
            
            DispatchQueue.main.async {
                self.table.reloadData()
                print(self.movies)
            }
            
        }).resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell = self.table.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        cell.setUpView(with: self.movies[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Show movie details
        let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)/"
        let vc = SFSafariViewController(url: URL(string: url)!)
        present(vc, animated: true)
    }


}

struct MovieResult: Codable {
    let Search: [Movie]
}

struct Movie: Codable {
    let Title: String
    let Year: String
    let imdbID: String
    let _Type: String
    let Poster: String
    
    private enum CodingKeys:  String, CodingKey {
        case Title, Year, imdbID, _Type = "Type", Poster
    }
}
