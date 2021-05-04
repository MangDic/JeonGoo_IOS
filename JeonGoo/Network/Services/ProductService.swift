import Moya
import SwiftKeychainWrapper


public enum ProductService {
    case findAll
    case findById(productId: Int)
    case findByUserId(UserId: Int)
    case productRegistration(description: String, name: String, price: String, serialNumber: String, useStatus: String)
}

extension ProductService: TargetType {
    
    private var token: String {
        return KeychainWrapper.standard.string(forKey: KeychainStorage.accessToken) ?? ""
    }
    
    public var baseURL: URL {
        return URL(string: NetworkController.baseURL)!
    }
    
    public var path: String {
        switch self {
        case .findAll:
            return "/products"
        case let .findById(productId):
            return "/products/\(productId)"
        case let .findByUserId(userId):
            return "/products/users/\(userId)"
        case let .productRegistration(userId):
            return "/products/users/\(MyPageViewController.userId!)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .findAll,
             .findById,
             .findByUserId:
            return .get
        case .productRegistration:
            return .post
        }
    }
    
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        switch self {
        case .findAll:
            return .requestPlain
        case .findById(productId: let productId):
            return .requestPlain
        case .findByUserId(UserId: let userId):
            return .requestPlain
        case .productRegistration(description: let description, name: let name, price: let price, serialNumber: let serialNumber, useStatus: let useStatus):
            return .requestCompositeParameters(bodyParameters: ["fileInfoRequest": ["imageFiles" : [nil]], "productBasicInfoRequest":["description": description, "name": name, "price":price, "serialNumber":serialNumber, "useStatus":useStatus]], bodyEncoding: JSONEncoding.default, urlParameters: .init())
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json",
                    "jwt": token]
        }
    }
    
    public var validationType: ValidationType {
        .successCodes
    }
}
