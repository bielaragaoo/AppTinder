//
//  CombineVC.swift
//  AppTinder
//
//  Created by Gabriel Aragao on 08/04/22.
//

import UIKit

class CombineVC: UIViewController {
    
    
    var usuarios: [Usuario] = []
    var dislikeButton: UIButton = .iconFooter(named: "icone-deslike")
    var superlikeButton: UIButton = .iconFooter(named: "icone-superlike")
    var likeButton: UIButton = .iconFooter(named: "icone-like")
    var perfilButton: UIButton = .iconMenu(named: "icone-perfil")
    var chatButton: UIButton = .iconMenu(named: "icone-chat")
    var logoButon: UIButton = .iconMenu(named: "icone-logo")
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor.systemGroupedBackground
        
        
        self.adicionaHeader()
        self.adicionarFooter()
        self.buscaUsuarios()
             
    }
    
    func buscaUsuarios () {
        self.usuarios = UsuarioService.shared.buscaUsuarios()
        self.adicionarCards()
    
    }
}

extension UIApplication {
    static var firstKeyWindowForConnectedScenes: UIWindow? {
        UIApplication.shared
            // Of all connected scenes...
            .connectedScenes.lazy

            // ... grab all foreground active window scenes ...
            .compactMap { $0.activationState == .foregroundActive ? ($0 as? UIWindowScene) : nil }

            // ... finding the first one which has a key window ...
            .first(where: { $0.keyWindow != nil })?

            // ... and return that window.
            .keyWindow
    }
}


extension CombineVC {
    
    func adicionaHeader () {
        
        let window = UIApplication.firstKeyWindowForConnectedScenes
        let top: CGFloat = window?.safeAreaInsets.top ?? 44
        
        
        let stackView = UIStackView(arrangedSubviews: [perfilButton, UIView(), logoButon, UIView(), chatButton])
        stackView.distribution = .equalCentering
        
        view.addSubview(stackView)
        stackView.preencher(top: view.topAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: nil, padding: .init(top: top, left: 16, bottom: 0, right: 16))
        
        
    }
    
    
    func adicionarFooter () {
        let stackView = UIStackView(arrangedSubviews: [UIView(), dislikeButton, superlikeButton, likeButton, UIView()])
        stackView.distribution = .equalCentering
        
        view.addSubview(stackView)
        stackView.preencher(top: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor, bottom: view.bottomAnchor, padding: .init(top: 0, left: 16, bottom: 34, right: 16))
    }
}



extension CombineVC {
    func adicionarCards () {
        
        for usuario in usuarios {
        
        let card = CombineCardView()
            card.frame = CGRect(x: 0, y: 0, width: view.bounds.width - 32, height: view.bounds.height * 0.7)
        
        card.center = view.center
            card.usuario = usuario
            card.tag = usuario.id
        
        let gesture = UIPanGestureRecognizer()
        
        gesture.addTarget(self, action: #selector(handlerCard))
        
    card.addGestureRecognizer(gesture)
        view.insertSubview(card, at: 0)
        
        }
        
    }
}


extension CombineVC {
    @objc func handlerCard (gesture: UIPanGestureRecognizer){
        
        if let card = gesture.view as? CombineCardView {
            let point = gesture.translation(in: view)

            card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
            
            let rotationAngle = point.x / view.bounds.width * 0.4
            
            if point.x > 0 {
                card.likeImageView.alpha = rotationAngle * 4
                card.dislikeImageView.alpha = 0
            } else {
                card.likeImageView.alpha = 0
                card.dislikeImageView.alpha = rotationAngle * 4 * -1
            }
            
            
            
            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
            
            if gesture.state == .ended {
                
                UIView.animate(withDuration: 0.25){
                    card.center = self.view.center
                    card.transform = .identity
                    
                    card.likeImageView.alpha = 0
                    card.dislikeImageView.alpha = 0
                }
                
            }
        }
        
    }
}
