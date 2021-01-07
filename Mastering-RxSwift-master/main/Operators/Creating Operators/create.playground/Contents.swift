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

/*:
 # create
 */

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}
// 파라미터로 전달된 요소를 방출하는 옵져버블 생성한다. 이렇게 생성된 옵져버블은 모든요소를 방출하고 컴플리티드 방출하고 종료된다. 이전에 쓴거로는 동작을 바꿀수 없다. 옵져버블이 동작하는 방식을 직접 구현하려면 이번에 쓸 create를 쓴다.
Observable<String>.create { (observer) -> Disposable in
  guard let url = URL(string: "https://www.apple.com") else {
    observer.onError(MyError.error)
    return Disposables.create() // Disposables을 쓰는게 맞음. s 필수
  }
  
  guard let html = try? String(contentsOf: url, encoding: .utf8) else {
    observer.onError(MyError.error)
    return Disposables.create()
  }
  
  observer.onNext(html)
  observer.onCompleted()
  
  observer.onNext("After completed") // 이미 completed가 되어서 이건 방출되지 않는다. 방출하고 싶으면 onCompleted전에 해야한다.
  
  return Disposables.create()
}
.subscribe { print($0) }
.disposed(by: disposeBag)
// 요소를 방출 onNext로 한다. 옵져버블 종료하기 위해서는 onError or onCompleted 를 해야한다.






