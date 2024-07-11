//
//  Extension.swift
//  Koanba-Movie
//
//  Created by Yanandra Dhafa on 11/07/24.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}

func getYearFromDate(dateString: String) -> String? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = dateFormatter.date(from: dateString) {
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    return nil
}

func getDurationString(from minutes: Int) -> String {
    let hours = minutes / 60
    let mins = minutes % 60
    
    if hours > 0 {
        if mins > 0 {
            return "\(hours)h \(mins)min"
        } else {
            return "\(hours)h"
        }
    } else {
        return "\(mins)min"
    }
}
