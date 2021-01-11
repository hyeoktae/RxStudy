# RxStudy. 

rx를 사용하는 이유 
기존코드에 비해 많이 단순해진다.

### rx 설치가 되었는지 확인
```swift
let disposeBag = DisposeBag() 

Observable.just("Hello, RxSwift!")
  .subscribe { print($0) }
  .disposed(by: disposeBag)
  ```
  
### 명령형 코드와 반응형 코드의 차이
값이나 상태의 변화에 따라 새로운 결과를 도출하는 코드를 쉽게 가능
이런게 반응형 프로그래밍이라고함

```swift
let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)

Observable.combineLatest(a, b) {$0 + $1}
  .subscribe(onNext: {print($0)}) // 3
  .disposed(by: disposeBag)

a.onNext(12) // 14
```

### Observables and Observers

Observable 은 Observer에게 이벤트를 전달
Observer는 Observable을 Subscribe한다.

옵져버블은 3가지 이벤트 전달
Next: Emission(방출, 배출) 값을 포함할수 있다.
Error, Completed: Notification, 이게 나오면 라이프사이클 종료, 이후에 다른 이벤트를 전달 할수없다. 

### 옵져버블 생성 방법

1. 
```swift
Observable<Int>.create { (observer) -> Disposable in
  observer.on(.next(0))
  observer.onNext(1)
  
  observer.onCompleted()
  
  return Disposables.create()
}
```

2. 
```swift
Observable.from([0, 1])
```

2개의 정수를 순서대로 방출하고 종료하는 옵져버블이다. 정의만 했지 아무작업도 안했다. 구독을 안했기 때문이다.


### 옵져버

```swift
let o1 = Observable<Int>.create { (observer) -> Disposable in
  observer.on(.next(0))
  observer.onNext(1)
  
  observer.onCompleted()
  
  return Disposables.create()
}
```
옵져버블 생성

1. 
```swift
o1.subscribe {
  print($0)
  
  if let elem = $0.element {
    print(elem)
  }
} // 이 클로저가 옵져버
```

2. 
```swift
o1.subscribe(onNext: <#T##((Int) -> Void)?##((Int) -> Void)?##(Int) -> Void#>, onError: <#T##((Error) -> Void)?##((Error) -> Void)?##(Error) -> Void#>, onCompleted: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, onDisposed: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
```

```swift
o1.subscribe(onNext: { elem in
  print(elem)
})
```
onNext만 사용했다. 옵셔널 바인딩 할 필요없다.
여러 이벤트를 동시에 전달하지 않는다. 
*하나의 이벤트가 실행된 후, 그다음 다음이벤트가 방출된다.*


### Disposables
리소스 해제할때 사용하는것.
subscribe가 리턴하는게 Disposable인데 이걸 Subscription Disposable이라고함
리소스해제, 실행취소에 사용됨.

```swift
let subscription1 = Observable.from([0, 1, 3])
  .subscribe { (elem) in
    print("Next", elem)
  } onError: { (error) in
    print("Error", error)
  } onCompleted: {
    print("Completed")
  } onDisposed: {
    print("Disposed")
  }
```

disposed되는 시점에 뭘 해야한다면 이렇게 사용한다.

```swift
subscription1.dispose() // 직접 취소하는 방법이다.
```

```swift
var bag = DisposeBag()

Observable.from([1,2,3])
  .subscribe {
    print($0)
  }
  .disposed(by: bag)
```

disposed가 되는 시점에 할게 없다면 이렇게 쓴다.
이 방법으로 dispose하는게 좋다. 공식문서에 이렇게 나온다고함.

```swift
bag = DisposeBag()
```
직접 해제 하고싶을때 이렇게 함, nil able하게 bag을 만들고 nil을 넣어줘도 된다고함


