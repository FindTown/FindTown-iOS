import UIKit
import RxSwift

class BaseViewController: UIViewController {
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        setupView()
        setLayout()
        
        bindViewModel()
    }
    
    func addView() {}
    func setupView() {}
    func setLayout() {}
    
    func bindViewModel() {}
}
