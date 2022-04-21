//
//  DetalhePerfilCell.swift
//  AppTinder
//
//  Created by Gabriel Aragao on 19/04/22.
//

import UIKit

class DetalhePerfilCell: UICollectionViewCell {
    
    var usuario: Usuario? {
        didSet {
            if let usuario = usuario {
                nomeLabel.text = usuario.nome
                idadeLabel.text = String(usuario.idade)
                fraseLabel.text = usuario.frase 
            }
        }
    }
    
    let nomeLabel: UILabel = .textBoldLabel(32)
    let idadeLabel: UILabel = .textLabel(28)
    let fraseLabel: UILabel = .textLabel(18, numberOfLines: 2)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .blue
//
//        nomeLabel.text = "Ana Laura"
//        idadeLabel.text = "20"
//        fraseLabel.text = "O último a dar match chama!"
        
        let nomeIdadeStackView = UIStackView(arrangedSubviews: [nomeLabel, idadeLabel, UIView()])
        nomeIdadeStackView.spacing = 12
        
        let stackView = UIStackView(arrangedSubviews: [nomeIdadeStackView, fraseLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        
       addSubview(stackView)
        stackView.preencherSuperView(padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
}
