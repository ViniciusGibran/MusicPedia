//
//  RootNavigationController.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 31/10/2020.
//

import UIKit

class RootNavigationController: UINavigationController {

    let coordinator: AppCoordinator
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showAlbumsGridView() {
        coordinator.showAlbumsGridView()
    }
    
}
