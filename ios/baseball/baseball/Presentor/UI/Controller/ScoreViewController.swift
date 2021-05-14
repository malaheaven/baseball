//
//  ScoreViewController.swift
//  baseball
//
//  Created by zombietux on 2021/05/07.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scoreView: ScoreView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var homeScoreStack: TeamInningScoreStack!
    @IBOutlet weak var awayScoreStack: TeamInningScoreStack!
    
    private var matchId: String!
    private var viewModel: ScoreViewModel!
    private var disposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.dataSource = nil
        viewModel = ScoreViewModel(id: matchId)
        
        configureScoreView()
        configureInningsScoreView()
        configureSegmentedControlTitle()
        configureHomeBattersView()
    }
    
    func initId(_ id: String) {
        self.matchId = id
    }
    
    private func configureHomeBattersView() {
        viewModel.homeBatters
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: PlayersHistoryCell.reuseIdentifier, cellType: PlayersHistoryCell.self)) { index, item, cell in
                cell.configureCell(batter: item)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureAwayBattersView() {
        viewModel.awayBatters
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: PlayersHistoryCell.reuseIdentifier, cellType: PlayersHistoryCell.self)) { index, item, cell in
                cell.configureCell(batter: item)
            }
            .disposed(by: disposeBag)
    }

    
    private func configureInningsScoreView() {
        self.viewModel.inningsScore
            .observe(on: MainScheduler.instance)
            .debug()
            .subscribe(onNext: {
                self.homeScoreStack.addInningViewLabels(inningsScore: $0.home)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.inningsScore
            .observe(on: MainScheduler.instance)
            .debug()
            .subscribe(onNext: {
                self.awayScoreStack.addInningViewLabels(inningsScore: $0.away)
            })
            .disposed(by: disposeBag)
    }
    
    
    private func configureScoreView() {
        self.viewModel.scores
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.scoreView.configureScore(scoreInfo: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureSegmentedControlTitle() {
        self.viewModel.scores
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.segmentedControl.setTitle($0.homeName, forSegmentAt: 0)
                self.segmentedControl.setTitle($0.awayName, forSegmentAt: 1)
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func segmentedControlPressed(_ sender: Any) {
        segmentedControl.rx.selectedSegmentIndex.subscribe(onNext: { [weak self] index in
            if index == 0 {
                self?.collectionView.dataSource = nil
                self?.configureHomeBattersView()
            } else {
                self?.collectionView.dataSource = nil
                self?.configureAwayBattersView()
            }
        })
    }
}
