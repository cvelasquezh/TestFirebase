//
//  INTButton.swift
//  ExamenIntercorp
//
//  Created by MDP on 7/9/19.
//  Copyright © 2019 cesarcompany. All rights reserved.
//

import UIKit

class INTButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    private func setupButton() {
        backgroundColor     = UIColor.INTorange()
        titleLabel?.font    = UIFont.regularINTFont(ofSize: 22)
        layer.cornerRadius  = 10
        clipsToBounds       = true
        setTitleColor(.white, for: .normal)
    }

}
