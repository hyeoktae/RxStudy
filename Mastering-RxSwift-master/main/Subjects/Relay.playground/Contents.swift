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
import RxCocoa

/*:
 # Relay
 */

let bag = DisposeBag()


//  Relay는 Next이벤트만 전달한다. 즉 종료가 안된다. 주로 UI Event처리에 자주 쓰인다.
// 이건 RxCocoa 에서 제공한다.

let prelay = PublishRelay<Int>()

prelay.subscribe {print("1: \($0)")}
  .disposed(by: bag)

prelay.accept(1) // onNext가 없다.


let bRelay = BehaviorRelay(value: 1)
bRelay.accept(2)

bRelay.subscribe {
  print("2: \($0)")
}
.disposed(by: bag)

bRelay.accept(3)

print(bRelay.value) // 여기있는 value는 읽기전용이다. 값을 바꾸려면 accept를 통해 바꿔줘야한다.
