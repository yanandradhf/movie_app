//
//  customImageView.swift
//  Koanba-Movie
//
//  Created by Yanandra Dhafa on 10/07/24.
//

import UIKit

class CustomImageView: UIImageView {
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let durationLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    private let qualityLabel: UILabel = {
        let label = UILabel()
        label.text = " HD "
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.borderWidth = 2
        label.layer.borderColor = UIColor.white.cgColor
        label.layer.cornerRadius = 3
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        
        
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.sizeToFit()
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalCentering
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        self.addSubview(genreLabel)
        stackView.addArrangedSubview(durationLabel)
        stackView.addArrangedSubview(qualityLabel)
        self.addSubview(stackView)
        self.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            genreLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            genreLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: genreLabel.topAnchor, constant: -4),
            
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            titleLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -8),
        ])
    }
    
    func configureLabels(genreLabels: String?, durationLabels: String?, titleLabels: String?) {
        genreLabel.text = genreLabels
        durationLabel.text = durationLabels
        titleLabel.text = titleLabels
    }
}
