// task 1
db.employees.find({}, {"salary":0, "_id":0})

// task 2
db.departments.insertMany([
{"dept_id":10,"dept_name":"ADMINISTRATION","address":"GRAND AVE 2"},
{"dept_id":20,"dept_name":"DISTRIBUTED SYSTEMS","address":"GRAND AVE 3"},
{"dept_id":30,"dept_name":"EXPERT SYSTEMS","address":"47TH STR"},
{"dept_id":40,"dept_name":"ALGORITHMS","address":"45TH STR"},
{"dept_id":50,"dept_name":"OPERATIONAL RESEARCH","address":"PLAINFIELD ROAD"}
])

// task 3
db.employees.find({"job":"PROFESSOR"}, {"surname":1, "_id":0})
db.employees.find({"job":"PROFESSOR"}, {"surname":0, "_id":0})
// the difference is that in the first one surname is visible but in the second not
db.employees.find({"job":"PROFESSOR"}, {"surname":1, "salary":0})
// this command throws error 

// task 4
db.employees.find({$or:[{"job":"ASSISTANT"}, {"salary":{$gt:2800, $lt:3300}}]}, 
{"_id":0, "surname":1, "job":1, "salary":1})
    
// tast 5
db.employees.find({"salary":{$gt:1500}}, 
{"_id":0, "surname":1, "job":1, "salary":1}).sort({"job":1, "salary":-1})

// task 6
db.employees.find(
    {"dept_id":20},
    {"_id":0, "surname":1, "salary":1}
).sort(
    {"salary":-1}
).skip(1).limit(1)

// task 7
db.employees.find(
    {$and:[
        {"dept_id":{$in:[20,30]}}, 
        {"surname":{$regex:"s$"}},
        {"job":{$ne:"ASSISTANT"}}
        ]
    },
    {"_id":0, "surname":1, "job":1}
)
    
// task 8
db.employees.aggregate([
    {$sort: { "salary":-1} },
    {$skip : 2},
    {$limit: 1},
    {$project:{
        "_id":0,
        "job":"$job",
        "surname":"$surname",
        "hire_date":{$year:"$hire_date"}
        }
    }
])
    
// task 9
db.employees.aggregate([
    {$group: {
        _id:"$dept_id",
        employees_count:{$sum: 1}
        }
    },
    {$match: {
        employees_count:{$gt:2}
        }
    }
])
    
// task 10
db.employees.aggregate([
    {$lookup: {
        from: "departments",
        localField: "dept_id",
        foreignField: "dept_id",
        as: "emp_department"
    }},
    {$match: {
        "dept_id": {$in: [20, 30]}
    }},
    {$project: {
        "_id": 0,
        "surname": 1,
        "dept": {$arrayElemAt: ["$emp_department.address", 0]}
    }}
])

// task 11
db.employees.aggregate([
    {$lookup: {
        from: "departments",
        localField: "dept_id",
        foreignField: "dept_id",
        as: "emp_department",
    }},
    {$match: {
        "emp_department.address": {$regex: "GRAND AVE"}
    }},
    {$project: {
        "_id": 0,
        "surname": 1,
        "dept": {$arrayElemAt: ["$emp_department.dept_name", 0]}
    }}
])

// task 12
db.employees.aggregate([
    {$lookup: {
        from: "departments",
        localField: "dept_id",
        foreignField: "dept_id",
        as: "emp_department",
    }},
    {$group: {
        "_id": {$arrayElemAt: ["$emp_department.dept_name", 0]},
        "count": {$sum: 1}
    }}
])

// task 13
var employees = db.employees.find();
while (employees.hasNext()) {
    emp = employees.next();
    if (emp.dept_id) {
        dept = db.departments.findOne({"dept_id": emp.dept_id});
        db.employees.update(
            {"dept_id": dept.dept_id},
            {$set: {dept_id: dept._id}}
        )
    }
}

// task 14
db.products.find(
    {"ratings.person": {$nin: ["Ann", "Carol"]}},
    {"name": 1, "_id": 0}
)

// task 15
db.products.aggregate([
    {$unwind: "$ratings"},
    {$group: {
        _id: "$name",
        avg_rating: {$avg: "$ratings.value"}
    }},
    {$project: {
        "_id": 0,
        "product": "$_id",
        "avg_rating": 1
    }},
    {$sort: {"avg_rating": -1}},
    {$limit: 1}
])

// task 16
db.products.updateOne(
    {"name": "Electric mower"},
    {$push: {ratings: {"person": "Ann", "value": 4}}}
)

// task 17
db.products.find({$and: [
    {"ratings": {$elemMatch: {"person": "Ann", "value": 4}}},
    {"ratings": {$not: {$elemMatch: {"person": {$not: {$eq: "Ann"}}, "value": 4}}}}
]},
{"name": 1, "_id": 0})

// task 18
db.products.update(
    {},
    {$pull: {"ratings": {"value": {$lt: 3}}}}

    