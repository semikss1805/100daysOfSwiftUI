import UIKit

func fibonachi(max: Int, arr: [Int] = [0, 1]) {
    var arr = arr
    var nextNum: Int {
        arr[arr.count - 1] + arr[arr.count - 2]
    }
    
    if nextNum <= max {
        arr.append(nextNum)
        fibonachi(max: max, arr: arr)
    } else {
        print(arr)
    }
}

fibonachi(max: 15)
