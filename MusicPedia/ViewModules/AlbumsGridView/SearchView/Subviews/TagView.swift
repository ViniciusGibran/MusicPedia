//
//  SearchViewModel.swift
//  MusicPedia
//
//  Created by Vinicius Bornholdt on 01/11/2020.
//

import UIKit

protocol CloudTagViewDelegate: class {
    func didSelectTag(content: String)
}

class TagView: UIView {
    
    weak var delegate: CloudTagViewDelegate?
    
    var tagItems: [String] = [] {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var tagHeight: CGFloat = 36
    private var tagBackgroundColor: UIColor = UIColor.white.withAlphaComponent(0.4)
    private var textColor: UIColor = .white

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        self.translatesAutoresizingMaskIntoConstraints = false
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    var collectionView: UICollectionView! {
        didSet{
            collectionView.register(TagCell.self, forCellWithReuseIdentifier: NSStringFromClass(TagCell.self.self))
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.allowsSelection = true
            collectionView.backgroundColor = .clear
        }
    }
    
    private func setupViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        self.collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: layout)
        self.addSubview(self.collectionView)
        self.collectionView.pinEdgesToSuperview()
        
        self.backgroundColor = .clear
    }
    
}

extension TagView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = self.tagItems[indexPath.row]
        let width = item.width(usingFont: TagCell.font) + 16
        return CGSize(width: width, height: self.tagHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        cell.alpha = 0.0
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveLinear, animations: {
            cell.alpha = 1.0
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag = tagItems[indexPath.row]
        delegate?.didSelectTag(content: tag)
    }
}

extension TagView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let reuseIdentifier = NSStringFromClass(TagCell.classForCoder())
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! TagCell
        let item = tagItems[indexPath.row]
        cell.bind(item, backgroundColor: self.tagBackgroundColor, textColor: self.textColor)
        
        return cell
    }
}

