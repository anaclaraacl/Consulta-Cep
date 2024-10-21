import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var TextFieldZipCode: UITextField!
    @IBOutlet weak var LabelPublicPlace: UILabel!
    @IBOutlet weak var LabelLocality: UILabel!
    @IBOutlet weak var LabelNeighborhood: UILabel!
    @IBOutlet weak var LabelDDD: UILabel!
    
    @IBOutlet weak var ButtonSearch: UIButton!
    
    let service = Service()
    let userDefaults = UserDefaults.standard
    var addressData: [ZipCodeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI(){
        TextFieldZipCode.keyboardType = .numberPad
        TextFieldZipCode.clearButtonMode = .whileEditing
        TextFieldZipCode.layer.cornerRadius = 6
        TextFieldZipCode.layer.borderWidth = 1
        TextFieldZipCode.layer.borderColor = UIColor.black.cgColor
        
        ButtonSearch.layer.cornerRadius = 6
        TextFieldZipCode.layer.borderWidth = 1
        TextFieldZipCode.layer.borderColor = UIColor.black.cgColor
    }
    
    private func createAlertView(with messageError: String){
        let alert = UIAlertController(title: "Alert", message: messageError, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK",style: .default))
        present(alert, animated: true)
        
    }
    
    private func clearFields() {
        LabelPublicPlace.text = "Logradouro:"
        LabelLocality.text = "Localidade:"
        LabelNeighborhood.text = "Bairro:"
        LabelDDD.text = "DDD:"
    }
    
    private func saveAddress(with address: ZipCodeModel) {
        addressData.append(address)
        do {
            let data = try JSONEncoder().encode(addressData)
            userDefaults.set(data, forKey: "ADDRESS")
        } catch {
            
        }
    }
    
    @IBAction func searchZipCode(_ sender: Any) {
        guard let zipCode = TextFieldZipCode.text else {return}
        
        service.searchZipCode(with: zipCode) { result in
            DispatchQueue.main.sync {
                switch result {
                case let .failure(error):
                    self.createAlertView(with: "Cep não encontrado!")
                    self.clearFields()
                    print(error.localizedDescription)
                case let .success(zipCode):
                    self.LabelPublicPlace.text = "Logradouro: \(zipCode.publicPlace)"
                    self.LabelLocality.text = "Localidade: \(zipCode.locality)/\(zipCode.uf)"
                    self.LabelNeighborhood.text = "Bairro: \(zipCode.neighborhood)"
                    self.LabelDDD.text = "DDD: \(zipCode.ddd)"
                }
            }
        }
    }
}