```swift 
let subscription2 = Observable<Int>.interval(.seconds(1),
                                             scheduler: MainScheduler.instance)
  .subscribe { (elem) in
    print("Next", elem)
  } onError: { (error) in
    print("Error", error)
  } onCompleted: {
    print("Completed")
  } onDisposed: {
    print("Disposed")
  }

// 위 함수는 1초마다 1씩 증가하는 정수를 방출하는데, 무한정 방출한다. 그렇기에 Dispose가 필요하다.

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
  subscription2.dispose() // 이러면 즉시 리소스가 해제되기때문에 completed가 나오지 않고 종료된다. 이 방법은 가능하면 피해야한다.
}
```



### Operators
연산자

연산자는 보통 subscribe앞에 호출한다.

```swift
let bag = DisposeBag()

Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9])
  .filter { $0.isMultiple(of: 2) } // 짝수만 필터
  .take(5) // 처음 5개의 요소만 전달한다.
  .subscribe { print($0) }
  .disposed(by: bag)

// 순서가 매우 중요하다. 호출순서에 따라 다른결과가 나오기때문에 호출순서를 중요하게 생각해야한다.
```
filter를 먼저하면 2,4,6,8 이고, take를 먼저하면 2,4 가 나온다. 


### Subject
옵저버는 하나의 옵저버블만 구독하고, 마찬가지로 옵저버블도 하나의 옵저버에 값을 전달할수있다.
옵저버인 동시에 옵저버블이다. 

publishSubject: 서브젝트로 전달되는 새로운 이벤트를 구독자에게 전달한다.
BehaviorSubject: 생성시점에 시작이벤트를 지정한다. 서브젝트로 전달되는 이벤트중에 가장마지막의 이벤트를 저장했다가, 새로운 구독자에게 마지막에 저장된 이벤트를 준다.
ReplaySubject: 처음부터 모든 이벤트를 저장한다. 그러고 새로운 구독자가 나타나면 저장했던 모든 이벤트를 준다.
AsyncSubject: subject로 completed가 전달되는 시점에 마지막 이벤트를 구독자에게 전달한다.

PublishRelay: PublishSubject를 랩핑한것
BehaviorRelay: BehaviorSubject를 랩핑한것
Relay는 completed, error는 받지 않고, next 이벤트만 받는다.
주로 종료없이 계속 전달되는 이벤트 시퀀스를 다룰때 사용한다. 

### PublishSubject
서브젝트로 전달되는 이벤트를 옵저버에 전달하는 가장 기본적인 subject이다.

```swift
let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let subject = PublishSubject<String>() // 내부에 아무런 이벤트가 없다.

subject.onNext("Hello") // 구독자가 없으면 이 이벤트는 그냥 사라진다.

let o1 = subject.subscribe { print(">> 1", $0) }
o1.disposed(by: disposeBag) // 구독하기 전 이벤트는 아무소용이 없다. publish는 (저장안해서)

subject.onNext("RxSwift")

let o2 = subject.subscribe { print(">> 2", $0) }
o2.disposed(by: disposeBag)

subject.onNext("Subject")

//subject.onCompleted()
subject.onError(MyError.error)

let o3 = subject.subscribe { print(">> 3", $0) } // 이미 completed가 되었기때문에 (종료됨) 바로 completed가 된다.
o3.disposed(by: disposeBag) // 이 전에 error가 나왔기때문에 바로 error가 된다.
// 만약 이전의 이벤트들을 저장하고 싶으면, replays 나 cold observable을 사용해야한다.
```

### BehaviorSubject

