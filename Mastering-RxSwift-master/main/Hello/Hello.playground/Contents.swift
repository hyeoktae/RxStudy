//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import RxSwift

//let disposeBag = DisposeBag()
//
//Observable.just("Hello, RxSwift!")
//  .subscribe { print($0) }
//  .disposed(by: disposeBag)
//
//
//
//let a = BehaviorSubject(value: 1)
//let b = BehaviorSubject(value: 2)
//
//Observable.combineLatest(a, b) {$0 + $1}
//  .subscribe(onNext: {print($0)})
//  .disposed(by: disposeBag)
//
//a.onNext(12)
//
//
//let o1 = Observable<Int>.create { (observer) -> Disposable in
//  observer.on(.next(0))
//  observer.onNext(1)
//
//  observer.onCompleted()
//
//  return Disposables.create()
//}
//
//
//
//o1.subscribe {
//  print($0)
//
//  if let elem = $0.element {
//    print(elem)
//  }
//} // 이 클로저가 옵져버
//
//
//o1.subscribe(onNext: { elem in
//  print(elem)
//})



//let subscription1 = Observable.from([0, 1, 3])
//  .subscribe { (elem) in
//    print("Next", elem)
//  } onError: { (error) in
//    print("Error", error)
//  } onCompleted: {
//    print("Completed")
//  } onDisposed: {
//    print("Disposed")
//  }
//// dispoased되는 시점에 뭘 해야하면 이렇게 사용한다.
//
//subscription1.dispose() // 직접 취소하는 방법이다.
//
//var bag = DisposeBag()
//
//Observable.from([1,2,3])
//  .subscribe {
//    print($0)
//  }
//  .disposed(by: bag)
//// dispoased가 되는 시점에 할게 없다면 이렇게 사용한다.
//// 이 방법으로 dispose하는게 좋다. 공식문서에서 이렇게 나온다고함.
//
//
//bag = DisposeBag() // 직접 해제 하고싶을때 이렇게 함, nil able하게 bag을 만들고 nil을 넣어줘도 된다고함
//
//let subscription2 = Observable<Int>.interval(.seconds(1),
//                                             scheduler: MainScheduler.instance)
//  .subscribe { (elem) in
//    print("Next", elem)
//  } onError: { (error) in
//    print("Error", error)
//  } onCompleted: {
//    print("Completed")
//  } onDisposed: {
//    print("Disposed")
//  }
//
//// 위 함수는 1초마다 1씩 증가하는 정수를 방출하는데, 무한정 방출한다. 그렇기에 Dispose가 필요하다.
//
//DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//  subscription2.dispose() // 이러면 즉시 리소스가 해제되기때문에 completed가 나오지 않고 종료된다. 이 방법은 가능하면 피해야한다.
//}










