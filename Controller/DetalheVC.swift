//
//  DetalheVC.swift
//  AppTinder
//
//  Created by Gabriel Aragao on 19/04/22.
//

import UIKit

class HeaderLayout: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttibutes = super.layoutAttributesForElements(in: rect)
        
        layoutAttibutes?.forEach({ (attribute) in
            if attribute.representedElementKind == UICollectionView.elementKindSectionHeader {
            
                
                guard let collectionView = collectionView else {return}
                
                let contentOffSetY = collectionView.contentOffset.y
                
                attribute.frame = CGRect(x: 0, y: contentOffSetY, width: collectionView.bounds.width, height: attribute.bounds.height - contentOffSetY)
                
            }
        })
        
        return layoutAttibutes
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    
}


class DetalheVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var usuario: Usuario? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    
    let cellId = "cellId"
    let headerId = "headerId"
    let perfilId = "perfilId"
    let fotosId = "fotosId"
    
    var dislikeButton: UIButton = .iconFooter(named: "icone-deslike")
    var likeButton: UIButton = .iconFooter(named: "icone-like")
    
    var callback: ((Usuario?, Acao) -> Void)?
    
    var voltarButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "icone-down"), for: .normal)
        button.backgroundColor = UIColor(red: 232/255, green: 88/255, blue: 54/255, alpha: 1)
        button.clipsToBounds = true
        
        return button
        
    }()
    
    init() {
        super.init(collectionViewLayout: HeaderLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 134, right: 0)
        
        collectionView.backgroundColor = .white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.register(DetalheHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView.register(DetalhePerfilCell.self, forCellWithReuseIdentifier: perfilId)
        collectionView.register(DetalheFotosCell.self, forCellWithReuseIdentifier: fotosId)
        
        self.adicionarVoltar()
        self.adicionarFooter()
        
    }
    
    func adicionarVoltar () {
        view.addSubview(voltarButton)
        voltarButton.frame = CGRect(x: view.bounds.width - 69, y: view.bounds.height * 0.7, width: 48, height: 48)
        voltarButton.layer.cornerRadius = 24
        voltarButton.addTarget(self, action: #selector(voltarClique), for: .touchUpInside)
    
    }
    
    func adicionarFooter () {
        
        let stackView = UIStackView (arrangedSubviews: [UIView(), dislikeButton, likeButton, UIView()])
        stackView.distribution = .equalCentering
        
        view.addSubview(stackView)
        stackView.preencher(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, padding: .init(top: 0, left: 16, bottom: 34, right: 16))
        
        dislikeButton.addTarget(self, action: #selector(dislikeClique), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeClique), for: .touchUpInside)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! DetalheHeaderView
        
        header.usuario = self.usuario
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.bounds.width, height: view.bounds.height*0.7)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
//        cell.backgroundColor = .blue
//
//        return cell
  
        if indexPath.item == 0 {
           
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: perfilId, for: indexPath) as! DetalhePerfilCell
            cell.usuario = self.usuario
            
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: fotosId, for: indexPath) as! DetalheFotosCell
   
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexpath: IndexPath) -> CGSize {
        
        let width: CGFloat = UIScreen.main.bounds.width
        var height: CGFloat = UIScreen.main.bounds.width * 0.66
        
        if indexpath.item == 0 {
           
            let cell = DetalhePerfilCell(frame: CGRect(x: 0, y: 0, width: width, height: height))
            
            cell.usuario = self.usuario
            cell.layoutIfNeeded()
            
            let estimativaTamanho = cell.systemLayoutSizeFitting(CGSize(width: width, height: 1000))
            height = estimativaTamanho.height
        }
        
    
        
        
        return CGSize(width: width, height: height)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.y)
        
        let originY = view.bounds.height * 0.7 - 24
        
        if scrollView.contentOffset.y > 0 {
            self.voltarButton.frame.origin.y = originY - scrollView.contentOffset.y
        } else {
            self.voltarButton.frame.origin.y = originY + scrollView.contentOffset.y * -1
        }
        
    }
    
    @objc func voltarClique () {
        self.dismiss(animated: true, completion: nil)
    }

    @objc func dislikeClique () {
        self.callback?(self.usuario, Acao.dislike)
        self.voltarClique()
    }
    
    @objc func likeClique () {
        self.callback?(self.usuario, Acao.like)
        self.voltarClique()
    }
    
}