```swift
let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

// publish랑 비슷하지만, 서브젝트를 생성하는 방식에 차이가 있다.

let p = PublishSubject<Int>() // 이벤트가 없는채로 생성
p.subscribe { print("PublishSubject >>", $0) }
  .disposed(by: disposeBag)

let b = BehaviorSubject<Int>(value: 0) // 초기이벤트가 있는채로 생성 0인이유는 제네릭타임이 Int로 정해졌기때문이다. 새로운 구독자가 생성되면 바로 저장되어있는 초기 이벤트값이 전달된다.
b.subscribe { print("BehaviorSubject >>", $0) } // BehaviorSubject >> next(0)
  .disposed(by: disposeBag)

b.onNext(1)
 
b.subscribe { print("BehaviorSubject2 >>", $0) } // BehaviorSubject >> next(1) 결론적으로 보면 마지막 이벤트를 새로운구독자에게 전달을 하는것.
  .disposed(by: disposeBag)

//b.onCompleted()
b.onError(MyError.error)


b.subscribe { print("BehaviorSubject3 >>", $0) } // 이미 completed가 되어서(종료) 얘도 바로 completed가 된다. err도 마찮가지이다.
  .disposed(by: disposeBag)
```


### ReplaySubject

```swift
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
```


### AsyncSubject

```swift
let bag = DisposeBag()

enum MyError: Error {
   case error
}


// 서브젝트로 completed가 오기 전까지는 어떤 이벤트로 구독자에게 전달하지 않으나, completed가 오면 가장 마지막의 이벤트를 전달한다.

let subject = AsyncSubject<Int>()

subject.subscribe { print($0) }
  .disposed(by: bag)

subject.onNext(1)

subject.onNext(2)
subject.onNext(3)

//subject.onCompleted() // 이러면 3이 방출
subject.onError(MyError.error) // completed가 아니기 때문에, 에러만나온다.
```


### PublishRelay & BehaviorRelay
```swift
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
```


## Create Operators

### just & of & from

* just는 단 한번 방출하고 끝난다. 받은 그대로 방출한다.
* of는 여러개 방출가능하다. 하지만 받은 그대로 방출한다.
* from은 받은 배열의 요소를 하나씩 방출한다.

just
```swift
let disposeBag = DisposeBag()
let element = "😀"

//just는 한번만 방출한다.

Observable.just(element)
   .subscribe { event in print(event) }
   .disposed(by: disposeBag)

Observable.just([1, 2, 3]) // just로 생성한 Observable은 파라미터로 생성산 값 그대로 방출
   .subscribe { event in print(event) } // [1,2,3]
   .disposed(by: disposeBag)
```

of
```swift
let disposeBag = DisposeBag()
let apple = "🍏"
let orange = "🍊"
let kiwi = "🥝"

// of는 가변파라미터를 받기 때문에 받은 파라미터의 갯수만큼 방출한다.

Observable.of(apple, orange, kiwi)
   .subscribe { element in print(element) }
   .disposed(by: disposeBag)

Observable.of([1, 2], [3, 4], [5, 6]) // 받은 내용 그대로 방출한다.
   .subscribe { element in print(element) } // [1,2] > [3,4] > [5,6]
   .disposed(by: disposeBag)
```

from
```swift
let disposeBag = DisposeBag()
let fruits = ["🍏", "🍎", "🍋", "🍓", "🍇"]

// from은 배열에 포함된 요소를 하나씩 방출한다.

Observable.from(fruits)
   .subscribe { element in print(element) }
   .disposed(by: disposeBag)
```


### range & generate

'정수'를 원하는 갯수만큼 방출한다.

range
```swift
let disposeBag = DisposeBag()

Observable.range(start: 1, count: 10) // 실수가 오면 안된다.
   .subscribe { print($0) } // 1부터 1씩 증가하는 10개의 정수를 방출하고 종료
   .disposed(by: disposeBag) // 증가하는 크기를 바꾸거나 감소하는 시퀀스 생성은 불가하다.
```


generate

```swift
let disposeBag = DisposeBag()
let red = "🔴"
let blue = "🔵"


Observable.generate(initialState: 0, condition: { $0 <= 10 }, iterate: { $0 + 2 })
  .subscribe {print($0)}
  .disposed(by: disposeBag)

Observable.generate(initialState: 10, condition: { $0 >= 0 }, iterate: { $0 - 2 })
  .subscribe {print($0)}
  .disposed(by: disposeBag)

Observable.generate(initialState: red, condition: { $0.count < 15 }) {$0.count.isMultiple(of: 2) ? $0 + red : $0 + blue}
  .subscribe {print($0)}
  .disposed(by: disposeBag)
```


