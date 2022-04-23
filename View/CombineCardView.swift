//
//  CombineCardView.swift
//  AppTinder
//
//  Created by Gabriel Aragao on 11/04/22.
//

import UIKit

class CombineCardView: UIView {
    
    var usuario: Usuario? {
        didSet {
            if let usuario = usuario {
                fotoImageView.image = UIImage(named: usuario.foto)
                nomeLabel.text = usuario.nome
                idadeLabel.text = String(usuario.idade)
                fraseLabel.text = usuario.frase
            }
        }
    }
    
    let fotoImageView: UIImageView = .fotoImageView()
    
    let nomeLabel: UILabel = .textBoldLabel(32, textColor: .white)
    let idadeLabel: UILabel = .textLabel(32, textColor: .white)
    let fraseLabel: UILabel = .textLabel(18, textColor: .white, numberOfLines: 2)
    
    let dislikeImageView: UIImageView = .iconCard(named: "card-deslike")
    let likeImageView: UIImageView = .iconCard(named: "card-like")
    
    var callback: ((Usuario) -> Void)?
    
    
        override init(frame: CGRect) {
        super.init(frame: frame)
            
            layer.borderWidth = 0.3
            layer.borderColor = UIColor.lightGray.cgColor
            layer.cornerRadius = 8
            clipsToBounds = true
            
            addSubview(fotoImageView)
            addSubview(dislikeImageView)
            addSubview(likeImageView)
        
        fotoImageView.preencherSuperView()
            
            dislikeImageView.preencher(top: topAnchor, leading: nil, trailing: trailingAnchor, bottom: nil, padding: .init(top: 20, left: 0, bottom: 0, right: 20), size: .init(width: 70, height: 70))
            
            likeImageView.preencher(top: topAnchor, leading: leadingAnchor, trailing: nil, bottom: nil, padding: .init(top: 20, left: 20, bottom: 0, right: 0), size: .init(width: 70, height: 70))
        
        let nomeIdadeStackView = UIStackView(arrangedSubviews: [nomeLabel, idadeLabel, UIView()])
            nomeIdadeStackView.spacing = 12
            
        let stackView = UIStackView(arrangedSubviews: [nomeIdadeStackView, fraseLabel])
            stackView.distribution = .fillEqually
            stackView.axis = .vertical
            
        addSubview(stackView)
            stackView.preencher(top: nil, leading: leadingAnchor, trailing: trailingAnchor, bottom: bottomAnchor, padding: .init(top: 0, left: 16, bottom: 16, right: 16))
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(visualizarClique))
            stackView.isUserInteractionEnabled = true
            stackView.addGestureRecognizer(tap)
            
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    @objc func visualizarClique () {
        if let usuario = self.usuario {
            self.callback?(usuario)
        }
   
    }
    
}
