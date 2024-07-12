//
//  ViewController.swift
//  Koanba-Movie
//
//  Created by Yanandra Dhafa on 09/07/24.
//

import UIKit
import Combine

class HomeViewController: UIViewController {

    let movieResultsTable = UITableView()
    let searchController = UISearchController()
    var viewModel = MoviesViewModel()
    let refreshControl = UIRefreshControl()
    private var cancellables = Set<AnyCancellable>()
    var query = ""
    var page = 1
    var searchDebounceTimer: Timer?
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBarAppearance()
        view.backgroundColor = .systemBackground
        self.title = "Movie Koanba"
        view.addSubview(movieResultsTable)
        setupSearchController()
        setupMovieResultsTable()
        fetchData()
        bindViewModel()
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        movieResultsTable.refreshControl = refreshControl
        movieResultsTable.separatorStyle = .none
        
    }
    
    @objc func refreshData(_ sender: UIRefreshControl) {
        self.page = 1
        viewModel.movies.removeAll()
        fetchData()
        
        
    }
    func setupNavigationBarAppearance() {
         let appearance = UINavigationBarAppearance()
         appearance.configureWithOpaqueBackground()
         appearance.backgroundColor = .systemBackground
         appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
         appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
         
         navigationController?.navigationBar.standardAppearance = appearance
         navigationController?.navigationBar.scrollEdgeAppearance = appearance
         navigationController?.navigationBar.compactAppearance = appearance
         navigationController?.navigationBar.tintColor = .black
        
     }
    func setupSearchController() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = false
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movie"
        searchController.searchBar.sizeToFit()
    }
    
    func setupMovieResultsTable() {
        movieResultsTable.dataSource = self
        movieResultsTable.delegate = self
        movieResultsTable.register(CustomTableViewCell.self, forCellReuseIdentifier: CustomTableViewCell.ID)
        movieResultsTable.rowHeight = 120
        movieResultsTable.allowsSelection = true
        movieResultsTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            movieResultsTable.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            movieResultsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            movieResultsTable.leftAnchor.constraint(equalTo: view.leftAnchor),
            movieResultsTable.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func fetchData() {
        if query == "" {
            viewModel.fetchMovies(query: "a",page: page)
        }else{
            viewModel.fetchMovies(query: self.query,page: page)
        }
      }
    
    func bindViewModel() {
        
            viewModel.$movies
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.movieResultsTable.reloadData()
                }
                .store(in: &cancellables)
            
            viewModel.$isLoading
                .receive(on: DispatchQueue.main)
                .sink { [weak self] isLoading in
                    print(isLoading)
                    if isLoading {
                        self?.loadingIndicator.startAnimating()
                    } else {
                        self?.loadingIndicator.stopAnimating()
                        self?.refreshControl.endRefreshing()
                    }
                }
                .store(in: &cancellables)
            
            viewModel.$errorMessage
                .receive(on: DispatchQueue.main)
                .sink { [weak self] errorMessage in
                    if let errorMessage = errorMessage {
                             self?.showErrorAlert(message:errorMessage)
                             self?.viewModel.errorMessage = nil
                             self?.viewModel.isFetchingMore = false
                         }
                }
                .store(in: &cancellables)
        
    }
    func showErrorAlert(message: String) {
         let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         present(alertController, animated: true, completion: nil)
     }
}

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
            searchDebounceTimer?.invalidate()
            searchDebounceTimer = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false) { [weak self] _ in
                guard let self = self else { return }
                if let searchQuery = searchController.searchBar.text {
                    if isConnectedToInternet() {
                        self.query = searchQuery
                        self.page = 1
                        self.viewModel.movies.removeAll()
                        self.fetchData()
                    }else {
                        if searchQuery == "" {
                            self.viewModel.searchMoviesLocally(query: "a")
                        }else{
                            self.viewModel.searchMoviesLocally(query: searchQuery)
                        }
                        
                    }
                                    
                }
            }
        }
    
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieResultsTable.dequeueReusableCell(withIdentifier: CustomTableViewCell.ID) as! CustomTableViewCell
        let movie = viewModel.movies[indexPath.row]
           cell.set(movie: movie)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.movies.count - 1 && !viewModel.isFetchingMore && !viewModel.hasError  {
                  self.page += 1
                   fetchData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isConnectedToInternet() {
            navigationController?.pushViewController(DetailsViewController(movieId: viewModel.movies[indexPath.row].id), animated: true)
        }else {
            self.showErrorAlert(message: "Please check your internet connection")
        }
        
    }
}
