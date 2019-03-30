//
//  LaunchGameWorkflow.swift
//  TicTacToe
//
//  Created by Tran Duc on 3/30/19.
//  Copyright © 2019 Uber. All rights reserved.
//

import Foundation
import RIBs
import RxSwift

public class LaunchGameWorkflow: Workflow<RootActionableItem> {
    public init(url: URL) {
        super.init()
        let gameId = parseGameId(from: url)
        self
            .onStep { (rootItem: RootActionableItem) -> Observable<(LoggedInActionableItem, ())> in
                rootItem.waitForLogin()
            }
            .onStep { (loggedInActionableItem: LoggedInActionableItem, _)
                -> Observable<(LoggedInActionableItem, ())> in
                loggedInActionableItem.launchGame(with: gameId)
            }
            .commit()

    }

    private func parseGameId(from url: URL) -> String? {
        let components = URLComponents(string: url.absoluteString)
        let items = components?.queryItems ?? []
        for item in items where item.name == "gameId" {
            return item.value
        }
        return nil
    }
}
