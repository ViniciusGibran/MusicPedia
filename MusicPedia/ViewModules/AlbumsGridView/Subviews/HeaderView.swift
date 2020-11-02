//
//  HeaderView.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit
import Combine

protocol HeaderViewDelegate: class {
    func shouldShowSearchView(_ show: Bool)
    func didSubmitSearch(_ search: String)
}

class HeaderView: UIView {
    
    // MARK: Properties
    let maxHeight: CGFloat = 130
    let minHeight: CGFloat = 85
    
    var heightConstraint: NSLayoutConstraint!
    var search: String = ""
    
    weak var delegate: HeaderViewDelegate?
    
    // dispose combines
    private var cancelBag = Set<AnyCancellable>()
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 30, height: self.maxHeight)
    }
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 26)
        label.text = "MusicPedia"
        label.textColor = .white
        label.alpha = 0
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.transform = CGAffineTransform.init(scaleX: 0.8, y: 0.8)
        indicator.color = .white
        indicator.alpha = 0.6
        indicator.startAnimating()
        indicator.isHidden = true
        return indicator
    }()
    
    private let searchTextField: UITextField = {
       let textField = UITextField()
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        textField.layer.cornerRadius = 6.0
        textField.textColor = .white
        textField.tintColor = .white
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.clearsOnBeginEditing = true
        textField.accessibilityIdentifier = "search_input"
        return textField
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.setImage(UIImage(named: "search"), for: .normal)
        button.accessibilityIdentifier = "search_button"
        return button
    }()
    
    private let blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.alpha = 0.9
        return view
    }()
    
    private let bottomLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.backgroundColor = .clear
        self.loadView()
        self.setupBinds()
    }
    
    private func loadView() {
        addSubview(blurView)
        blurView.pinEdgesToSuperview()
        
        addSubview(titleLabel)
        titleLabel.pinLeft(15.0)
        titleLabel.pinBottom(55.0)
        
        addSubview(searchTextField)
        searchTextField.pinLeft(15.0)
        searchTextField.pinRight(15.0)
        searchTextField.pinBottom(8.0)
        searchTextField.constraintHeight(36.0)
        
        addSubview(searchButton)
        searchButton.pinBottom(15.0)
        searchButton.pinRight(23.0)
        searchButton.constraintHeight(20.0)
        searchButton.constraintWidth(20.0)
        
        addSubview(activityIndicator)
        activityIndicator.pinRight(30.0)
        activityIndicator.pinBottom(55.0)
        
        addSubview(bottomLine)
        bottomLine.constraintHeight(1)
        bottomLine.pinRight()
        bottomLine.pinLeft()
        bottomLine.pinBottom()
        
        searchTextField.setPadding(14)
        
        heightConstraint = constraintHeight(minHeight)
        layoutIfNeeded()
    }
    
    private func setupBinds() {
        searchTextField.publisher
            .map { $0 }
            .sink(receiveValue: { text in
                self.search = text
            }).store(in: &cancelBag)
        
        let searchTap = searchButton.publisher.share()
        searchTap
        .sink(receiveValue: { _ in
            self.delegate?.didSubmitSearch(self.search)
        }).store(in: &cancelBag)
        
        searchTextField.delegate = self
    }
    
    func collapse() {
        self.heightConstraint.constant = self.minHeight
        UIView.animate(withDuration: 0.25, animations: {
            self.titleLabel.alpha = 0
            self.superview?.layoutIfNeeded()
            self.layoutIfNeeded()
        }, completion: nil)
    }
    
    func expand() {
        self.heightConstraint.constant = self.maxHeight
        UIView.animate(withDuration: 0.25, animations: {
            self.titleLabel.alpha = 1
            self.superview?.layoutIfNeeded()
            self.layoutIfNeeded()
        }, completion: nil )
    }
    
    func setActivityIndicator() {
        activityIndicator.isHidden = !activityIndicator.isHidden
    }
    
    func setTextFieldPlaceholder(_ placeholder: String) {
        searchTextField.text = placeholder
        searchTextField.placeholder = placeholder
    }
}

extension HeaderView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.shouldShowSearchView(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.didSubmitSearch(search)
        return true
    }
}
