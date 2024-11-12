import sqlite3

def dict_factory(cursor, row):
 fields = []
 # Extract column names from cursor description
 for column in cursor.description:
    fields.append(column[0])

 # Create a dictionary where keys are column names and values are row values
 result_dict = {}
 for i in range(len(fields)):
    result_dict[fields[i]] = row[i]

 return result_dict

class Planner:
    def __init__(self,filename):
        #connect to DB file
        self.connection = sqlite3.connect(filename)
        self.connection.row_factory = dict_factory
        #use the connection instance to perform db operations
        #create a cursor insaance for the connection
        self.cursor = self.connection.cursor()    


    def getHomework(self):
        #now that we have an acess point we can fetch all of or one
        #ONLY applicable use of fetch is following a select query
        self.cursor.execute("SELECT * FROM planner")
        #goes and gets an array 
        homework = self.cursor.fetchall()
        # print("rollercoasters:",rollercoasters)
        return homework
    

    def getSingleHomework(self,homework_id):
        data = [homework_id]
        self.cursor.execute("SELECT * FROM planner WHERE id = ?",data)
        #goes and gets an array 
        homework = self.cursor.fetchone()
        return homework
    
    def createHomework(self, name, date, desc, course, notes):
        data = [name, date, desc, course, notes]
        #add a new rollercoaster to ur db
        self.cursor.execute("INSERT INTO planner (name,date, desc, course, notes) VALUES (?,?,?,?,?)", data)
        self.connection.commit() #saves the insert
        return
    
    def updateHomework(self,homework_id,name,date,desc,course,notes):
       data = [name,date,desc,course,notes,homework_id]
       self.cursor.execute("UPDATE planner set name = ?, date = ?, desc = ?, course = ?, notes = ? WHERE id = ?", data)
       self.connection.commit()
       return
    
    def deleteHomework(self,homework_id):
       data = [homework_id]
       self.cursor.execute("DELETE FROM `planner` WHERE (`rowid` IN (?))", data)
       self.connection.commit()
       return
       

    def createUser(self,first_name, last_name, email, password):
        data = [first_name, last_name, email, password]

        self.cursor.execute("INSERT INTO users (first_name, last_name, email, password) VALUES (?,?,?,?)", data)
        self.connection.commit() #saves the insert
        return