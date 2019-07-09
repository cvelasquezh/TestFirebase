//
//  INTTextField.swift
//  ExamenIntercorp
//
//  Created by MDP on 7/9/19.
//  Copyright © 2019 cesarcompany. All rights reserved.
//

import UIKit

class INTTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpField()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init( coder: aDecoder )
        setUpField()
    }
    
    
    private func setUpField() {
        tintColor             = .white
        textColor             = .darkGray
        font                  = UIFont.regularINTFont(ofSize: 18)
        backgroundColor       = UIColor(white: 1.0, alpha: 0.5)
        autocorrectionType    = .no
        layer.cornerRadius    = 10.0
        clipsToBounds         = true
        
        let placeholder       = self.placeholder != nil ? self.placeholder! : ""
        let placeholderFont   = UIFont.regularINTFont(ofSize: 18)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes:
            [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
             NSAttributedString.Key.font: placeholderFont])
        
        let indentView        = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        leftView              = indentView
        leftViewMode          = .always
    }

}
