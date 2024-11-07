from flask import Flask, request
from planner import Planner


app = Flask(__name__)


@app.route("/backend/homework/<int:homework_id>",methods=["OPTIONS"])
def handle_cors_options(homework_id):
    return "",204,{
        "Access-Control-Allow-Origin":"*",
        "Access-Control-Allow-Methods":"DELETE,PUT",
        "Access-Control-Allow-Headers":"Content-Type"
    }


@app.route("/backend/homework", methods=["GET"])
def retrieve_homework():
    db = Planner("planner_db.db")
    homework = db.getHomework()
    return homework, 200, {"Access-Control-Allow-Origin":"*"}

@app.route("/backend/homework/<int:homework_id>",methods=["GET"])
def retrieveSingleHomework(homework_id):
    db = Planner("planner_db.db")
    homework = db.getSingleHomework(homework_id)
    return homework, 200, {"Access-Control-Allow-Origin":"*"}

@app.route("/backend/homework", methods=["POST"])
def create_homework():
    db = Planner("planner_db.db")
    name = request.form["name"]
    date = request.form["date"]
    desc = request.form["desc"]
    course = request.form["course"]
    notes = request.form["notes"]
    db.createHomework(name,date,desc,course,notes)
    return "Created", 201, {"Access-Control-Allow-Origin":"*"}

@app.route("/backend/homework/<int:homework_id>",methods=["PUT"]) 
def update_homework(homework_id):
    db = Planner("planner_db.db")
    homework = db.getSingleHomework(homework_id)
    print("homework",homework)
    if homework: 
        print("update homework with ID", homework_id)
        name = request.form["name"]
        date = request.form["date"]
        desc = request.form["desc"]
        course = request.form["course"]
        notes = request.form["notes"]

        db.updateHomework(homework_id,name,date,desc,course,notes)
        return "Update", 200, {"Access-Control-Allow-Origin":"*"}
    else:
        return f"Homework {homework_id}  not found", 404, {"Access-Control-Allow-Origin":"*"}
    
@app.route("/backend/homework/<int:homework_id>",methods=["DELETE"])
def delete_homework(homework_id):
    db = Planner("planner_db.db")
    homework = db.getSingleHomework(homework_id)
    print("homework_id",homework)
    print("deleted homework with ID:",homework_id)
    if homework:
        db.deleteHomework(homework_id)
        return "Deleted", 200,{"Access-Control-Allow-Origin":"*"}
    else:
        return f"Homework {homework_id} not found", 404, {"Access-Control-Allow-Origin":"*"}


def run():
    app.run(port=8080, host='0.0.0.0')

if __name__ == "__main__":
    run()