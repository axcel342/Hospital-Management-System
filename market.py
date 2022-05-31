# from multiprocessing import connection
from flask import Flask, render_template, request, redirect, flash, url_for
import pyodbc
# from model import cursor,conn
app = Flask(__name__)

app.config['SECRET_KEY'] = '65d7a2d001a0a36fd0f4047d'

#database connection
def connection():
    s = 'DESKTOP-TFLO8N0'
    d = 'newhospital1' 
    u = 'sa'
    p = '12345678'
    cstr = 'DRIVER={ODBC Driver 17 for SQL Server};SERVER=' + s + ';DATABASE=' + d + ';UID=' + u + ';PWD=' + p
    conn = pyodbc.connect(cstr)
    return conn

     

@app.route('/')
@app.route('/home')
def home_page():
    return render_template('home.html')

# These were test functions not included in project
# @app.route('/market')
# def market_page():
#     items = [
#          {'id': 1, 'name': 'Phone', 'barcode': '893212299897', 'price': 500},
#         {'id': 2, 'name': 'Laptop', 'barcode': '123985473165', 'price': 900},
#         {'id': 3, 'name': 'Keyboard', 'barcode': '231985128446', 'price': 150}

#     ]
#     return render_template('market.html', items=items)    

# @app.route('/test')
# def testing():
#     items = []
#     conn = connection()
#     cursor = conn.cursor()
#     cursor.execute('SELECT * FROM dbo.items')
#     for row in cursor:
#         items.append({'id': row[0],'quantity': row[1] ,'name': row[2]})
#     conn.close()
#     return render_template('test.html' , items = items)

# @app.route("/addpatient", methods = ['GET','POST'])
# def addpatient():
#     if request.method == 'GET':
#         return render_template("add_patient.html")
#     if request.method == 'POST':
#         id = int(request.form["id"])
#         name = request.form["name"]
#         cnic = str(request.form["cnic"])
#         phoneNumber = str(request.form["phoneNumber"])
#         age = int(request.form["age"])
#         email = str(request.form["email"])
#         admitted = str(request.form["admitted"])
#         patientAddress = str(request.form["patientAddress"])
#         appointmentNo = int(request.form["appointmentNo"])
#         Dues = int(request.form["Dues"])
#         password = str(request.form["password"])    
#         conn = connection()
#         cursor = conn.cursor()
#         cursor.execute("INSERT INTO dbo.Patient (id, name, cnic, phoneNumber, age, email, admitted, patientAddress, appointmentNo, Dues, password) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", id, name, cnic, phoneNumber, age, email, admitted, patientAddress, appointmentNo, Dues, password)
#         conn.commit()
#         conn.close()
#         return redirect('/')

@app.route("/addpatient_p", methods = ['GET','POST'])
def addpatient_procedures():
    if request.method == 'GET':
        return render_template("add_patient_p.html")
    if request.method == 'POST':
        name = request.form["name"]
        cnic = str(request.form["cnic"])
        phoneNumber = str(request.form["phoneNumber"])
        age = str(request.form["age"])
        email = str(request.form["email"])
        patientAddress = str(request.form["patientAddress"])
        appointmentNo = int(request.form["appointmentNo"])
        password = int(request.form["password"])
        params = (name, cnic, phoneNumber, age, email, patientAddress, appointmentNo, password)    
        conn = connection()
        cursor = conn.cursor()
        cursor.execute('exec SignupPatient @name = ?, @cnic = ?, @phno = ?, @age = ?, @email = ?, @add = ?, @pass = ?, @appno = ? ', (params))
        conn.commit()
        conn.close()
        return redirect('/')

@app.route("/add_doctor", methods = ['GET','POST'])
def adddoctor_procedures():
    if request.method == 'GET':
        return render_template("add_doctor.html")
    if request.method == 'POST':
        name = request.form["name"]
        cnic = str(request.form["cnic"])
        phoneNumber = str(request.form["phoneNumber"])
        age = str(request.form["age"])
        email = str(request.form["email"])
        room = int(request.form["room"])
        dept = str(request.form["dept"])
        time = str(request.form["time"])
        gender = str(request.form["gender"])
        password = int(request.form["password"])
        params = (name, cnic, phoneNumber, age, email, room, dept, time, gender,password)    
        conn = connection()
        cursor = conn.cursor()
        cursor.execute('exec SignupDoctor @name = ?, @cnic = ?, @phno = ?, @age = ?, @email = ?, @room = ?, @dept = ?, @time = ?, @gender = ?, @password = ? ', (params))
        conn.commit()
        conn.close()
        return redirect('/')    

@app.route("/login_doctor", methods = ['GET','POST'])
def login_doctor():
    if request.method == 'GET':
        return render_template("login_doctor.html")
    if request.method == 'POST':
        userid = int(request.form["userid"])
        password = str(request.form["password"])
        sql = """\
        DECLARE @out int;
        exec LoginDoctor @id = ?, @password = ?,  @flag = @out output
        SELECT @out AS return_value
        """
        params = (userid, password)
        conn = connection()
        cursor = conn.cursor()
        try:
            cursor.execute(sql, params)
            return_value = cursor.fetchval()

        except:
            flash("Error incorrect username or password please try again")
            return redirect('/login_patient')  

        conn.commit()
        conn.close()

        # print(return_value)
       
        if(return_value == 1):
            return render_template('doctor.html') 


@app.route("/login_patient", methods = ['GET','POST'])
def login_patient():
    if request.method == 'GET':
        return render_template("login_patient.html")
    if request.method == 'POST':
        userid = int(request.form["userid"])
        password = str(request.form["password"])
        sql = """\
        DECLARE @out int;
        exec LoginPatient @id = ?, @password = ?,  @flag = @out output
        SELECT @out AS return_value
        """
        params = (userid, password)
        conn = connection()
        cursor = conn.cursor()
        try:
            cursor.execute(sql, params)
            return_value = cursor.fetchval()

        except:
            flash("Error incorrect username or password please try again")
            return redirect('/login_patient')  

        conn.commit()
        conn.close()

        # print(return_value)

        if(return_value == 1):
            return render_template('patient.html') 


@app.route('/signup')
def signup_page():
    return render_template('First_page.html')   

@app.route('/pharmacy')
def pharmacy_page():
    return render_template('pharmacy.html')    
    
@app.route('/laboratory')
def laboratory_page():
    return render_template('laboratory.html')     

@app.route('/patient')
def patient_menu():
    return render_template('patient.html')

@app.route('/EHR')
def ehr_patient():
    return render_template('EHR.html')    


if __name__=='__main__':
    app.run()

