//
//  QuestionView.swift
//  OpenQuizz
//
//  Created by Elfo on 18/11/2024.
//

import UIKit

class QuestionView: UIView {
    
    enum Style {
        case correct
        case incorrect
        case standard
    }
    
    @IBOutlet private var label: UILabel!
    @IBOutlet private var icon: UIImageView!
    
    var title = "" {
        didSet {
            label.text = title
        }
    }
    var style = Style.standard {
        didSet {
            setStyle(style)
        }
    }
    
    private func setStyle(_ style: Style) {
        switch style {
        case .correct:
            backgroundColor = UIColor(
                red: 200/255.0,
                green: 236/255.0,
                blue: 160/255.0,
                alpha: 1
            )
            icon.image = UIImage(named: "Icon Correct")
            icon.isHidden = false
        case .incorrect:
            // Use #colorLiteral(
            backgroundColor = #colorLiteral(red: 0.9512742162, green: 0.533290863, blue: 0.5813510418, alpha: 1)
            // Use #imageLiteral(
            icon.image = #imageLiteral(resourceName: "Icon Error")
            icon.isHidden = false
        case .standard:
            backgroundColor = #colorLiteral(red: 0.7473273873, green: 0.7669225335, blue: 0.7826006413, alpha: 1)
            icon.isHidden = true
        }
    }
}
