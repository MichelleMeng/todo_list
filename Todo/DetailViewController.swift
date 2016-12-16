//
//  DetailViewController.swift
//  Todo
//
//  Created by MichelleMeng on 16/11/10.
//  Copyright © 2016年 MichelleMeng. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController, UITextFieldDelegate {
    
    static let UnwindSegueAdd = "UnwindAddTodo"
    static let UnwindSegueEdit = "UnwindEditTodo"

    @IBOutlet weak var callIcon: UIButton!
    
    @IBOutlet weak var codingIcon: UIButton!
    
    @IBOutlet weak var docIcon: UIButton!
    
    @IBOutlet weak var goIcon: UIButton!
    
    @IBOutlet weak var shopIcon: UIButton!
    
    @IBOutlet weak var todoTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var todo: TodoModel?
    
    
    // 添加到 Core Data 并保存
    
    func addCoreData(id: String, image: String, title: String, date: NSDate) {
        //加载AppDelegate
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        //获取管理的上下文
        let context = appDel.managedObjectContext
        //创建一个实例并给属性赋值
        todo = NSEntityDescription.insertNewObjectForEntityForName("TodoModel", inManagedObjectContext: context) as! TodoModel
        todo!.id = id
        todo!.image = image
        todo!.title = title
        todo!.date = date
        
        //保存数据
        do {
            try context.save()
            print("保存了\(todo!.title!)")
            
        }catch let error{
            print("context can't save!, Error:\(error)")
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todoTextField.delegate = self

        // Do any additional setup after loading the view.
        if todo == nil{
            navigationItem.title = "New"
            callIcon.selected = true
        }
        else {
            navigationItem.title = "Edit"
            switch todo!.image! {
            case "call":
                callIcon.selected = true
            case "coding":
                codingIcon.selected = true
            case "doc":
                docIcon.selected = true
            case "go":
                goIcon.selected = true
            case "shop":
                shopIcon.selected = true
            default:
                callIcon.selected = true
            }
            
            todoTextField.text = todo!.title
            datePicker.setDate(todo!.date!, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // 所有按钮都设为 unselected 非选中状态
    func resetButtons() {
        callIcon.selected = false
        codingIcon.selected = false
        docIcon.selected = false
        goIcon.selected = false
        shopIcon.selected = false
    }
    
    @IBAction func callTapped(sender: AnyObject) {
        resetButtons()
        callIcon.selected = true
        
    }
    
    @IBAction func codingTapped(sender: AnyObject) {
        resetButtons()
        codingIcon.selected = true
//        codingIcon.setImage(UIImage(named: "coding"), forState: .Normal)
    }
    
    @IBAction func docTapped(sender: AnyObject) {
        resetButtons()
        docIcon.selected = true
            }
    
    @IBAction func goTapped(sender: AnyObject) {
        resetButtons()
        goIcon.selected = true
            }
    
    @IBAction func shopTapped(sender: AnyObject) {
        resetButtons()
        shopIcon.selected = true
    }
    
    
    @IBAction func submitButton(sender: AnyObject) {
        
        // 需要把刚刚选择、填写的信息储存下来
        var image = ""
        if callIcon.selected == true {
            image = "call"
        } else if codingIcon.selected == true {
            image = "coding"
        } else if docIcon.selected == true {
            image = "doc"
        } else if goIcon.selected == true {
            image = "go"
        } else if shopIcon.selected == true {
            image = "shop"
        }
        
        var title = todoTextField.text
        var date = datePicker.date
        
        if todo == nil {
            // 生成一个uuid
            let uuid = NSUUID().UUIDString

            // 生成一个 todoModel，并放入todos数组中
            addCoreData(uuid, image: image, title: title!, date: date)
            
//            todo = TodoModel(id: uuid, image: image, title: title!, date: date)
            print("new Todo created")
//            performSegueWithIdentifier(DetailViewController.UnwindSegueAdd, sender: nil)
            
            //todos.append(todo!)
            // print("check how many todos \(todos.count)")
            //        navigationController?.popToRootViewControllerAnimated(true)
        }
        else {
            todo!.image = image
            todo!.title = title!
            todo!.date = date
            print("Todo edited")
//            performSegueWithIdentifier(DetailViewController.UnwindSegueEdit, sender: nil)
        }
        
        
    }
    
    // text field keyboard disappear when hit "Enter"
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // text field keyboard disappear when hit outside the keyboard
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        todoTextField.resignFirstResponder()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
