//
//  GroundView.swift
//  baseball
//
//  Created by zombietux on 2021/05/06.
//

import UIKit

final class GroundView: UIView {
    @IBOutlet weak var firstBaseView: RoundedView!
    @IBOutlet weak var secondBaseView: RoundedView!
    @IBOutlet weak var thirdBaseView: RoundedView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        if let view = Bundle.main.loadNibNamed("GroundView", owner: self, options: nil)?.first as? UIView {
            view.frame = self.bounds
            self.addSubview(view)
        }
    }
    
    func configureBaseView(bases: [Bool]) {
        guard bases.count != 0 else { return }
        
        if bases[0] == true {
            firstBaseView.backgroundColor = .systemYellow
        } else {
            firstBaseView.backgroundColor = .systemBackground
        }
        
        if bases[1] == true {
            secondBaseView.backgroundColor = .systemYellow
        } else {
            secondBaseView.backgroundColor = .systemBackground
        }
        
        if bases[2] == true {
            thirdBaseView.backgroundColor = .systemYellow
        } else {
            thirdBaseView.backgroundColor = .systemBackground
        }
    }
}
