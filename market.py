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



@app.route("/addpatient", methods = ['GET','POST'])
def addpatient():
    if request.method == 'GET':
        return render_template("add_patient_p.html")
    if request.method == 'POST':
        try: 
            name = request.form["name"]
            cnic = str(request.form["cnic"])
            phoneNumber = str(request.form["phoneNumber"])
            age = int(request.form["age"])
            email = str(request.form["email"])
            patientAddress = str(request.form["patientAddress"])
            appointmentNo = int(request.form["appointmentNo"])
            password = str(request.form["password"])
            gender = str(request.form["gender"])
            params = (name, cnic, phoneNumber, age, email,patientAddress, appointmentNo,password, gender)    
            conn = connection()
            cursor = conn.cursor()        
            cursor.execute('exec SignupPatient @name = ?, @cnic = ?, @phno = ?, @age = ?, @email = ?,@add = ?,@appno = ?,@pass = ?, @gender = ? ', (params))
       
        except:
            flash("Error in Sign up please try again")
            return redirect('/addpatient')
       
        conn.commit()

        conn.close()
        flash("You have been successfully registered!")
        return redirect('/')

@app.route("/adddoctor", methods = ['GET','POST'])
def adddoctor():
    if request.method == 'GET':
        return render_template("add_doctor.html")
    if request.method == 'POST':
        try:
            name = request.form["name"]
            cnic = str(request.form["cnic"])
            phoneNumber = str(request.form["phoneNumber"])
            age = int(request.form["age"])
            email = str(request.form["email"])
            room = int(request.form["room"])
            dept = str(request.form["dept"])
            time = str(request.form["time"])
            gender = str(request.form["gender"])
            password = str(request.form["password"])
            params = (name, cnic, phoneNumber, age, email, room, dept, time, gender,password)    
            conn = connection()
            cursor = conn.cursor()
            cursor.execute('exec SignupDoctor @name = ?, @cnic = ?, @phno = ?, @age = ?, @email = ?, @room = ?, @dept = ?, @time = ?, @gender = ?, @password = ? ', (params))
       
        except:
            flash("Error in Sign up please try again")
            return redirect('/adddoctor')

        conn.commit()
        conn.close()
        flash("Doctor Added")
        return redirect('/')    

@app.route("/login_doctor", methods = ['GET','POST'])
def login_doctor():
    if request.method == 'GET':
        return render_template("login.html")
    if request.method == 'POST':
        try:
            userid = int(request.form["userid"])
            password = str(request.form["password"])
            sql = """\
            DECLARE @out int;
            exec LoginDoctor @username = ?, @password = ?,  @flag = @out output
            SELECT @out AS return_value
            """
            params = (userid, password)
            conn = connection()
            cursor = conn.cursor()
            
            cursor.execute(sql, params)
            return_value = cursor.fetchval()

        except:
            flash("Please enter a valid username or password and try again")
            return redirect('/login_doctor')  

        conn.commit()
        conn.close()

        print(return_value)
       
        if(return_value == 1):
            return render_template('doctor.html') 


@app.route("/login_patient", methods = ['GET','POST'])
def login_patient():
    if request.method == 'GET':
        return render_template("login.html")
    if request.method == 'POST':
        try:
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
            
            cursor.execute(sql, params)
            return_value = cursor.fetchval()

        except:
            flash("Please enter a valid username or password and try again")
            return redirect('/login_patient')  

        conn.commit()
        conn.close()

        # print(return_value)

        if(return_value == 1):
            return render_template('patient.html') 


@app.route("/signup_admin", methods = ['GET','POST'])
def signup_admin():
    if request.method == 'GET':
        return render_template("signup_admin.html")
    if request.method == 'POST':
        try:
            name = request.form["name"]
            cnic = str(request.form["cnic"])
            phoneNumber = str(request.form["phoneNumber"])
            age = int(request.form["age"])
            email = str(request.form["email"])
            password = str(request.form["password"])
            params = (name, cnic, phoneNumber, age, email,password)    
            conn = connection()
            cursor = conn.cursor()
            cursor.execute('exec SignupAdmin @name = ?, @cnic = ?, @phno = ?, @age = ?, @email = ?, @pass = ? ', (params))
       
        except:
            flash("Error in Sign up please try again")
            return redirect('/signup_admin')

        conn.commit()
        conn.close()
        flash("Admin Successfully Added")
        return redirect('/')        


