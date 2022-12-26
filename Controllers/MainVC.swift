//
//  ViewController.swift
//  scsaa
//
//  Created by 한지훈 on 2022/11/17.
//

import UIKit
import SwiftUI
import SnapKit
import Alamofire

//옆에 preview를 보기위한 view
struct VCPreView: PreviewProvider {
    static var previews: some View {
        MainVC().toPreview()
    }
}

var selectedIndexPath: Int = -1 //Cell선택인지, didTapAddBtn인지 확인하기 위한 전역변수 (Cell 선택이면 원래 있던 정보 그대로 가져감),

var todoList: [Todo] = [] //Todo + TodoId
var totalTaskCount: Int = 0
var completedTaskCount: Int = 0

class MainVC: UIViewController {
 

    //TableView
    lazy var customTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.register(CustomTableCell.self, forCellReuseIdentifier: CustomTableCell.identifier)
        tv.backgroundColor = .white
        
        return tv
    }()
    
    lazy var searchField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search"
        tf.textColor = .lightGray
        tf.addLeftPadding()
        tf.addLeftImage(UIImage(systemName: "magnifyingglass")!)
        
        return tf
    }()
    
    lazy var addTaskButton: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        
        //밑의 3줄 적용 안하면 버튼은 큰데 이미지는 작음.
        btn.contentHorizontalAlignment = .fill
        btn.contentVerticalAlignment = .fill
        btn.imageView?.contentMode = .scaleAspectFit
        
        btn.addTarget(self, action: #selector(didTapAddBtn(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    lazy var doneTaskLabel: UILabel = {
       let label = UILabel()
        label.text = "29"
        label.font = .systemFont(ofSize: 50, weight: .medium)
        label.textColor = .black
        label.sizeToFit()
        
        return label
    }()
    
    lazy var totalTaskLabel: UILabel = {
        let label = UILabel()
        label.text = "/ 100"
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.sizeToFit()
        
        return label
    }()
    
    @objc private func didTapAddBtn(_ sender: UIButton) {
        selectedIndexPath = -1  //얘는 Cell선택이 아니므로 -1
        
        let vc = AddListVC()
        vc.modalPresentationStyle = .automatic
        vc.dataClosure = {
            self.fetchTodoList()
        }
        
        self.present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        fetchTodoList() //맨처음 API에서 Get후 Update하기.
        setNavigationBar()
        configureUI()
        setAutoLayout()
        customTableView.delegate = self
        customTableView.dataSource = self
    }
    
    //fetch
    private func fetchTodoList() {

        ApiManager.shared.getTodoList(String(loginUser.memberId)) { response in
            todoList = response
            completedTaskCount = 0
            
            totalTaskCount = todoList.count + 1
            for todo in todoList {
                if todo.isCompleted {
                    completedTaskCount += 1
                }
            }
            
            self.totalTaskLabel.text = String(totalTaskCount)
            self.doneTaskLabel.text = String(completedTaskCount)
            
            //비동기식 API 처리. -> 안하면 느려서 viewDidLoad가 끝남
            DispatchQueue.main.async {
                self.customTableView.reloadData()
            }
        }

    }

    private func configureUI() {
        
        view.backgroundColor = .white
        self.title = "All Tasks"
        
    [customTableView, searchField, doneTaskLabel, totalTaskLabel, addTaskButton].forEach {view.addSubview($0)}}
    
    private func setAutoLayout() {
        customTableView.snp.makeConstraints {
            $0.top.equalTo(searchField.snp.bottom).offset(10)
            $0.left.right.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview()
        }
        
        searchField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(170)
            $0.width.equalTo(200)
            $0.right.equalToSuperview().inset(10)
            $0.height.equalTo(35)
        }
    
        doneTaskLabel.snp.makeConstraints {
            $0.right.equalTo(searchField.snp.left).offset(-80)
            $0.top.equalToSuperview().inset(150)
        }
        
        totalTaskLabel.snp.makeConstraints {
            $0.left.equalTo(doneTaskLabel.snp.right).offset(7)
            $0.top.equalToSuperview().inset(180)
        }
    
        addTaskButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(7)
            $0.width.equalTo(60)
            $0.height.equalTo(60)
        }
    }
    
    func setNavigationBar(){
            configureNavigationTitle()
            configureNavigationButton()
        }
    
    func configureNavigationTitle(){
            self.title = "Navigation"
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 25)]
        }
        
        func configureNavigationButton(){
            let rightItem1 = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
            let rightItem2 = UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: nil)
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .plain, target: self, action: nil)
            self.navigationItem.rightBarButtonItems = [rightItem1, rightItem2]
        }
    }

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomTableCell.identifier, for: indexPath) as? CustomTableCell else {return UITableViewCell()}
        cell.configure(todoList[indexPath.item], indexPath.row) //indexPath.row주는 이유는 button.tag에 붙여줄라고.
        
        return cell
    }
    
    //스와이프를 이용한 tableviewcell 삭제
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let todoId = todoList[indexPath.row].id
            let completed = todoList[indexPath.row].isCompleted
            
            ApiManager.shared.deleteTodoList(todoId) { response in
                if completed {
                    completedTaskCount -= 1
                }
                totalTaskCount -= 1
                print("Delete Success!!")
                todoList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.fetchTodoList()
            }
        }
    }
    
    //cell 선택시 수정함.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        selectedIndexPath = indexPath.row //Update의 index
        
        let vc = AddListVC()
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .automatic
        vc.dataClosure = {
            self.fetchTodoList()
        }

        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
}



