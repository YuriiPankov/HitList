import UIKit
import CoreData

class MainViewController: UIViewController {
    var people: [NSManagedObject] = []
    let tableView = UITableView()
    var managedContext: NSManagedObjectContext?
    var entity: NSEntityDescription?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupEntity()
    }
}

extension MainViewController: UITableViewDataSource {
    func setupUI(){
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addName))
        view.backgroundColor = .cyan
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "The List"
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc func addName(){
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned self] action in
            guard let textField = alert.textFields?.first,
                  let nameToSave = textField.text else {
                      return
                  }
            
            self.save(nameToSave)
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Strings.cell)
        configureTableViewLayout(tableView)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let person = people[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: Strings.cell, for: indexPath)
        cell.textLabel?.text = person.value(forKeyPath: Strings.name) as? String
        cell.textLabel?.numberOfLines = 0
        return cell
    }
    
    func configureTableViewLayout(_ tableView: UITableView){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func save(_ name: String) {
        guard let managedContext = managedContext,
        let entity = entity else {
            return
        }
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        person.setValue(name, forKey: Strings.name)
        do {
            try managedContext.save()
            people.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func setupEntity(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: Strings.person, in: managedContext)
        self.managedContext = managedContext
        self.entity = entity
    }
}
