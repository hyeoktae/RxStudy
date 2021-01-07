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
 # ReplaySubject
 */

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}


let rs = ReplaySubject<Int>.create(bufferSize: 3) // 3개의 이벤트를 저장하는 버퍼가 생성됨, 버퍼는 메모리를 사용하기 때문에, 필요 이상의 큰 버퍼를 사용하는것은 피해야한다.

(1...10).forEach {
  rs.onNext($0)
}

rs.subscribe { print("Observer 1 >>", $0) } // 8,9,10
  .disposed(by: disposeBag)

rs.subscribe { print("Observer 2 >>", $0) } // 8,9,10
  .disposed(by: disposeBag)

rs.onNext(11) // 가장 초기의 이벤트가 삭제됨 (버퍼가 3이라) 11, 11

rs.subscribe { print("Observer 3 >>", $0) } // 9,10,11
  .disposed(by: disposeBag)

//rs.onCompleted()
rs.onError(MyError.error)

rs.subscribe { print("Observer 4 >>", $0) } // 9,10,11, completed or error
  .disposed(by: disposeBag)

// replaySubject는 종료와 상관없이 버퍼에 저장되어있는 값을 새로운 구독자에게 전달 후 종료함.
