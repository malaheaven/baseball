//
//  RecodeHeaderView.swift
//  baseball
//
//  Created by zombietux on 2021/05/06.
//

import UIKit

class RecodeHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "RecodeHeaderView"
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var firstStatLabel: UILabel!
    @IBOutlet weak var secondStatLabel: UILabel!
    @IBOutlet weak var thirdStatLabel: UILabel!
    @IBOutlet weak var fourthStatLabel: UILabel!
    
    func configureUI(at sectionIndex: Int) {
        if sectionIndex == 0 {
            positionLabel.text = "타자"
            firstStatLabel.text = "타석"
            secondStatLabel.text = "안타"
            thirdStatLabel.text = "아웃"
            fourthStatLabel.text = "평균"
        } else {
            positionLabel.text = "투수"
            firstStatLabel.text = "투구수"
            secondStatLabel.text = "피안타"
            thirdStatLabel.text = "볼넷"
            fourthStatLabel.text = "이닝"
        }
    }
}
