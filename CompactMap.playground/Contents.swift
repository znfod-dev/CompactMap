import UIKit


struct Person {
    var name:String
    var age:Int
    
    init(name:String, age:Int) {
        self.name = name
        self.age = age
    }
    init(_ dictionary:Dictionary<String, Any>) {
        self.name = dictionary["name"] as! String
        self.age = dictionary["age"] as! Int
    }
    
}
var data1Times:Double = 0
func getData1(_ label:String) -> Array<Person>! {
    let start=Date()
    guard let path = Bundle.main.url(forResource: "Person", withExtension: "plist") else {
        return nil
    }
    let data = try! Data(contentsOf: path)
    let myPlist = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! Array<Dictionary<String, Any>>
    var result = Array<Person>()
    for dictionary in myPlist {
        let person = Person.init(dictionary)
        result.append(person)
    }
    let end=Date()
    let time = start.distance(to: end)
    data1Times += time
    return result
}
var data2Times:Double = 0
func getData2(_ label:String) -> Array<Person>! {
    let start=Date()
    guard let path = Bundle.main.url(forResource: "Person", withExtension: "plist") else {
        return nil
    }
    let data = try! Data(contentsOf: path)
    let myPlist = try! PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! Array<Dictionary<String, Any>>
    let result = myPlist.compactMap { Person($0) }
    let end=Date()
    let time = start.distance(to: end)
    data2Times += time
    return result
}

let label1 = "result1"
let myQueue1 = DispatchQueue.init(label: label1)
let group1 = DispatchGroup()
for _ in 0..<1000 {
    myQueue1.async(group: group1) {
        let _ = getData1(label1)
    }
}
group1.notify(queue: myQueue1) {
    print("\(label1) END")
    print("dataTimes : \(data1Times)")
}


let label2 = "result2"
let myQueue2 = DispatchQueue.init(label: label2)
let group2 = DispatchGroup()
for _ in 0..<1000 {
    myQueue2.async(group: group2) {
        let _ = getData2(label2)
    }
}
group2.notify(queue: myQueue2) {
    print("\(label2) END")
    print("dataTimes : \(data2Times)")
}
