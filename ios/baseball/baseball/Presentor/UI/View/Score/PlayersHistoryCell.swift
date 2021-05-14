//
//  PlayersHistoryCell.swift
//  baseball
//
//  Created by zombietux on 2021/05/10.
//

import UIKit
import RxSwift

class PlayersHistoryCell: UICollectionViewCell {
    static let reuseIdentifier = "PlayersHistoryCell"
    
    private var disposeBag = DisposeBag()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var plateAppearancesLabel: UILabel!
    @IBOutlet weak var hitLabel: UILabel!
    @IBOutlet weak var outLabel: UILabel!
    @IBOutlet weak var avgLabel: UILabel!
    
    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }
    
    func configureCell(batter: Batter) {
        nameLabel.text = batter.name
        plateAppearancesLabel.text = "\(batter.plateAppearances)"
        hitLabel.text = "\(batter.hit)"
        outLabel.text = "\(batter.out)"
        avgLabel.text = "\(batter.average)"
    }
}