@app.route("/login_admin", methods = ['GET','POST'])
def login_admin():
    if request.method == 'GET':
        return render_template("login.html")
    if request.method == 'POST':
        try:
            userid = int(request.form["userid"])
            password = str(request.form["password"])
            sql = """\
            DECLARE @out int;
            exec LoginAdmin @username = ?, @password = ?,  @flag = @out output
            SELECT @out AS return_value
            """
            params = (userid, password)
            conn = connection()
            cursor = conn.cursor()
            
            cursor.execute(sql, params)
            return_value = cursor.fetchval()

        except:
            flash("Please enter a valid username or password and try again")
            return redirect('/login_admin')  

        conn.commit()
        conn.close()

        # print(return_value)

        if(return_value == 1):
            return render_template('admin.html') 


################            EHR function                      ###############

@app.route('/EHR', methods = ['GET','POST'])
def ehr_patient():
    items = []
    if request.method == 'GET':
        return render_template("EHR.html")
    if request.method == 'POST':
        userid = int(request.form["userid"])
        sql = """\
                exec patient_EHR @patient_id = ?
                """

        params = (userid)
        conn = connection()
        cursor = conn.cursor()    
        cursor.execute(sql, params)
    
        for row in cursor.fetchall():
            items.append({"patient_id":row[0], "diagnosis":row[1], "testID":row[2], "medicineNo":row[3]})

        conn.close()
    return render_template('EHR.html', items = items) 


@app.route('/EHR_input', methods = ['GET','POST'])    
def ehr_patient_input():
    if request.method == 'GET':
        return render_template("add_EHR.html")
    if request.method == 'POST':
        try:
            patientid = int(request.form["patientid"])
            diagnosis = str(request.form["diagnosis"])
            testid = int(request.form["testid"])
            medicineNumber = int(request.form["medicineNumber"])
            params = (patientid,diagnosis,testid,medicineNumber)    
            conn = connection()
            cursor = conn.cursor()
            cursor.execute('exec enterEHR @patid = ?, @diag = ?, @testid = ?, @medno = ? ', (params))
       
        except:
            flash("Error in Sign up please try again")
            return redirect('/ehr_patient_input')

        conn.commit()
        conn.close()
        flash("EHR Successfully Added")
        return redirect('/EHR')        

##############                   Appointment functions                      #######################

@app.route('/search_appointment', methods = ['GET','POST'])
def search_appointment():
    items = []
    if request.method == 'GET':
        return render_template("search_appointment.html")
    if request.method == 'POST':
        try:
            userid = int(request.form["userid"])
            sql = """\
                    exec searchAppointment @patientID = ?
                    """
            params = (userid)
            conn = connection()
            cursor = conn.cursor()    
            cursor.execute(sql, params)

            for row in cursor.fetchall():
                items.append({"appointmentID":row[0], "patientName":row[1], "DoctorName":row[2], "Department":row[3], "appointmentTime":row[4] })
             
        except:
            flash("Error Please enter a valid appointment number and try again")
            return redirect('/search_appointment')

        conn.close()
    return render_template('search_appointment.html', items = items) 

@app.route('/make_appointment', methods = ['GET','POST'])    
def make_appointment():
    if request.method == 'GET':
        return render_template("make_appointment.html")
    if request.method == 'POST':
        try:
            patientid = int(request.form["patientid"])
            doctorID = int(request.form["doctorID"])
            patientName = str(request.form["patientName"])
            phoneNo = str(request.form["phoneNo"])
            dept = str(request.form["dept"])
            time = str(request.form["time"])
            params = (patientid,doctorID,patientName,phoneNo,dept,time)    
            conn = connection()
            cursor = conn.cursor()
            cursor.execute('exec makeAppointment @patientid = ?, @doctorID = ?, @patientName = ?, @phoneNo = ?, @dept = ?, @time = ? ', (params))
       
        except:
            flash("Error enter valid enteries please try again")
            return redirect('/make_appointment')

        conn.commit()
        conn.close()
        flash("Appointment Successfully Added")
        return redirect('/search_appointment') 

@app.route('/remove_appointment',methods = ['GET','POST'])
def remove_appointment():
    if request.method == 'GET':
        try:
            items = []
            conn = connection()
            cursor = conn.cursor()
            cursor.execute('exec viewAppointments')  

            for row in cursor.fetchall():
                items.append({"appointmentid":row[0], "doctorID":row[1], "patientID":row[2], "appointmentTime":row[3], "patientName":row[4], "patientPhone":row[5], "departmentid":row[6]})

        except:
            flash("Connection Error")
            return redirect('/remove_appointment') 

        conn.close()
        return render_template('remove_appointment.html', items = items) 
    if request.method == 'POST':
        try:
            id = int(request.form["id"])
            params = (id)    
            conn1 = connection()
            cursor1 = conn1.cursor()
            cursor1.execute('exec deleteAppointment @id = ? ', (params))
       
        except:
            flash("Error enter valid id please try again")
            return redirect('/remove_appointment')

        conn1.commit()
        conn1.close()
        flash("Appointment Successfully Removed")
        return redirect('/remove_appointment') 




