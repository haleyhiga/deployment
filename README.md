# Planner

## Resource

**Planner**

Attributes:

* name (string)
* date (string)
* desc (string)
* course (string)
* notes (string)

## Schema

```sql
CREATE TABLE planner (
id INTEGER PRIMARY KEY,
name TEXT,
date TEXT,
desc TEXT,
course TEXT,
notes TEXT);
```

## REST Endpoints

Name                           | Method | Path
-------------------------------|--------|------------------
Retrieve homework collection | GET    | /homework
Retrieve homework member     | GET    | /homework/<int:homework_id>
Create homework member       | POST   | /homework
Update homework member       | PUT    | /homework/<int:homework_id>
Delete homework member       | DELETE | /homework/<int:homework_id>
Handle Cors                  | OPTIONS | /homework/<int:homework_id>
