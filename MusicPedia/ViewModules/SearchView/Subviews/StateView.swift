//
//  SearchViewModel.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import Foundation
import UIKit

protocol StateSubviewProtocol {
    func show()
    func hide()
}

enum ViewState {
    case loading
    case start
    case empty
    case error(APIError)
    case errorWithContent(APIError)
    case none
}

class StateView: UIView {    
    private var didSetupViews: Bool = false
    
    let loadingView = LoadingView()
    let emptyView = EmptyView()
    let startView = StartView()
    let errorView = ErrorView()
    
    var allViews: [StateSubviewProtocol] {
        return [loadingView, emptyView, startView, errorView]
    }
    
    var state: ViewState = .none {
        didSet {
            updateState(state)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setupViews()
    }
    
    func updateState(_ state: ViewState) {
        DispatchQueue.main.async {
            self.allViews.forEach { $0.hide() }
            switch state {
            case .loading:
                self.loadingView.show()
            case .start:
                self.startView.show()
            case .empty:
                self.emptyView.show()
            case .error(let error):
                self.errorView.errorMessage = error.errorDescription
                self.errorView.show()
            case .errorWithContent(let error):
                ToastView.show(error.errorDescription)
            case .none:
                break
            }
        }
    }
    
    private func setupViews() {
        if !didSetupViews {
            self.didSetupViews = true
            self.setupConstraints()
        }
    }
    
    private func setupConstraints() {
        self.addSubview(self.loadingView)
        self.loadingView.pinEdgesToSuperview()
        
        self.addSubview(self.emptyView)
        self.emptyView.pinEdgesToSuperview()
        
        self.addSubview(self.startView)
        self.startView.pinEdgesToSuperview()
        
        self.addSubview(self.errorView)
        self.errorView.pinEdgesToSuperview()
    }
}
