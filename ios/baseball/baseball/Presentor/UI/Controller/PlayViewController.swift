//
//  PlayViewController.swift
//  baseball
//
//  Created by zombietux on 2021/05/07.
//

import UIKit
import RxSwift
import RxCocoa

class PlayViewController: UIViewController {

    @IBOutlet weak var scoreView: ScoreView!
    @IBOutlet weak var matchBoardView: MatchBoardView!
    @IBOutlet weak var matchUpView: MatchUpView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pitchButton: PitchButton!
    
    private var matchId: String!
    private var viewModel: PlayViewModel!
    private let updateMatchUpDataQueue = DispatchQueue(label: "matchUpDataQueue")
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PlayViewModel(id: matchId)
        setupBindings()
    }
    
    func initId(_ id: String) {
        self.matchId = id
    }
    
    private func setupBindings() {
        configureCollectionView()
        configureScoreView()
        configureInnginInfoLabel()
        configureMatchUpInfoView()
        configureSBOBoardView()
        configureIsOffenseView()
        configureGroundBasesView()
    }
    
    private func configureCollectionView() {
        viewModel.pitchInfo
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: PitchInfoCell.reuseIdentifier, cellType: PitchInfoCell.self)) { index, item, cell in
                cell.configureCell(order: index, pitchInfo: item)
            }
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
    
    private func configureInnginInfoLabel() {
        self.viewModel.inningInfo
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.matchBoardView.configureInningInfo(inningInfo: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureMatchUpInfoView() {
        self.viewModel.pitcher
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.matchUpView.configurePitcherMatchUpView($0)
            })
            .disposed(by: disposeBag)
        
        self.viewModel.batter
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.matchUpView.configureBatterMatchUpView($0)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureSBOBoardView() {
        self.viewModel.sbo
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.matchBoardView.configureSBOBoardView(sbo: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureIsOffenseView() {
        self.viewModel.isOffense
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.pitchButton.configureIsUserOffnese(isOffense: $0)
                if $0 { self.requestPitchingWhileOffense() }
            })
            .disposed(by: disposeBag)
        
        self.viewModel.isOffense
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.matchUpView.configureMatchUpCheckbox(isOffense: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureGroundBasesView() {
        self.viewModel.bases
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                self.matchBoardView.groundView.configureBaseView(bases: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func requestPitch() {
        self.viewModel.requestPitch(id: self.matchId)
    }
    
    private func requestPitchingWhileOffense() {
        self.updateMatchUpDataQueue.asyncAfter(deadline: .now() + 3) {
            self.requestPitch()
        }
    }
    
    @IBAction func pitchButtonTapped(_ sender: Any) {
        requestPitch()
    }
}
