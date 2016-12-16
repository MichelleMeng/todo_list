//
//  ViewController.swift
//  Todo
//
//  Created by MichelleMeng on 16/11/8.
//  Copyright © 2016年 MichelleMeng. All rights reserved.
//

import UIKit
import CoreData

// 运行时的数据库（临时的，保存在内存里，每次启动都是空白的），本地数据库，存储每一行的值。每一行是一个Model，所以就是一个Model的数组
// 需要定义在 class 的外面。这样所有 class 都可以访问，是一个全局变量
var todos: [TodoModel] = []

func dateString(dateStr: String) -> NSDate? {
    
    //实例化一个NSDateFormatter对象。NSDateFormatter是一个很常用的类，用于格式化NSDate对象，支持本地化的信息
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = "yyyy-mm-dd"
    var newDate = dateFormatter.dateFromString(dateStr)
    return newDate
}


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var frc: NSFetchedResultsController!
    
    func fetchCoreData (){
        //加载AppDelegate
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        //获取管理的上下文
        let context = appDel.managedObjectContext
        // 声明数据请求实体
        let fetchRequest = NSFetchRequest(entityName: "TodoModel")
        let sd = NSSortDescriptor(key: "id", ascending: true) // 排序
        fetchRequest.sortDescriptors = [sd]
        
        frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        
        //        let predicate = NSPredicate(format:"id=1")  //设置查询条件按照id查找不设置查询条件，则默认全部查找
        //        fetchRequest.predicate=predicate
        
        //执行查询操作
        do {
            try frc.performFetch()
            todos = frc.fetchedObjects as! [TodoModel]
            print("打印查询结果")
            for todo in todos {
//                print("查询到\(todo.title!)")
            }
        } catch let error {
            print("context can't fetch!, Error:\(error)")
        }
        
    }
    
    func deleteCoreData (indexPath: NSIndexPath) {
        //加载AppDelegate
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        //获取管理的上下文
        let context = appDel.managedObjectContext
        
        let result = frc.objectAtIndexPath(indexPath) as! TodoModel
        
        context.deleteObject(result)
        
        do{
            try context.save()
            print("删除了\(indexPath)")
            
        }catch let error {
            print("can't delete!, Error:\(error)")
        }
        
    }
    
    func insertCoreData (todo: TodoModel, indexPath: NSIndexPath) {
        //加载AppDelegate
        let appDel = UIApplication.sharedApplication().delegate as! AppDelegate
        //获取管理的上下文
        let context = appDel.managedObjectContext
        
        let result = todo
        
        context.insertObject(result)
        
        do{
            try context.save()
            print("插入了\(indexPath)")
            
        }catch let error {
            print("can't insert!, Error:\(error)")
        }
        
    }

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func reloadButton(sender: AnyObject) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationItem.leftBarButtonItem = editButtonItem()
        navigationItem.title = "Todo List"
        //fetchCoreData()
        
        tableView.reloadData() //没有用，不是每次到主页都重新刷新
        
        //tableView.delegate = self
        
        
        // 在这里初始化，这样打开app的时候，有一些hard coded 的数据
        
//        todos = [TodoModel(id: "1", image: "coding", title: "learn iOS", date: dateString("2016-11-10")!),
//        TodoModel(id: "2", image: "doc", title: "company doc", date: dateString("2016-11-11")!)]
        
        
    }
    
    // 每次到达主页，都刷新页面
    override func viewDidAppear(animated: Bool) {
        // fetchCoreData()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK - UITableViewDataSource: how many rows in a section
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // self.tableView.reloadData() 这句如果加上，程序就会崩溃，Thread 1: exc_bad_access(code=2,address=0xbf7c5fac)
        
        return todos.count
    }
    
    // UITableViewDataSource: 每一个部分展示什么信息，图片, title, subtitle 分别绑定哪里
    @available(iOS 2.0, *)
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("todoCell") as UITableViewCell!
        
        var todo = todos[indexPath.row] as TodoModel
        
        var image = cell.viewWithTag(101) as! UIImageView  // tag can only be Int
        var title = cell.viewWithTag(102) as! UILabel
        var date = cell.viewWithTag(103) as! UILabel
        
        image.image = UIImage(named: todo.image!)
        title.text = todo.title
        
        let locale = NSLocale.currentLocale() // 实例化一个NSLocale
        let dateFormat = NSDateFormatter.dateFormatFromTemplate("yyyy-mm-dd", options: 0, locale: locale)
        // 如果不显示年份 let dateFormat = NSDateFormatter.dateFormatFromTemplate("mm-dd", options: 0, locale: locale)
        
        let dateFormatter = NSDateFormatter()  // 实例化一个NSDateFormatter
        dateFormatter.dateFormat = dateFormat  // .后面的dateFormat是dateFormatter里面的方法。＝ 右边的dateFormat是我们刚刚定义的
        
        date.text = dateFormatter.stringFromDate(todo.date!) //stringFromDate是 dateFormatter(实例化的NSDateFormatter)里面的方法
        
        //self.tableView.reloadData() 这句如果加上，页面就没有任何项
        
        return cell
        
    }
    
    // MARK - UITableViewDelegate
    
    // delete mode (直接用手势delete)
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            todos.removeAtIndex(indexPath.row)
            //self.tableView.reloadData()
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            deleteCoreData(indexPath)

        }
    }

    // edit mode (开启左上脚Edit，然后手动delete)
    override func setEditing(editing: Bool, animated: Bool){
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    
    
    // 上下移动cells. move rows 2 functions (editing mode下用手势移动cell)
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return editing
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        var todo = todos.removeAtIndex(sourceIndexPath.row)
//        deleteCoreData(sourceIndexPath)
        todos.insert(todo, atIndex: destinationIndexPath.row)
//        insertCoreData(todo, indexPath: destinationIndexPath)
//        fetchCoreData()
        tableView.reloadData()
    }

    
    
    
    // unwind segue 不传值
    @IBAction func close(segue: UIStoryboardSegue) {
        print("closed")
        print("count before reload \(todos.count)")
        // var nvc = segue.destinationViewController as! DetailViewController
        
        tableView.reloadData()
        print("double check \(todos.count)")
        // tableView.reloadData()
    }
    
    // unwind segue 传值
//    @IBAction func performUnwindSegue(segue: UIStoryboardSegue) {
//        if segue.identifier == DetailViewController.UnwindSegueAdd {
//            var newTodo: TodoModel
//            if let newTodo = (segue.sourceViewController as! DetailViewController).todo {
//                print ("to create new")
//                todos.append(newTodo)
//                print("unwind then \(todos.count)")
//                self.tableView.reloadData()
//            }
//        } else if segue.identifier == DetailViewController.UnwindSegueEdit {
//            self.tableView.reloadData()
//        }
//    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "EditTodo" {
            var dvc = segue.destinationViewController as! DetailViewController
            
            var indexPath = tableView.indexPathForSelectedRow!
            dvc.todo = todos[indexPath.row]
        }
        
//        if segue.identifier == "AddTodo" {
//            var nvc = segue.destinationViewController as! DetailViewController
//            
//            print(nvc.todo?.title)
//            self.tableView.reloadData()
//        }
    }
    
    
    
}

