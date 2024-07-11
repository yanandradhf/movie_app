//
//  DetailsViewController.swift
//  Koanba-Movie
//
//  Created by Yanandra Dhafa on 10/07/24.
//

import UIKit
import Combine


class DetailsViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var people: [(image: UIImage?, name: String)] = []
    var movieId = 0
    let customImageView = CustomImageView(frame: .zero)
    let viewModel = MovieDetailViewModel()
    private var cancellables = Set<AnyCancellable>()
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    let titleCollection: UILabel = {
        let label = UILabel()
        label.text = "Cast"
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.textAlignment = .justified
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    init(movieId: Int) {
        self.movieId = movieId
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        viewModel.fetchMovieDetail(movieId: movieId)
        viewModel.fetchMovieCast(movieId: movieId)
        bindViewModel()
    
    }
    
    func processData(data : MovieDetail){
        let genresString = data.genres.map { $0.name }.joined(separator: ", ")
        customImageView.configureLabels(genreLabels: genresString, durationLabels:  getDurationString(from: data.runtime ?? 0), titleLabels: data.title)
        if let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + (data.posterPath ?? "")) {
            customImageView.load(url: posterURL)
        }else{
            customImageView.image = UIImage(named: "placeholder")
        }
        descriptionLabel.text = data.overview
    }
    func configureView() {
        view.addSubview(customImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(titleCollection)
        view.backgroundColor = .systemBackground
        customImageView.translatesAutoresizingMaskIntoConstraints = false
        customImageView.contentMode = .scaleAspectFill
        customImageView.clipsToBounds = true
        customImageView.image = UIImage(named: "placeholder")
        setupCollectionView()
        NSLayoutConstraint.activate([
                   customImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   customImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   customImageView.topAnchor.constraint(equalTo: view.topAnchor),
                   customImageView.heightAnchor.constraint(equalToConstant: 400),
                   
                   descriptionLabel.topAnchor.constraint(equalTo: customImageView.bottomAnchor, constant: 30),
                   descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
                   descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
                   
                   collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                   collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                   collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                   collectionView.heightAnchor.constraint(equalToConstant: 140),
                   
                   titleCollection.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -5),
                   titleCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                   titleCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
               ])
    }
    
    func bindViewModel() {
        
            viewModel.$movieDetail
                .receive(on: DispatchQueue.main)
                .sink { [weak self] data in
                    if data != nil {
                        self?.processData(data: data!)
                    }
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
                      
                    }
                }
                .store(in: &cancellables)
            
            viewModel.$errorMessage
                .receive(on: DispatchQueue.main)
                .sink { [weak self] errorMessage in
                    if let errorMessage = errorMessage {
                             self?.showErrorAlert(message: errorMessage)
                             self?.viewModel.errorMessage = nil
                         }
                }
                .store(in: &cancellables)
        
        viewModel.$cast
             .receive(on: DispatchQueue.main)
             .sink { [weak self] data in
                 self?.collectionView.reloadData()
             }
             .store(in: &cancellables)
             
        
    }
    func showErrorAlert(message: String) {
         let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in 
            self.navigationController?.popViewController(animated: true)
        }))
         present(alertController, animated: true, completion: nil)
     }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 140)
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.dataSource = self
        collectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        
        view.addSubview(collectionView)
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension DetailsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.identifier, for: indexPath) as? CastCollectionViewCell else {
            fatalError("Failed to dequeue CastCollectionViewCell")
        }
        let cast = viewModel.cast[indexPath.item]
        cell.set(cast: cast)
        
        return cell
    }
}