### repeatElement

동일한 요소를 반복적으로 방출한다.

```swift
let disposeBag = DisposeBag()
let element = "❤️"

// 무한정 같은걸 반복해서 방출한다.
Observable.repeatElement(element)
  .take(7) // 계속 나오는데 take를 통해 7개만 받고 종료한다.
  .subscribe { print($0) }
  .disposed(by: disposeBag)
```

### deferred

특정 조건에 따라 옵져버블을 생성

```swift
let disposeBag = DisposeBag()
let animals = ["🐶", "🐱", "🐹", "🐰", "🦊", "🐻", "🐯"]
let fruits = ["🍎", "🍐", "🍋", "🍇", "🍈", "🍓", "🍑"]
var flag = true

let factory: Observable<String> = Observable.deferred { // Type을 적어주어야한다.
  flag.toggle()
  if flag {
    return Observable.from(animals)
  } else {
    return Observable.from(fruits)
  }
}

factory.subscribe {print($0)} // 과일방출
  .disposed(by: disposeBag)

factory.subscribe {print($0)} // 동물방출
  .disposed(by: disposeBag)

factory.subscribe {print($0)} // 과일방출
  .disposed(by: disposeBag)
```

### create

옵져버블이 동작하는 방식을 직접 구현하기

```swift
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
```


### empty, error

empty

```swift
let disposeBag = DisposeBag()

// next이벤트를 전달하지 않는다. 어떠한 요소도 방출하지 않는다.

Observable<Void>.empty() // 요소를 방출하지 않아서 요소의 형식은 중요치 않음. 보통은 void
  .subscribe { print($0) }
  .disposed(by: disposeBag)
// 이건 옵져버가 아무런 동작없이 종료해야할 때 사용한다.
```

error

```swift
let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

// 에러이벤트를 전달하고 종료하는 옵져버블을 생성한다. 보통 애러를 처리할때 생성한다.
Observable<Void>.error(MyError.error)
  .subscribe { print($0) }
  .disposed(by: disposeBag)
// next이벤트를 전달하지 않는다. 
```


## Filtering Operators


### ignoreElements Operator

```swift
let disposeBag = DisposeBag()
let fruits = ["🍏", "🍎", "🍋", "🍓", "🍇"]


// 옵져버블이 방출하는 넥스트 이벤트를 필터링하고 컨플리티드, 에러 이벤트만 구독자에게 전달한다.

Observable.from(fruits)
  .ignoreElements()
  .subscribe {print($0)}
  .disposed(by: disposeBag)
// ignoreElements() -> param받지않음. 리턴형은 Completable. 이건 트레이치 라고 불리는 특별한 옵져버블이다. 컴플리티드나 에러만 전달하고 넥스트는 무시한다. 작업의 성공과 실패에만 관심이 있을 때 사용한다.
// ignoreElements가 필터링 하기 때문에 next가 무시된다.
```

### elementsAt

```swift
let disposeBag = DisposeBag()
let fruits = ["🍏", "🍎", "🍋", "🍓", "🍇"]


// 특정 인덱스에 위치한 요소를 제한적으로 방출하는 방법

Observable.from(fruits)
  .elementAt(1)
  .subscribe{print($0)}
  .disposed(by: disposeBag)

// elementAt -> 정수 인덱스를 파람으로 받아서 옵져버블을 리턴한다. 하나의 요소를 전달하고 컴플리트 방출한다.
```


### filter

