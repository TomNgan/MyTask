//
//  TasksTableViewController.swift
//  MyTask
//
//  Created by shing ngan on 29/7/2020.
//  Copyright © 2020 Tom. All rights reserved.
//

import UIKit

class TasksTableViewController: UITableViewController {
    
    // MARK: - Lifecycle of View
    override func viewDidLoad() {
        
        super.viewDidLoad()
        setUpNavigationBar()
        setUpTableView()
    }
    
    //MARK: - View
    
    func setUpNavigationBar() {
        guard let myNavigationBar = self.navigationController?.navigationBar else { return }
        
        myNavigationBar.isTranslucent = false
                
        // Set up title
        myNavigationBar.topItem?.title = "My Tasks"
        myNavigationBar.prefersLargeTitles = true
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.6509803922, blue: 0.8274509804, alpha: 1)
            myNavigationBar.standardAppearance = navBarAppearance
            myNavigationBar.scrollEdgeAppearance = navBarAppearance
            navigationController?.navigationBar.overrideUserInterfaceStyle = .light
        } else {
            myNavigationBar.backgroundColor = #colorLiteral(red: 0.1490196078, green: 0.6509803922, blue: 0.8274509804, alpha: 1)
            myNavigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            myNavigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        }
        
        // Set up right button
        let rightBarBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.rightBarBtnIsPressed))
        self.navigationItem.rightBarButtonItem = rightBarBtn
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        
    }
    
    func setUpTableView() {
        tableView.tableFooterView = UIView()
    }
    
    //MARK: - Controller
    var taskStore: TaskStore! {
        didSet {
            // Get the data from user defaults
            taskStore.tasks = TasksUtility.fetch() ?? [[Task](), [Task]()]
            
            // Reload the table view
            tableView.reloadData()
        }
    }
    
    @objc private func rightBarBtnIsPressed() {
        print("rightBarBtnIsPressed: Add Task")
        // Setting up our alert controller
        let alertController = UIAlertController(title: "Add Task", message: nil, preferredStyle: .alert)
        
        // Set up the actions
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            // Grab text field text
            guard let taskName = alertController.textFields?.first?.text else { return }
            
            // Create task
            let newTask = Task(name: taskName)
            
            // Add task
            self.taskStore.add(newTask, at: 0)
            
            // Reload data in table view
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add the text field
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter task name..."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        
        // Add the action
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        // Present
        present(alertController, animated: true)
    }
    
    @objc private func handleTextChanged(_ sender: UITextField) {
        // Grab the alert controller and add action
        guard let alertController = presentedViewController as? UIAlertController,
              let addAction = alertController.actions.first,
              let text = sender.text
              else { return }
        
        // Enable add action based on if text is empty or contains whitespace
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
}

//MARK: - Data Source
extension TasksTableViewController {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Todo" : "Done"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.tasks[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksTableViewCell", for: indexPath)
        
        // View for cell
        // Set cell's selection style to none
        cell.selectionStyle = .none
        
        // Data for cell
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].name

        return cell
    }
    
}

//MARK: - Delegate
extension TasksTableViewController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .normal, title: nil) { (action, sourceView, completionHandler) in
            
            // Toggle that task is done
            self.taskStore.tasks[0][indexPath.row].isDone = true
            
            // Remove the task from the array containing todo tasks
            let newDoneTask = self.taskStore.remove(at: indexPath.row)
            
            // Reload table view for todo section
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Add the task from the array containing done tasks
            self.taskStore.add(newDoneTask, at: 0, isDone: true)
            
            // Reload table view for done section
            let newIndexPath = IndexPath.init(row: 0, section: 1)
            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            // Indicate that the action was performed
            completionHandler(true)
            
        }
        
        doneAction.image = #imageLiteral(resourceName: "done")
        doneAction.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.7529411765, blue: 0.2901960784, alpha: 1)
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            
            // Determine whether the task is done
            guard let isDone = self.taskStore.tasks[indexPath.section][indexPath.row].isDone else { return }
            
            // Remove the task from the appropriate array
            self.taskStore.remove(at: indexPath.row, isDone: isDone)
            
            // Reload table view
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Indicate that the action was performed
            completionHandler(true)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1450980392, blue: 0.168627451, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