#################                   Pharmacy Functions                          ######################
@app.route('/pharmacy',methods = ['GET'])
def pharmacy_page():
    items = []
    try:
        conn = connection()
        cursor = conn.cursor()
        cursor.execute('exec viewpharmacy')
        for row in cursor.fetchall():
            items.append({"medicineNo":row[0], "medicineName":row[1], "expiry":row[2], "quantity":row[3], "price":row[4]})
    except:
        flash('Error in connection')
    conn.close()  
    return render_template('pharmacy.html', items = items)    

@app.route('/addmedicine', methods = ['GET', 'POST'])
def addmedicine():
    if request.method == 'GET':
        try:
            items = []
            conn = connection()
            cursor = conn.cursor()
            cursor.execute('exec viewpharmacy')  

            for row in cursor.fetchall():
                items.append({"medicineNo":row[0], "medicineName":row[1], "expiry":row[2], "quantity":row[3], "price":row[4]})
        except:
            flash('Error in connection')
            conn.close()  
            return redirect('/addmedicine')

        conn.close()
        return render_template('addmedicine.html', items = items) 


    if request.method == 'POST':
        try:
            medicineNo = int(request.form["medicineNo"])
            medicineName = str(request.form["medicineName"])
            expiry = str(request.form["expiry"])
            quantity = int(request.form["quantity"])
            price = int(request.form["price"])
            params = (medicineNo, medicineName, expiry, quantity, price)    
            conn1 = connection()
            cursor1 = conn1.cursor()
            cursor1.execute('exec Add_Medicine @medicineNo = ? ,@medicineName = ?, @expiry = ?, @quantity = ?, @price = ? ', (params))
       
        except:
            flash("Error enter valid id please try again")
            return redirect('/addmedicine')

        conn1.commit()
        conn1.close()
        flash("Medicine Successfully Added")
        return redirect('/addmedicine') 

@app.route('/remove_medicine', methods = ['GET', 'POST'])
def remove_medicine():
    if request.method == 'GET':
        try:
            items = []
            conn = connection()
            cursor = conn.cursor()
            cursor.execute('exec viewpharmacy')  

            for row in cursor.fetchall():
                items.append({"medicineNo":row[0], "medicineName":row[1], "expiry":row[2], "quantity":row[3], "price":row[4]})
        except:
            flash('Error in connection')
            conn.close()  
            return redirect('/remove_medicine')

        conn.close()
        return render_template('remove_medicine.html', items = items) 


    if request.method == 'POST':
        try:
            medicineNo = int(request.form["medicineNo"])
            params = (medicineNo)    
            conn1 = connection()
            cursor1 = conn1.cursor()
            cursor1.execute('exec Remove_Medicine @medicineNo = ?', (params))
       
        except:
            flash("Error enter valid id please try again")
            return redirect('/addmedicine')

        conn1.commit()
        conn1.close()
        flash("Medicine Successfully Removed")
        return redirect('/remove_medicine') 



#################                   Laboratory Functions:                       #######################

@app.route('/order_labtest', methods = ['GET','POST'])
def order_labtest():
    if request.method == 'GET':
        return render_template("order_labtest.html")
    if request.method == 'POST':
        try:
            patientid = int(request.form["patientid"])
            testTime = str(request.form["testTime"])
            params = (patientid,testTime)    
            conn = connection()
            cursor = conn.cursor()
            cursor.execute('exec labTest @patientID = ?, @testTime = ? ', (params))

        except:
            flash("Error enter valid enteries please try again")
            return redirect('/order_labtest')

        conn.commit()
        conn.close()
        flash("Lab Test Successfully Ordered")
        return redirect('/')             


@app.route('/laboratory',methods = ['GET'])
def laboratory_page():
    items = []
    try:
        conn = connection()
        cursor = conn.cursor()
        cursor.execute('exec viewtests')  

        for row in cursor.fetchall():
            items.append({"testID":row[0], "labNo":row[1], "testDescription":row[2], "amount":row[3]})
    except:
        flash('Error in connection')
    conn.close()  
    return render_template('laboratory.html', items = items)  

