//
//  ViewController.swift
//  baseball
//
//  Created by 이다훈 on 2021/05/04.
//

import UIKit
import RxSwift
import RxCocoa

class GameListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
  
    private var viewModel = MatchViewModel()
    private var disposeBag = DisposeBag()
    private let isEnterAllowCode = 200
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureTeamSelectAlert()
    }
    
    private func configureCollectionView() {
        viewModel.matchs
            .observe(on: MainScheduler.instance)
            .bind(to: collectionView.rx.items(cellIdentifier: MatchCell.reuseIdentifier, cellType: MatchCell.self)) { index, item, cell in
                cell.awayTeamLabel.text = item.away
                cell.homeTeamLabel.text = item.home
                cell.numberLabel.text = "GAME \(index+1)"
            }
            .disposed(by: disposeBag)
    }
    
    private func configureTeamSelectAlert() {
        collectionView.rx.modelSelected(Match.self).subscribe(onNext: { [weak self] item in
            self?.showAlert(title: "게임할 팀 선택", message: .none, style: .actionSheet,
                            actions: [TeamSelectAlertAction.action(title: item.away, style: .default),                     TeamSelectAlertAction.action(title: item.home, style: .default),
                                      TeamSelectAlertAction.action(title: "닫기", style: .cancel),
                            ]
             ).subscribe(onNext: { [weak self] action in
                self?.viewModel.enterGame(id: item.id, selectedTeam: action.title, completionHandler: { enterCode in
                    guard action.style != .cancel else { return }
                    
                    if enterCode == self?.isEnterAllowCode {
                        self?.showPlayTab(id: item.id)
                    } else {
                        self?.showAlertTeamNotSelectable()
                    }
                })
             })
        }).disposed(by: disposeBag)
    }
    
    private func showPlayTab(id: String) {
        guard let mainTabBarController = storyboard?.instantiateViewController(identifier: "MainTabBarController") else { return }
        mainTabBarController.modalPresentationStyle = .fullScreen
        guard let playViewController = mainTabBarController.children.first as? PlayViewController else { return }
        playViewController.initId(id)
        present(mainTabBarController, animated: true, completion: .none)
    }
    
    private func showAlert(title: String?, message: String?, style: UIAlertController.Style, actions: [TeamSelectAlertAction]) -> Observable<TeamSelectAlertAction> {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
            
            actions.enumerated().forEach { index, action in
                let action = UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(action)
                    observer.onCompleted()
                }
                alertController.addAction(action)
            }
            
            self.present(alertController, animated: true, completion: nil)
            
            return Disposables.create { alertController.dismiss(animated: true, completion: nil) }
        }
    }
    
    private func showAlertTeamNotSelectable() {
        let alertController = UIAlertController(title: "팀 선택 불가",
                                      message: "이미 다른 사용자가 게임을 진행중입니다.",
                                      preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "확인", style: .default))
        present(alertController, animated: true)
    }
}

