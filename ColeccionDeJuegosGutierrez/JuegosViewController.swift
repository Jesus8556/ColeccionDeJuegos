//
//  JuegosViewController.swift
//  ColeccionDeJuegosGutierrez
//
//  Created by Luis Gutierrez on 24/10/23.
//

import UIKit

class JuegosViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource {
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var agregarActualizarBoton: UIButton!
    @IBOutlet weak var tituloTextField: UITextField!
    @IBOutlet weak var eliminarBoton: UIButton!
    
    let lista = ["Animado","Silvestre","General","Fauna"]
    var imagePicker = UIImagePickerController()
    var juego:Juego? = nil
    var descripcionSelected:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        imagePicker.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if juego != nil {
            imageView.image = UIImage(data: (juego!.imagen!) as Data)
            tituloTextField.text = juego!.titulo
            agregarActualizarBoton.setTitle("Actualizar", for: .normal)
        }else{
            eliminarBoton.isHidden = true
        }

        // Do any additional setup after loading the view.
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        lista.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return lista[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        descripcionSelected = lista[row]
        print(descripcionSelected)
    }
    @IBAction func fotosTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func camaraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func agregarTapped(_ sender: Any) {
        if juego != nil {
            juego!.titulo! = tituloTextField.text!
            juego!.imagen = imageView.image?.jpegData(compressionQuality: 0.50 )
            juego!.descripcion = descripcionSelected
        }else{
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let juego = Juego(context:context)
            juego.titulo = tituloTextField.text
            juego.imagen = imageView.image?.jpegData(compressionQuality: 0.50)
            juego.descripcion = descripcionSelected
            
        }
    
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
        
    }
    @IBAction func eliminarTapped(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.delete(juego!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        navigationController?.popViewController(animated: true)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagenSeleccionada = info[.originalImage] as? UIImage
        imageView.image = imagenSeleccionada
        imagePicker.dismiss(animated: true, completion: nil)
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
