//
//  ViewController.swift
//  ColeccionDeJuegosGutierrez
//
//  Created by Luis Gutierrez on 24/10/23.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var juegos : [Juego] = []
    @IBOutlet weak var botonEditar: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var mensaje = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        botonEditar.target = self
        botonEditar.title = "Editar"
        botonEditar.action = #selector(botonPresionado)
    }
    @objc func botonPresionado(){
        if mensaje {
            self.tableView.isEditing = true
            botonEditar.title = "Hecho"
        }else{
            self.tableView.isEditing = false
            botonEditar.title = "Editar"
        }
        mensaje.toggle()
    }
    
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if(self.isEditing){
            self.editButtonItem.title = "Editar"
        }else{
            self.editButtonItem.title = "Hecho"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return juegos.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell",for: indexPath)
        let juego = juegos[indexPath.row]
        cell.textLabel?.text = juego.titulo
        cell.detailTextLabel?.text = juego.descripcion

        cell.imageView?.image = UIImage(data: (juego.imagen!))
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let juego = juegos[indexPath.row]
        performSegue(withIdentifier: "juegoSegue", sender: juego)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let siguienteVC = segue.destination as! JuegosViewController
        siguienteVC.juego = sender as? Juego
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let juegoEliminar = juegos[indexPath.row]
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            context.delete(juegoEliminar)
            do{
                try context.save()
            }catch{
                print("Error al eliminar:\(error)")
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            juegos.remove(at: indexPath.row)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let juegoMovido = self.juegos[sourceIndexPath.row]
        juegos.remove(at: sourceIndexPath.row)
        juegos.insert(juegoMovido, at: destinationIndexPath.row)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        do{
            try juegos = context.fetch(Juego.fetchRequest())
            tableView.reloadData()
        }catch{
            
        }
    }


}

