//
//  LoggedInRouter.swift
//  TicTacToe
//
//  Created by Tran Duc on 3/29/19.
//  Copyright © 2019 Uber. All rights reserved.
//

import RIBs

protocol LoggedInInteractable: Interactable, OffGameListener, TicTacToeListener {
    var router: LoggedInRouting? { get set }
    var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
    func present(viewController: ViewControllable)
    func dismiss(viewController: ViewControllable)
}

final class LoggedInRouter: Router<LoggedInInteractable>, LoggedInRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: LoggedInInteractable, viewController: LoggedInViewControllable, offGameBuilder: OffGameBuildable, gameBuilder: TicTacToeBuildable) {
        self.viewController = viewController
        self.offGameBuilder = offGameBuilder
        self.gameBuilder = gameBuilder
        super.init(interactor: interactor)
        interactor.router = self
    }

    // MARK: - LoggedInInteractable
    func cleanupViews() {
        if let currentChild = currentChild {
            viewController.dismiss(viewController: currentChild.viewControllable)
        }
    }
    
    func routeToTicTacToe() {
        detachCurrentChild()
        attachTicTacToe()
    }
    
    func routeToOffGame() {
        detachCurrentChild()
        attachOffGame()
    }
    
    override func didLoad() {
        super.didLoad()
        attachOffGame()
    }
    
    

    // MARK: - Private

    private let viewController: LoggedInViewControllable
    private let offGameBuilder: OffGameBuildable
    private let gameBuilder: TicTacToeBuildable
    private var currentChild: ViewableRouting?
    
    
    private func attachOffGame() {
        let offGame = offGameBuilder.build(withListener: interactor)
        self.currentChild = offGame
        attachChild(offGame)
        viewController.present(viewController: offGame.viewControllable)
    }
    
    private func attachTicTacToe() {
        let ticTacToe = gameBuilder.build(withListener: interactor)
        self.currentChild = ticTacToe
        attachChild(ticTacToe)
        viewController.present(viewController: ticTacToe.viewControllable)
    }
    
    private func detachCurrentChild() {
        if let currentChild = currentChild {
            detachChild(currentChild)
            viewController.dismiss(viewController: currentChild.viewControllable)
            self.currentChild = nil
        }
    }
}
