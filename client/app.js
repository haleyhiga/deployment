console.log("connected");
//text wrapper where all the inputs 
let plannerWrapper = document.querySelector("#planner-wrapper");
let inputHomeworkName = document.querySelector("#add-homework-name");
let inputHomeworkDate = document.querySelector("#add-homework-date");
let inputHomeworkDesc = document.querySelector("#add-homework-desc");
let inputHomeworkCourse = document.querySelector("#add-homework-course");
let inputHomeworkNotes = document.querySelector("#add-homework-notes");

let saveHomeworkButton = document.querySelector("#save-homework-button")
let addHomeworkButton = document.querySelector("#add-homework-button");

let editID = null;

// add stuff here
// add stuff here
const apiUrl = window.location.protocol === 'file:'
  ? 'http://localhost:8080/backend' // Local API server during development
  : 'http://planner.zorran.tech/backend'; // Use the Ingress path for the backend


function saveHomework(){
    console.log("Save button clicked.")
    let data = "name=" + encodeURIComponent(inputHomeworkName.value);
    data += "&date=" + encodeURIComponent(inputHomeworkDate.value);
    data += "&desc=" + encodeURIComponent(inputHomeworkDesc.value);
    data += "&course=" + encodeURIComponent(inputHomeworkCourse.value);
    data += "&notes=" + encodeURIComponent(inputHomeworkNotes.value);

    console.log("Data:",data)
    let method = "POST";
    let URL = `${apiUrl}/homework`;
    if(editID){
        method = "PUT";
        URL = `${apiUrl}/homework/${editID}`;
    }
    fetch(URL,{
        method: method,
        body: data,
        headers: {
            "Content-Type": "application/x-www-form-urlencoded"
        }
    }).then(function(response){
        console.log("New homework created",response)
        plannerWrapper.textContent = "";
        loadHomeworkFromServer()
    })
    inputHomeworkName.value = "";
    inputHomeworkDate.value = "";
    inputHomeworkDesc.value = "";
    inputHomeworkCourse.value = "";
    inputHomeworkNotes.value = "";
    editID = null; 
}


function addHomework(data){
    console.log("Added homework")
    let homeworkName = document.createElement("h3"); // this just creates the element of where the value is going to be placed
    //homeworkName.textContent = data.name;
    homeworkName.textContent = "Name: " + data.name;
    let homeworkDate = document.createElement("p");
    homeworkDate.textContent = "Due: " + data.date;
    
    let homeworkDesc = document.createElement("p");
    homeworkDesc.textContent = "Description: " + data.desc;
    let homeworkCourse = document.createElement("p");
    homeworkCourse.textContent = "Course: " + data.course;
    let homeworkNotes = document.createElement("p");
    homeworkNotes.textContent = "Notes: " + data.notes;
    let editButton = document.createElement("button");
    editButton.textContent = "Edit";
    let deleteButton = document.createElement("button")
    deleteButton.textContent = "Delete";
    deleteButton.classList.add("btn-delete"); 
    let homeworkSeperator = document.createElement("hr")
    plannerWrapper.appendChild(homeworkName); 
    plannerWrapper.appendChild(homeworkDate);    
    plannerWrapper.appendChild(homeworkDesc);    
    plannerWrapper.appendChild(homeworkCourse);    
    plannerWrapper.appendChild(homeworkNotes);    
    plannerWrapper.appendChild(editButton);
    plannerWrapper.appendChild(deleteButton);
    plannerWrapper.appendChild(homeworkSeperator);
    //when the edit button is clicked it edits the rollercoaster with that specific ID
    editButton.onclick = function(){
        console.log("homework ID: ", data.id)
        inputHomeworkName.value = data.name;
        inputHomeworkDate.value = data.date;
        inputHomeworkDesc.value = data.desc;
        inputHomeworkCourse.value = data.course;
        inputHomeworkNotes.value = data.notes;
        editID = data.id;
    }

    deleteButton.onclick = function(){

        deleteHomework(data);
}
}

function loadHomeworkFromServer() {
    fetch(`${apiUrl}/homework`)
    .then(function(response){
        response.json()
            .then(function(data){
                console.log(data);
                let homework = data;
                homework.forEach(addHomework)
            })
    })
}



function deleteHomework(data){
    console.log("delete button");
    console.log("DataID:",data)
    let URL = `${apiUrl}/homework/${data.id}`;
    if (confirm("Are you sure you want to delete?")==true) {
        fetch(URL, {
            method: "DELETE",
            headers: {
                "Content-Type": "application/x-www-form-urlencoded"
            }
        }).then(function(response){
            console.log("Delete data", response)
            plannerWrapper.textContent = "";
            loadHomeworkFromServer()
        })
    }
}


saveHomeworkButton.onclick = saveHomework;
addHomeworkButton.onclick = saveHomework;
loadHomeworkFromServer();