//
//  CastCollectionViewCell.swift
//  Koanba-Movie
//
//  Created by Yanandra Dhafa on 10/07/24.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    static let identifier = "CastCollectionViewCell"
    
    private let personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.size.width / 2 // Frame bulat
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        
    }
    override func draw(_ rect: CGRect) {
             super.draw(rect)
            personImageView.layer.cornerRadius = personImageView.frame.size.width / 2
         }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(personImageView)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            personImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            personImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            personImageView.widthAnchor.constraint(equalToConstant: 80), // Adjust as needed
            personImageView.heightAnchor.constraint(equalToConstant: 80), // Adjust as needed
            
            nameLabel.topAnchor.constraint(equalTo: personImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
  
    func set(cast: Cast) {
        nameLabel.text = cast.name
        print("obet cast")
        print(cast)
       
        if let posterURL = URL(string: "https://image.tmdb.org/t/p/w500" + cast.profilePath) {
            personImageView.load(url: posterURL) 
        }else{
            personImageView.image = UIImage(named: "placeholder")
        }
      
    }
}



