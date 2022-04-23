//
//  DetalheFotosCell.swift
//  AppTinder
//
//  Created by Gabriel Aragao on 20/04/22.
//

import UIKit

class DetalheFotosCell: UICollectionViewCell {
    
    let descricaoLabel: UILabel = .textBoldLabel(16)
    
    let slideFotosVC = SlideFotosViewController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    
        descricaoLabel.text = "Fotos Recentes"
        addSubview(descricaoLabel)
        descricaoLabel.preencher(top: topAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: nil, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
    
        addSubview(slideFotosVC.view)
        slideFotosVC.view.preencher(top: descricaoLabel.bottomAnchor, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