```swift
let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// 옵져버블이 방출하는 요소를 필터링한다.

Observable.from(numbers)
  .filter {$0.isMultiple(of: 2)}
  .subscribe {print($0)}
  .disposed(by: disposeBag)


// filter -> 클로져를 파람으로 받는다. 이건 predicate로 사용된다. 여기서 true를 리턴하는 요소가 연산자가 리턴하는 옵져버블에 포함된다.
```


### skip

```swift
let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// 특정 연산자를 무시하는 방법
// 정수를 파람으로 받고, 옵져버블이 방출하는 요소중 지정된 수만큼 무시하고 이후에 방출되는 요소만 구독자에게 방출한다.

Observable.from(numbers)
  .skip(3) // 인덱스 아님, 갯수임
  .subscribe {print($0)}
  .disposed(by: disposeBag)
```


###  skipWhile

```swift
let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]


// 클로저를 파람으로 받는다. predicate로 사용되고, 리턴값이 false가 그때부터 요소 방출한다. 그 전까지는 모두 무시한다. (true가 리턴되는 동안 모두 무시) 방출되는 요소가 포함되는 옵져버블을 리턴한다.

Observable.from(numbers)
  .skipWhile {!$0.isMultiple(of: 2)}
  .subscribe{print($0)}
  .disposed(by: disposeBag)

// 리턴값이 false가 되는 순간부터 모든 값이 방출된다. 구독자에게 전달된다.
```


###  skipUntil

```swift
let disposeBag = DisposeBag()

let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

subject.skipUntil(trigger)
  .subscribe {print($0)}
  .disposed(by: disposeBag)

subject.onNext(1)

trigger.onNext(0)

subject.onNext(2)

trigger.onNext(3)

subject.onNext(4)
// 옵져버블타입을 파람으로 받는다. 다른 옵져버블을 받는다. 이 옵져버블이 넥스트이벤트를 전달하기 전까지 원본옵져버블이 방출하는 이벤트를 무시한다. 이런 특징때문에 파라미터로 전달하는 옵져버블을 트리거라고 부르기도 한다.
// 트리거가 방출 한 후에 서브젝트가 방출을 할 수 있다.  2,4
```


### take

```swift
let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// 정수를 파람으로 받아서 해당숫자만큼만 요소를 방출한다.  이어지는 나머지 이벤트는 무시.
// 넥스트이벤트를 제외한 나머지 이벤트엔 영향을 주지 않는다.

Observable.from(numbers)
  .take(5)
  .subscribe {print($0)}
  .disposed(by: disposeBag)
```

### takeWhile

```swift
let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// 클로져를 파람으로 받고 predicate로 사용한다. 여기에서 true를 리턴하면 구독자에게 전달한다. 요소를 방출한다. 연산자가 리턴하는 옵져버블은 최종적으로 조건을 만족시키는 요소만 포함된다.

Observable.from(numbers)
  .takeWhile { !$0.isMultiple(of: 2) }
  .subscribe {print($0)}
  .disposed(by: disposeBag)

// takeWhile -> 클로져가 false를 리턴하면 더이상 요소를 방출하지 않는다. 컴플리트나 에러만 방출한다. 
```


### takeUntil

```swift
let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]


let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

subject.takeUntil(trigger)
  .subscribe {print($0)}
  .disposed(by: disposeBag)

subject.onNext(1)
subject.onNext(2)

trigger.onNext(0) // 트리거에서 방출하면 completed이벤트가 전달된다.

subject.onNext(3) // 컴플리트가 방출되어서 더이상 요소를 방출하지 않는다.

// 옵져버블타입을 파람으로 받는다. 파람으로 받은 옵져버블에서 넥스트이벤트를 방출하기 전까지 원본에서 넥스트 이벤트를 전달한다.
```


### takeLast

