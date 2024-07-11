//
//  CustomTableViewCell.swift
//  Koanba-Movie
//
//  Created by Yanandra Dhafa on 10/07/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
   
    static let ID = "CustomTableViewCell"
    var titleLabel = UILabel()
    var yearLabel = UILabel()
    var posterView = UIImageView()
    var genreLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addAllSubviews()
        setupPosterView()
        setupTitleLabel()
        setupYearLabel()
        setupGenreLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(movie: Movie) {
        titleLabel.text = movie.title
        if let year = getYearFromDate(dateString: movie.releaseDate) {
            yearLabel.text = year
        } else {
            yearLabel.text = "-"
           
        }
        genreLabel.text = movie.genreNames.joined(separator: ", ")
        if let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + movie.posterPath) {
            posterView.load(url: posterURL) 
        }else{
            posterView.image = UIImage(named: "placeholder")
        }
      
    }
    
    func addAllSubviews() {
        self.addSubview(posterView)
        self.addSubview(titleLabel)
        self.addSubview(yearLabel)
        self.addSubview(genreLabel)
    }
    
    func setupPosterView() {
        posterView.image = UIImage(named: "placeholder")
        posterView.translatesAutoresizingMaskIntoConstraints = false
        posterView.contentMode = .scaleAspectFill
        posterView.clipsToBounds = true
        posterView.backgroundColor = .secondaryLabel
        posterView.layer.borderWidth = 1
        posterView.layer.cornerRadius = 8
        posterView.layer.borderColor = UIColor.secondaryLabel.cgColor
        NSLayoutConstraint.activate([
            posterView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            posterView.centerYAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.centerYAnchor),
            posterView.heightAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.heightAnchor),
            posterView.widthAnchor.constraint(equalTo: posterView.heightAnchor, multiplier: 1)
        ])
    }
    
    func setupTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.sizeToFit()
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: posterView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: yearLabel.topAnchor)
        ])
    }
    
    
    
    func setupYearLabel() {
        yearLabel.translatesAutoresizingMaskIntoConstraints = false
        yearLabel.textColor = .secondaryLabel
        yearLabel.font = UIFont.systemFont(ofSize: 15)
        yearLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            yearLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            yearLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            yearLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            yearLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    func setupGenreLabel(){
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        genreLabel.textColor = .secondaryLabel
        genreLabel.numberOfLines = 0
        genreLabel.font = UIFont.systemFont(ofSize: 12)
        NSLayoutConstraint.activate([
            genreLabel.leadingAnchor.constraint(equalTo: self.yearLabel.leadingAnchor),
            genreLabel.trailingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.trailingAnchor),
            genreLabel.bottomAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
}
