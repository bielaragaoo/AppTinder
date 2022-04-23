//
//  DetalheHeaderView.swift
//  AppTinder
//
//  Created by Gabriel Aragao on 19/04/22.
//

import UIKit

class DetalheHeaderView: UICollectionReusableView {
    
    var usuario: Usuario? {
        didSet {
            if let usuario = usuario {
                fotoImageView.image = UIImage(named: usuario.foto)
            }
        }
    }
    
    var fotoImageView: UIImageView = .fotoImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(fotoImageView)
        fotoImageView.preencherSuperView()
        
        backgroundColor = .purple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
