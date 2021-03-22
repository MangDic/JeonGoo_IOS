//
//  MainViewController.swift
//  JeonGoo
//
//  Created by 이명직 on 2021/03/04.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarStack: UIStackView!
    @IBOutlet weak var TableMain: UITableView!
    
    
    var searchData : [Product]!
    var image = ["macbookAir", "macbookPro", "iphone"]
    var products = [Product]()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return searchData.count
    }
    
    func setSearchBar(){
            
            //서치바 만들기
            searchBar.placeholder = "Search"
            //왼쪽 서치아이콘 이미지 세팅하기
searchBar.setImage(resize(getImage: UIImage(named: "search")!, size: 20), for: UISearchBar.Icon.search, state: .normal)
            
            
        
            if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
                //서치바 백그라운드 컬러
                textfield.backgroundColor = UIColor.white
                //플레이스홀더 글씨 색 정하기
                textfield.attributedPlaceholder = NSAttributedString(string: textfield.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
                //서치바 텍스트입력시 색 정하기
                textfield.textColor = UIColor.black
            
            }
        }
   
    @IBAction func cancel(_ sender: Any) {
        self.searchData = self.products
        DispatchQueue.main.async {
            self.TableMain.reloadData()
            self.searchBar.text = ""
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TableMain.dequeueReusableCell(withIdentifier: "ItemsCell") as! ItemsCell
        cell.grade.text = searchData[indexPath.row].grade
        if cell.grade.text == "new" {
            cell.grade.text = "미개봉"
        }
        if searchData[indexPath.row].isGenuine {
            cell.grade.text! = cell.grade.text! + "  정품인증"
            cell.grade.attributedText = CustomLabel.init().setLabel(text: cell.grade.text!, code: 1).attributedText
        }
        
        cell.item.text = searchData[indexPath.row].name
        
        if searchData[indexPath.row].isReserved {
            cell.item.text! = "예약중  " + cell.item.text!
            cell.item.attributedText = CustomLabel.init().setLabel(text: cell.item.text!, code: 2).attributedText
        }
        
        cell.itemImage.image = resize(getImage: UIImage(named: image[indexPath.row])!, size: 150)
        cell.price.text = "\(searchData[indexPath.row].price)원"
        cell.like.text = "\(searchData[indexPath.row].likes)"
        return cell
    }
    
    private func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        dismissKeyboard()
       
        guard let searchStr = searchBar.text, searchStr.isEmpty == false else {
            self.searchData = self.products
            DispatchQueue.main.async {
                self.TableMain.reloadData()
            }
            return
        }
        print("검색어 : \(searchStr)")
    
        self.searchData = self.products.filter{
            (product: Product) -> Bool in
            product.name.lowercased().contains(searchStr.lowercased())
    }
        DispatchQueue.main.async {
            self.TableMain.reloadData()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){

          self.view.endEditing(true)

    }

    

    override func viewDidLoad() {
        super.viewDidLoad()

        setSearchBar()
        //TableMain.tableHeaderView = searchBar
        self.TableMain.rowHeight = self.view.frame.height*0.1;

        TableMain.delegate = self
        TableMain.dataSource = self
        searchBar.delegate = self
        
        products.append(Product(name: "macbookAir", price: 900000, likes: 16, count: 80, grade: "A등급", detail: "아주 좋아요", isReserved: false, isGenuine: true))
        products.append(Product(name: "macbookPro", price: 3000000, likes: 8, count: 122, grade: "B등급", detail: "ram 8GB / 2016년 제조 / SSD 128GB", isReserved: false, isGenuine: false))
        products.append(Product(name: "iphone", price: 800000, likes: 26, count: 66, grade: "new", detail: "이걸 왜 안 사지??", isReserved: true, isGenuine: true))
        
        self.searchData = self.products
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "detail" == id {
            if let controller = segue.destination as? DetailViewController {
                if let indexPath = TableMain.indexPathForSelectedRow {
                    controller.getName = searchData[indexPath.row].name
                    controller.getGrade = searchData[indexPath.row].grade
                    controller.getDetail = searchData[indexPath.row].detail
                    controller.getLikes = "관심  \(searchData[indexPath.row].likes)"
                    controller.getCount = "조회  \(searchData[indexPath.row].count)"
                    controller.getPrice = "\(searchData[indexPath.row].price)원"
                   
                }
            }
        }
    }
    
    
    
    func resize(getImage:UIImage, size:Double) -> UIImage {
        
        let wif = 70
        var new_image : UIImage!
        let size = CGSize(width:  size  , height: size )

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)

        UIGraphicsBeginImageContextWithOptions(size, false, 1.0)

        getImage.draw(in: rect)

        new_image = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()

        return new_image
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
