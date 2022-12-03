import UIKit
import RxSwift

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    deinit {
        disposeBag = DisposeBag()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        bindViewModel()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setUp()
        addView()
        setLayout()
        configureVC()
        configureNavigation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    func setUp() {}
    func addView() {}
    func setLayout() {}
    func configureVC() {}
    func configureNavigation() {}
    
    func bindViewModel() {}
}
