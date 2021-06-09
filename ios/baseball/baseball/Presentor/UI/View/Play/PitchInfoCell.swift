//
//  PitchInfoCell.swift
//  baseball
//
//  Created by zombietux on 2021/05/09.
//

import UIKit
import RxSwift

class PitchInfoCell: UICollectionViewCell {
    static let reuseIdentifier = "PitchInfoCell"
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var pitchOrderView: PitchOrderView!
    @IBOutlet weak var sboLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    func configureCell(order: Int, pitchInfo: Bool) {
        pitchOrderView.pitchOrderLabel.text = "\(order+1)"
        sboLabel.text = makeSBString(sb: pitchInfo)
        countLabel.text = "1-3" //변경
    }
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    private func makeSBString(sb: Bool) -> String {
        return sb ? "스트라이크" : "볼"
    }
}
