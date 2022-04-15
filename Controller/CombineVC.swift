//
//  CombineVC.swift
//  AppTinder
//
//  Created by Gabriel Aragao on 08/04/22.
//

import UIKit

enum Acao {
    case dislike
    case like
    case superlike
}

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
        
        let loading = Loading(frame: view.frame)
        view.insertSubview(loading, at: 0)
        
        
        self.adicionaHeader()
        self.adicionarFooter()
        self.buscaUsuarios()
             
    }
    
    func buscaUsuarios () {
//        self.usuarios = UsuarioService.shared.buscaUsuarios()
//        self.adicionarCards()
        UsuarioService.shared.buscaUsuarios{(usuarios, err) in
        if let usuarios = usuarios {
            DispatchQueue.main.async {
                self.usuarios = usuarios
                self.adicionarCards()
            }
            
        }
        }
        
        
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
        
        dislikeButton.addTarget(self, action: #selector(dislikeClique), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(likeClique), for: .touchUpInside)
        superlikeButton.addTarget(self, action: #selector(superlikeClique), for: .touchUpInside)
        
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
        view.insertSubview(card, at: 1)
        
        }
        
    }
    func removeCard (card: UIView) {
        card.removeFromSuperview()
        
    self.usuarios = self.usuarios.filter({(usuario) -> Bool in
        return usuario.id != card.tag
        

        }
        
    )}
   
        func verificarMatch (usuario: Usuario) {
            if usuario.match {
                print ("WOOOOOOOw")
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
                
                if card.center.x > self.view.bounds.width + 50 {
                    self.animaCard(rotationAngle: rotationAngle, acao: .like)
                    return
                }
                
                if card.center.x < -50 {
                    self.animaCard(rotationAngle: rotationAngle, acao: .dislike)
                    return
                }
                
                UIView.animate(withDuration: 0.25){
                    card.center = self.view.center
                    card.transform = .identity
                    
                    card.likeImageView.alpha = 0
                    card.dislikeImageView.alpha = 0
                }
                
            }
        }
    }
    
    @objc func dislikeClique () {
        self.animaCard(rotationAngle: -0.4, acao: .dislike)
    }
    @objc func likeClique () {
        self.animaCard(rotationAngle: 0.4, acao: .like)
    }
    
    @objc func superlikeClique () {
        self.animaCard(rotationAngle: 0, acao: .superlike)
    }
    
    func animaCard (rotationAngle: CGFloat, acao: Acao) {
//        print (rotationAngle)
//        print (acao)
        
        if let usuario = self.usuarios.first {
            for view in self.view.subviews {
                if view.tag == usuario.id {
                    if let card = view as? CombineCardView {
                        let center: CGPoint
                        var like: Bool
                        
                        switch acao {
                        case .dislike:
                            center = CGPoint(x: card.center.x - self.view.bounds.width, y: card.center.y + 50)
                        like = false
                        case .like:
                            center = CGPoint(x: card.center.x + self.view.bounds.width, y: card.center.y + 50)
                        like = true
                        
                        case.superlike:
                            center = CGPoint(x: card.center.x, y: card.center.y - self.view.bounds.height)
                        like = true
                        }
                            
                            
                        UIView.animate(withDuration: 0.4, animations: {
                            card.center = center
                            card.transform = CGAffineTransform(rotationAngle: rotationAngle)
                            
                            card.dislikeImageView.alpha = like == false ? 1 : 0
                            card.likeImageView.alpha = like == true ? 1 : 0
                        }) { (_) in
                            
                            if like {
                                self.verificarMatch(usuario: usuario)
                        }
                            
                            self.removeCard(card: card)
                        }
                    }
                }

            }

        

        }
    }
}