```swift
let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]


let subject = PublishSubject<Int>()

subject.takeLast(2)
  .subscribe {print($0)}
  .disposed(by: disposeBag)

numbers.forEach {
  subject.onNext($0)
}

// 위 코드까지 결과는 아무것도 안나온다. 하지만 코드는 작동했다. takeLast는 마지막에 방출한 9, 10을 버퍼에 저장하고 있다.

subject.onNext(11)

// 이러면 버퍼에 저장되어있는 9, 10이 -> 10, 11로 업데이트 된다.
// 아직은 옵져버블이 다른요소를 방출할지 아니면 종료할지 판단할수 없어서 요소를 방출하는 시점을 계속 지연시킨다.

//subject.onCompleted()

// 컴플리티드 이벤트를 전달하면, 이때 버퍼에 저장되었던 요소가 구독자에게 전달되고, 그 후 컴플리티드 이벤트가 전달된다.

enum MyError: Error {
  case error
}

subject.onError(MyError.error)

// 에러가 전달되면 버퍼에 있는 요소는 전달되지 않고, 에러만 전달된다.

// 정수를 파람으로 받아서 옵져버블을 리턴한다. 리턴되는 옵져버블에는 원본옵져버블이 방출하는 요소중에서 마지막에 방출된 n개의 요소가 포함된다. 이 연산자에서 가장 중요한것은 구독자로 전달되는 시점이 딜레이된다는 것!
```


### single

```swift
let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// 원본 옵져버블에서 첫번째 요소만 방출하거나 조건과 일치하는 첫번째 요소만 방출한다.
// 하나의 요소만 방출을 허용, 2개이상의 요소가 방출되면 애러를 방출한다.

Observable.just(1)
  .single()
  .subscribe { print($0) }
  .disposed(by: disposeBag)

Observable.from(numbers)
  .single()
  .subscribe { print($0) }
  .disposed(by: disposeBag)

// 요소가 방출되는건 동일하지만, 컴플리티드가 아닌 에러이벤트가 전달된다.
// error(Sequence contains more than one element.)
// 단 하나의 요소가 방출되어야 정상적으로 종료된다.

Observable.from(numbers)
  .single { $0 == 3 }
  .subscribe { print($0) }
  .disposed(by: disposeBag)
 
// 배열에 3이 한개뿐이라 최종적으로 3이 하나만 방출되고 바로 컴플리티드 이벤트가 전달된다.
// 하나의 요소만 나온다는걸 보장한다. 배열에 3이 두개라면 애러가 난다.

let subject = PublishSubject<Int>()

subject.single()
  .subscribe { print($0) }
  .disposed(by: disposeBag)

subject.onNext(100)

// 새로운 이벤트가 방출되면 바로 구독자에게 전달한다. 하나의 요소가 전달 된 후, 바로 컴플리트가 전달되는건 아니다.
// 다른 요소가 방출될수도 있으니까 대기한다. 싱글연산자가 리턴하는 옵져버블은 원본 옵져버블에서 컴플리티드 이벤트를 전달 할 때 까지 대기한다. 컴플리티드 이벤트가 전달된 시점에 하나의 요소만 방출된 시점이라면 구독자에게 컴플리티드를 방출하고, 두개이상이라면 구독자에게 에러를 방출한다. 이런식으로 작동하며, 하나의 요소만 방출되는것을 보장한다. 
```


### distinctUntilChanged

```swift
let disposeBag = DisposeBag()
let numbers = [1, 1, 3, 2, 2, 3, 1, 5, 5, 7, 7, 7]

// 동일한 항목이 연속적으로 방출되지 않도록 필터링해주는 연산자.

Observable.from(numbers)
  .distinctUntilChanged()
  .subscribe {print($0)}
  .disposed(by: disposeBag)


// distinctUntilChanged -> 파라미터가 없다. 원본옵져버블에서 전달되는 두개의 요소를 비교해서 이전요소와 같다면 방출하지 않는다. 즉 앞에꺼랑 비교해서 같으면 무시, 다르면 방출한다. 1,3,2,3,1,5,7
```


### debounce

