//
//  ProductViewModel.swift
//  JeonGoo
//
//  Created by 이명직 on 2021/04/29.
//

import Foundation
import UIKit

class ProductViewModel {
    fileprivate let service = ProductDataService()
    
    
    var Products = [productData]()
    var Product: productData?
    var message: String?
    var get: Get?
    var post: Post?
    
    func findAll(completion: @escaping ((ViewModelState) -> Void)) {
        service.requestProducts { (productData, error) in
            if let error = error {
                self.message = error.localizedDescription
                completion(.failure)
                return
            }
            self.Products = productData
            completion(.success)
        }
    }
    
    func findByUserId(completion: @escaping ((ViewModelState) -> Void)) {
        service.requestProductsByUserId { (productData, error) in
            if let error = error {
                self.message = error.localizedDescription
                completion(.failure)
                return
            }
            self.Products = productData
            completion(.success)
        }
    }
    
    func findByProductId(id: Int, completion: @escaping ((ViewModelState) -> Void)) {
        service.requestProductsByProductId(id: id) { (productData, error) in
            if let error = error {
                self.message = error.localizedDescription
                completion(.failure)
                return
            }
            self.Product = productData
            completion(.success)
        }
    }
    
    func registerProduct(description: String, name: String, price: String, serialNumber: String, useStatus: String, images: [UIImage], completion: @escaping ((ViewModelState) -> Void)) {
        service.requestProductRegister(description: description, name: name, price: price, serialNumber: serialNumber, useStatus: useStatus, images: images) { (productData, error) in
            if let error = error {
                self.message = error.localizedDescription
                completion(.failure)
                return
            }
            completion(.success)
        }
    }
    
    func removeProduct(completion: @escaping ((ViewModelState) -> Void)) {
        service.requestRemoveProduct { (get, error) in
            if let error = error {
                let message = error.localizedDescription
                self.message = message
                completion(.serverError)
                return
            }
            self.get = get
           
            let statusCode = get?.statusCode
            if statusCode == 200 || statusCode == 201 {
                completion(.success)
            }
            else {
                completion(.failure)
            }
        }
    }
    
    func purchaseProduct(completion: @escaping ((ViewModelState) -> Void)) {
        service.requestPurchaseProduct { (post, error) in
            if let error = error {
                let message = error.localizedDescription
                self.message = message
                completion(.serverError)
                return
            }
            self.post = post
           
            let statusCode = post?.statusCode
            if statusCode == 200 || statusCode == 201 {
                completion(.success)
            }
            else {
                completion(.failure)
            }
            
        }
    }
    
    func findPurchasedProductByUserId(completion: @escaping ((ViewModelState) -> Void)) {
        service.requestFindPurchasedProductByUserId { (productData, error) in
            if let error = error {
                self.message = error.localizedDescription
                completion(.failure)
                return
            }
            self.Products = productData
            completion(.success)
        }
    }
    
    func findSellProductByUserId(completion: @escaping ((ViewModelState) -> Void)) {
        service.requestFindSellProductByUserId { (productData, error) in
            if let error = error {
                self.message = error.localizedDescription
                completion(.failure)
                return
            }
            self.Products = productData
            completion(.success)
        }
    }
    
    func findInterestedProduct(completion: @escaping ((ViewModelState) -> Void)) {
        service.requestFindInterestedProduct{ (productData, error) in
            if let error = error {
                self.message = error.localizedDescription
                completion(.failure)
                return
            }
            self.Products = productData
            completion(.success)
        }
    }
    
    func setInterestProduct(productId: Int, completion: @escaping ((ViewModelState) -> Void)) {
        service.requestSetInterestProductByProductId(productId: productId) { (post, error) in
            if let error = error {
                let message = error.localizedDescription
                self.message = message
                completion(.serverError)
                return
            }
            self.post = post
            let statusCode = post?.statusCode
            if statusCode == 200 || statusCode == 201 {
                completion(.success)
            }
            else {
                completion(.failure)
            }
        }
    }
    
    func removeInterestProduct(productId: Int,completion: @escaping ((ViewModelState) -> Void)) {
        service.requestDeleteInterestProduct(productId: productId) { (get, error) in
            if let error = error {
                let message = error.localizedDescription
                self.message = message
                completion(.serverError)
                return
            }
            self.get = get
           
            let statusCode = get?.statusCode
            if statusCode == 200 || statusCode == 201 {
                completion(.success)
            }
            else {
                completion(.failure)
            }
        }
    }
}