class CustomTableCell: UITableViewCell {
    
    static let identifier = "CustomTableCell"
    
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        
        lb.textColor = .black
        lb.font = .systemFont(ofSize: 20, weight: .semibold)
        lb.sizeToFit()
        return lb
    }()
    
    //completedButton Select시 현재 Cell에 밑줄 긋기
    lazy var lineView: UIView = {
        
        let view = UIView()
        view.backgroundColor = .black
        view.isHidden = true
        
        return view
    }()
    
    
    lazy var completedButton: CustomButton = {
        
        let btn = CustomButton()
        btn.addTarget(self, action: #selector(didTapCompletedBtn(_:)), for: .touchUpInside)
        
        return btn
    }()
    
    //CompletedButton 클릭시
    @objc private func didTapCompletedBtn(_ sender: CustomButton) {
        
        sender.isCompleted(true)
        updateTodoCompleted(sender.tag)
    }
    
    private func updateTodoCompleted(_ index: Int) {
        
        var todo = todoList[index]
        todo.isCompleted = true
        
        ApiManager.shared.updateTodoList(todo) { response in
            if response {
                completedTaskCount += 1
                print("\(todo.id)의 completed는 \(todo.isCompleted)")
                self.lineView.isHidden = false
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configureUI()
        setAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0))
    }
    
    func configure(_ data: Todo, _ index: Int) {
        self.titleLabel.text = data.content
        self.completedButton.tag = index
        self.backgroundColor = .white
        
        //completed면
        if data.isCompleted == true {
            self.lineView.isHidden = false
            self.completedButton.isCompleted(true)
        }
        
        //completed가 아니면
        else {
            self.lineView.isHidden = true
            self.completedButton.isCompleted(false)
        }
    }
    
    private func configureUI() {
        [completedButton, titleLabel, lineView].forEach { contentView.addSubview($0)}
        contentView.layer.borderWidth = 0.3
        contentView.layer.cornerRadius = 10
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.backgroundColor = .white
    }
    
    private func setAutoLayout() {
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(completedButton.snp.right).offset(30)
        }
        
        completedButton.snp.makeConstraints {
            $0.left.equalTo(contentView).inset(15)
            $0.width.equalTo(33)
            $0.height.equalTo(33)
            $0.centerY.equalToSuperview()
        }
        
        lineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(30)
            $0.left.equalTo(completedButton.snp.right).offset(15)
        }
    }
}