```swift
let disposeBag = DisposeBag()

// debounce와 throttle은 짧은시간동안 반복적으로 방출되는 이벤트를 제어한다는 공통점이 있다.
// 연산자로 전달하는 파람도 동일하다. 하지만 연산의 결과는 다르다.

// debounce -> 두개의 파람을 받는다.
// 1. 시간을 전달한다. 이시간은 연산자가 넥스트이벤트를 방출할지 결정하는 조건으로 사용된다. 옵져버가 넥스트를 방출한 후, 지정된 시간동안 다른 넥스트이벤트를 방출하지 않는다면, 해당 시점에 가장마지막으로 방출된 넥스트이벤트를 구독자에게 전달한다. 반대로 지정된 시간 이내에 또다른 넥스트가 방출된다면, 타이머를 초기화한다. 이부분을 이해하는게 정말 중요하다.
// 2. 타이머를 실행할 스케쥴러를 전달한다.

let buttonTap = Observable<String>.create { observer in
  DispatchQueue.global().async {
    for i in 1...10 {
      observer.onNext("Tap \(i)")
      Thread.sleep(forTimeInterval: 0.3)
    }
    
    Thread.sleep(forTimeInterval: 1)
    
    for i in 11...20 {
      observer.onNext("Tap \(i)")
      Thread.sleep(forTimeInterval: 0.5)
    }
    
    observer.onCompleted()
  }
  
  return Disposables.create {
    
  }
}

buttonTap
  .debounce(.milliseconds(499), scheduler: MainScheduler.instance)
  .subscribe { print($0) }
  .disposed(by: disposeBag)

// .milliseconds(1000) [1초] 를 넣으면 10, 20 나오고 컴플리트
// .milliseconds(400) [0.4초] 를 넣으면 10, 11, 12...20 후 컴플리트, 설정한 0.5초보다 짧기때문이다.
// 주로 검색 기능을 만들때 사용한다. 문자가 입력될때마다 작업을 실행하는것은 효율적이지 않다. 
```


### throttle

```swift
let disposeBag = DisposeBag()

// debounce와 throttle은 짧은시간동안 반복적으로 방출되는 이벤트를 제어한다는 공통점이 있다.
// throttle -> 실제로는 3개의 파람을 받는다. (기본값을 가진 2번째 파람은 생략가능)
// 1. 반복주기를 전달, 3. 스케쥴러를 전달.
// 지정된 주기동안 하나의 이벤트만 구독자에게 전달한다. 보통 두번째 파람은 기본값을 사용하는데, 이때는 주기를 엄격하게 지킨다. 항상 지정된 주기마다 하나씩 이벤트를 전달한다.
// 반대로 두번째 파람에 false를 주면 반복주기가 경과한 다음, 가장 먼저 방출되는 이벤트를 구독자에게 전달한다.

let buttonTap = Observable<String>.create { observer in
  DispatchQueue.global().async {
    for i in 1...10 {
      observer.onNext("Tap \(i)")
      Thread.sleep(forTimeInterval: 0.3)
    }
    
    Thread.sleep(forTimeInterval: 1)
    
    for i in 11...20 {
      observer.onNext("Tap \(i)")
      Thread.sleep(forTimeInterval: 0.5)
    }
    
    observer.onCompleted()
  }
  
  return Disposables.create()
}


buttonTap
  .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
  .subscribe { print($0) }
  .disposed(by: disposeBag)

// .milliseconds(1000)


// throttle은 넥스트이벤트를 지정된 주기마다 하나씩 구독자에게 전달한다.
// 짧은시간동안 반복되는 탭 이벤트나 델리게이트 메시지를 처리할때 주로 사용한다.
```


