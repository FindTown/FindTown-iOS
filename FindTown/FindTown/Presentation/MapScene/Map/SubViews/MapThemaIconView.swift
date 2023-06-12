//
//  MapThemaIconView.swift
//  FindTown
//
//  Created by 이호영 on 2023/06/08.
//

import UIKit

import FindTownUI

final class MapThemaIconView: UIView {
    
    private let imageView = UIImageView()
    
    private let backgroundView = UIView()
  
    init(store: ThemaStore) {
        
        super.init(frame: .zero)
      
        setupImage(store: store)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImage(store: ThemaStore) {
        
      
        backgroundView.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        backgroundView.backgroundColor = .white

        backgroundView.layer.backgroundColor = UIColor(red: 0.267, green: 0.267, blue: 0.267, alpha: 1).cgColor
        backgroundView.layer.cornerRadius = 12
        
        imageView.frame = CGRect(x: 7, y: 7, width: 10, height: 10)
        imageView.image = store.category.image?.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = UIColor.white
    }


    private func setupView() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(imageView)
        self.addSubview(backgroundView)
        
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor),
            
            backgroundView.widthAnchor.constraint(equalToConstant: 24),
            backgroundView.heightAnchor.constraint(equalToConstant: 24),
        ])
    }
}