@app.route('/addtest',methods = ['GET','POST'])
def addtest():
    if request.method == 'GET':
        return render_template("addtest.html")
    if request.method == 'POST':
        try:
            labNo = int(request.form["labNo"])
            testDescription = str(request.form["testDescription"])
            amount = int(request.form["amount"])
            params = (labNo,testDescription,amount)    
            conn = connection()
            cursor = conn.cursor()
            cursor.execute('exec addtests @labNo = ?, @testDescription = ?, @amount = ? ', (params))
       
        except:
            flash("Error enter valid enteries please try again")
            return redirect('/addtest')

        conn.commit()
        conn.close()
        flash("labtest Successfully Added")
        return redirect('/laboratory') 
      

@app.route('/removetest',methods = ['GET','POST'])
def removetest():
    if request.method == 'GET':
        return render_template("removetest.html")
    if request.method == 'POST':
        try:
            testid = int(request.form["testid"])
            params = (testid)    
            conn = connection()
            cursor = conn.cursor()
            cursor.execute('exec removetests @testid = ? ', (params))
       
        except:
            flash("Error enter valid enteries please try again")
            return redirect('/removetest')

        conn.commit()
        conn.close()
        flash("labtest Successfully Removed")
        return redirect('/laboratory') 



######################                          remove doctor/patient/admin                 #################
@app.route('/removedoctor',methods = ['GET','POST'])
def removedoctor():
    if request.method == 'GET':
        try:
            items = []
            conn = connection()
            cursor = conn.cursor()
            cursor.execute('exec ViewDoctor')  

            for row in cursor.fetchall():
                items.append({"id":row[0], "name":row[1], "cnic":row[2], "phoneNumber":row[3], "age":row[4], "timings":row[5], "email":row[6], "departmentName":row[7], "gender":row[8], "roomNo":row[9], "password":row[10]})
        except:
            flash('Error in connection')
            conn.close()  
            return redirect('/removedoctor')

        conn.close()
        return render_template('removedoctor.html', items = items) 


    if request.method == 'POST':
        try:
            id = int(request.form["id"])
            params = (id)    
            conn1 = connection()
            cursor1 = conn1.cursor()
            cursor1.execute('exec DeleteDoctor @id = ?', (params))
       
        except:
            flash("Error enter valid id please try again")
            return redirect('/removedoctor')

        conn1.commit()
        conn1.close()
        flash("Doctor Successfully Removed")
        return redirect('/removedoctor')     


@app.route('/removepatient',methods = ['GET','POST'])
def removepatient():
    if request.method == 'GET':
        try:
            items = []
            conn = connection()
            cursor = conn.cursor()
            cursor.execute('exec viewpatient')  

            for row in cursor.fetchall():
                items.append({"id":row[0], "name":row[1], "cnic":row[2], "phoneNumber":row[3], "age":row[4], "email":row[5], "admitted":row[6], "patientAddress":row[7], "appointmentNo":row[8], "Dues":row[9], "password":row[10], "gender":row[11]})
        except:
            flash('Error in connection')
            conn.close()  
            return redirect('/removepatient')

        conn.close()
        return render_template('removepatient.html', items = items) 


    if request.method == 'POST':
        try:
            id = int(request.form["id"])
            params = (id)    
            conn1 = connection()
            cursor1 = conn1.cursor()
            cursor1.execute('exec DeletePatient @id = ?', (params))
       
        except:
            flash("Error enter valid id please try again")
            return redirect('/removepatient')

        conn1.commit()
        conn1.close()
        flash("Patient Successfully Removed")
        return redirect('/removepatient') 


@app.route('/remove_admin',methods = ['GET','POST'])
def remove_admin():
    if request.method == 'GET':
        try:
            items = []
            conn = connection()
            cursor = conn.cursor()
            cursor.execute('exec viewAdmin')  

            for row in cursor.fetchall():
                items.append({"id":row[0], "name":row[1], "cnic":row[2], "phoneNumber":row[3], "age":row[4], "email":row[5], "password":row[6]})
        except:
            flash('Error in connection')
            conn.close()  
            return redirect('/remove_admin')

        conn.close()
        return render_template('remove_admin.html', items = items) 


    if request.method == 'POST':
        try:
            id = int(request.form["id"])
            params = (id)    
            conn1 = connection()
            cursor1 = conn1.cursor()
            cursor1.execute('exec DeleteAdmin @id = ?', (params))
       
        except:
            flash("Error enter valid id please try again")
            return redirect('/remove_admin')

        conn1.commit()
        conn1.close()
        flash("Admin Successfully Removed")
        return redirect('/remove_admin') 





@app.route('/patient')
def patient_menu():
    return render_template('patient.html')






if __name__=='__main__':
    app.run()