```swift
let disposeBag = DisposeBag()

// 두번째 파람값에 따른 결과 비교

func currentTimeString() -> String {
  let f = DateFormatter()
  f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
  return f.string(from: Date())
}


//Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//  .debug()
//  .take(10)
//  .throttle(.milliseconds(2500), latest: true, scheduler: MainScheduler.instance)
//  .subscribe { print(currentTimeString(), $0) }
//  .disposed(by: disposeBag)
// 두번째 파람을 true로 한다면, 주기를 정확히 지킨다.

/*
 2021-01-12 00:51:58.751: 2.xcplaygroundpage:45 (__lldb_expr_77) -> subscribed
 2021-01-12 00:51:59.774: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(0)
 2021-01-12 00:51:59.775 next(0)
 2021-01-12 00:52:00.774: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(1)
 2021-01-12 00:52:01.775: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(2)
 2021-01-12 00:52:02.278 next(2)
 2021-01-12 00:52:02.775: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(3)
 2021-01-12 00:52:03.774: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(4)
 2021-01-12 00:52:04.775: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(5)
 2021-01-12 00:52:04.780 next(5)
 2021-01-12 00:52:05.775: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(6)
 2021-01-12 00:52:06.774: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(7)
 2021-01-12 00:52:07.281 next(7)
 2021-01-12 00:52:07.774: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(8)
 2021-01-12 00:52:08.774: 2.xcplaygroundpage:45 (__lldb_expr_77) -> Event next(9)
 2021-01-12 00:52:08.774: 2.xcplaygroundpage:45 (__lldb_expr_77) -> isDisposed
 2021-01-12 00:52:09.782 next(9)
 2021-01-12 00:52:09.783 completed
 */

Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
   .debug()
   .take(10)
   .throttle(.milliseconds(2500), latest: false, scheduler: MainScheduler.instance)
   .subscribe { print(currentTimeString(), $0) }
   .disposed(by: disposeBag)
// 구독자로 전달된 첫번째와 2번째를 시간을 비교하면 3초이다. 넥스트이벤트가 방출되고 지정된 주기가 지나고 그 이후에 첫번째로 방출되는 넥스트이벤트를 전달한다. 첫번째 넥스트이벤트는 구독자에게 바로 전달된다. 이어서 원본옵져버블이 1과 2를 방출하고 0.5초후에 주기가 끝나는데 두번째 파람으로 true를 줬다면 마지막에 방출된 넥스트 이벤트가 구독자에게 전달되었겠지만, 이번에는 false라서 원본옵져버블이 새로운 넥스트이벤트를 방출할 때 까지 기다린다. 0.5초뒤 3이라는 넥스트이벤트가 나타다면 3을 구독자에게 전달한다.
// 지정된 주기동안 하나의 넥스트이벤트만 전달하는건 다르지 않다. 차이는 넥스트이벤트가 구독자로 전달되는 주기이다. true면 주기를 엄격히 지키지만, false라면 지정된 주기를 초과할 수 있다.

/*
 2021-01-12 01:01:39.227: 2.xcplaygroundpage:74 (__lldb_expr_92) -> subscribed
 2021-01-12 01:01:40.230: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(0)
 2021-01-12 01:01:40.231 next(0)
 2021-01-12 01:01:41.229: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(1)
 2021-01-12 01:01:42.228: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(2)
 2021-01-12 01:01:43.228: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(3)
 2021-01-12 01:01:43.228 next(3)
 2021-01-12 01:01:44.229: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(4)
 2021-01-12 01:01:45.228: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(5)
 2021-01-12 01:01:46.229: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(6)
 2021-01-12 01:01:46.230 next(6)
 2021-01-12 01:01:47.229: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(7)
 2021-01-12 01:01:48.229: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(8)
 2021-01-12 01:01:49.229: 2.xcplaygroundpage:74 (__lldb_expr_92) -> Event next(9)
 2021-01-12 01:01:49.230 next(9)
 2021-01-12 01:01:49.231 completed
 2021-01-12 01:01:49.231: 2.xcplaygroundpage:74 (__lldb_expr_92) -> isDisposed
 */
```
