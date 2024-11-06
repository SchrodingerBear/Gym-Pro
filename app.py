import os
from flask import Flask, render_template, redirect, url_for, request, flash, session, jsonify
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import generate_password_hash, check_password_hash
from werkzeug.utils import secure_filename  # Import secure_filename
from datetime import datetime
from sqlalchemy import text


# Configuration
app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql+mysqlconnector://root:ktr123@localhost/gympro'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = 'your_secret_key'
app.config['UPLOAD_FOLDER'] = 'static/images'  # Folder to store uploaded images

# Initialize SQLAlchemy
db = SQLAlchemy(app)

# User model
class User(db.Model):
    __tablename__ = 'user'
    id = db.Column(db.Integer, primary_key=True)
    firstname = db.Column(db.String(50))
    lastname = db.Column(db.String(50))
    id_number = db.Column(db.String(20), unique=True)
    password = db.Column(db.String(255))
    date_of_birth = db.Column(db.Date)
    gender = db.Column(db.String(10))
    contact_number = db.Column(db.String(15))
    role = db.Column(db.String(20), default='user')
    membership_status = db.Column(db.String(50), default='active')
    next_appointment = db.Column(db.DateTime)

   #Membership
class Member(db.Model):
    __tablename__ = 'members'
    id = db.Column(db.Integer, primary_key=True)
    id_number = db.Column(db.String(50), unique=True, nullable=False)
    name = db.Column(db.String(100), nullable=False)
    email = db.Column(db.String(120), unique=True, nullable=False)
    status = db.Column(db.String(20), nullable=False)

# Appointments model
class Appointment(db.Model):
    __tablename__ = 'appointments'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    date = db.Column(db.DateTime, nullable=False)

# Equipment Borrowing model
class EquipmentBorrowing(db.Model):
    __tablename__ = 'equipment_borrowing'
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    equipment_id = db.Column(db.Integer, db.ForeignKey('inventory.id'), nullable=False)
    borrow_date = db.Column(db.DateTime, default=datetime.utcnow)
    return_date = db.Column(db.DateTime, nullable=True)

   # Inventory model
class Inventory(db.Model):
    __tablename__ = 'inventory'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)
    condition = db.Column(db.String(50), nullable=False)
    quantity = db.Column(db.Integer, default=0)
    image = db.Column(db.String(255), nullable=True)
    added_date = db.Column(db.DateTime, default=datetime.utcnow)

# Notifications model
from datetime import datetime
class Notification(db.Model):
    __tablename__ = 'notifications'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=False)
    message = db.Column(db.String(255), nullable=False)
    seen = db.Column(db.Boolean, default=False)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)  # Timestamp for notification creation

# Booking model
class Booking(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_name = db.Column(db.String(100), nullable=False)
    contact_number = db.Column(db.String(20), nullable=False)
    appointment_date = db.Column(db.Date, nullable=False)
    appointment_time = db.Column(db.Time, nullable=False)
    message = db.Column(db.Text)
    status = db.Column(db.String(20), default='pending')

# Equipment model
class Equipment(db.Model):
    __tablename__ = 'equipment'
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    name = db.Column(db.String(100), nullable=False)  # Name of the equipment
    quantity = db.Column(db.Integer, default=0)  # Available quantity of equipment
    status = db.Column(db.String(50), default='available')  # Status of the equipment (e.g., available, borrowed)

def __repr__(self):
        return f'<Equipment {self.name}>'
def borrow_equipment(user_id, equipment_id):
    # Get current equipment quantity
    result = db.session.execute(text("SELECT quantity FROM inventory WHERE id = :id"), {'id': equipment_id})
    quantity = result.fetchone()[0]
    
    if quantity and quantity > 0:
        new_quantity = quantity - 1
        
        # Update inventory quantity
        db.session.execute(text("UPDATE inventory SET quantity = :quantity WHERE id = :id"), {'quantity': new_quantity, 'id': equipment_id})
        
        # If quantity becomes 0, update availability
        if new_quantity == 0:
            db.session.execute(text("UPDATE inventory SET availability_status = 'Unavailable' WHERE id = :id"), {'id': equipment_id})
        
        # Add borrowing record
        db.session.execute(text("INSERT INTO borrowing (user_id, equipment_id) VALUES (:user_id, :equipment_id)"), {'user_id': user_id, 'equipment_id': equipment_id})
        
        # Commit changes
        db.session.commit()
        return "Borrow successful!"
    else:
        return "Item is unavailable!"

# Home route
@app.route('/home')
def home():
    return render_template('home.html')

# About route
@app.route('/about')
def about():
    return render_template('about.html')

# Contact route
@app.route('/contact')
def contact():
    return render_template('contact.html')

# Book Now route
@app.route('/book_now')
def book_now():
    if 'user_id' not in session:
        return redirect(url_for('login'))
    return render_template('book_now.html')

# Contact Support route
@app.route('/contact_support')
def contact_support():
    return render_template('contact_support.html')

# Landing page route
@app.route('/')
def landing():
    return render_template('landing.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        id_number = request.form['id_number']
        password = request.form['password']

        user = User.query.filter_by(id_number=id_number).first()
        if user and check_password_hash(user.password, password):
            session['user_id'] = user.id
            session['username'] = f"{user.firstname} {user.lastname}"
            session['role'] = user.role  # Store user role in session
            return redirect(url_for('dashboard'))
        else:
            flash('Invalid credentials, please try again.', 'error')  # Use 'error' category
            return redirect(url_for('login'))  # Ensure you're redirecting after flash
    
    return render_template('login.html')

# Signup route
@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        firstname = request.form['first_name']
        lastname = request.form['last_name']
        id_number = request.form['id_number']
        password = generate_password_hash(request.form['password'])
        date_of_birth = request.form['date_of_birth']
        gender = request.form['gender']
        contact_number = request.form['contact_no']

        # Check if the ID number already exists
        existing_user = User.query.filter_by(id_number=id_number).first()
        if existing_user:
            flash("The ID number already exists. Please double-check your ID number before signing in.", 'error')
            return render_template('signup.html')
        
        new_user = User(
            firstname=firstname,
            lastname=lastname,
            id_number=id_number,
            password=password,
            date_of_birth=date_of_birth,
            gender=gender,
            contact_number=contact_number,
            role='user',  # Assign a default role
            membership_status='active'  # Default membership status
        )
        
        try:
            db.session.add(new_user)
            db.session.commit()
            flash('Account created successfully!')
            return redirect(url_for('login'))
        except Exception as e:
            db.session.rollback()  # Rollback in case of error
            flash('An error occurred while creating the account. Please try again.')
    
    return render_template('signup.html')

# Admin Dashboard route
@app.route('/admin/data')
def admin_data():
    # Ensure only admins can access this route
    if 'user_id' in session and session.get('role') == 'admin':
        total_members = User.query.count()  # Count of total members
        total_bookings = Booking.query.count()  # Count of total bookings
        total_equipment = Equipment.query.count()  # Count of total equipment
        
        # Return data as JSON
        return jsonify({
            'total_members': total_members,
            'total_bookings': total_bookings,
            'total_equipment': total_equipment
        })
    else:
        return jsonify({'error': 'Unauthorized access'}), 403

@app.route('/admin')
def admin_dashboard():
    print("Admin Dashboard accessed")  # Debug statement
    # Check if user is logged in and is an admin
    if 'user_id' in session and session.get('role') == 'admin':
        return render_template('admin_dashboard.html')
    else:
        return "Unauthorized", 403  # Or redirect to login

@app.route('/admin/graph-data')
def graph_data():
    # Fetch visit data from the 'visits' table using SQLAlchemy
    result = db.session.execute(
        "SELECT month, COUNT(*) as visits FROM visits GROUP BY month"
    )
    rows = result.fetchall()

    # Prepare the data for the graph in JSON format
    data = {
        'labels': [row['month'] for row in rows],
        'visits': [row['visits'] for row in rows]
    }

    return jsonify(data)

# Flask route to serve user dashboard
@app.route('/user')
def user_dashboard():
    if 'user_id' in session and session.get('role') == 'user':
        user = db.session.get(User, session['user_id'])  # Fetching user
        if user:  # Check if user exists
            return render_template('user_dashboard.html', user=user)
        else:
            flash('User not found.')
            return redirect(url_for('login'))
    else:
        flash('Access denied. Users only.')
        return redirect(url_for('login'))

# API route to serve real-time dashboard info
@app.route('/api/data')
def get_dashboard_data():
    if 'user_id' in session and session.get('role') == 'user':
        try:
            total_members = User.query.count()
            upcoming_appointments = Appointment.query.filter_by(user_id=session['user_id']).count()
            borrowed_equipment = EquipmentBorrowing.query.filter_by(user_id=session['user_id']).count()
            notifications = Notification.query.filter_by(user_id=session['user_id']).count()

            return jsonify({
                'total_members': total_members,
                'upcoming_appointments': upcoming_appointments,
                'borrowed_equipment': borrowed_equipment,
                'notifications': notifications
            })

        except Exception as e:
            print(f"Error occurred: {str(e)}")  # Log the error
            return jsonify({'error': str(e)}), 500
    else:
        return jsonify({'error': 'Unauthorized access'}), 403

# Dashboard route
@app.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    # Redirect to user dashboard or admin dashboard based on role
    if session.get('role') == 'admin':
        return redirect(url_for('admin_dashboard'))
    return redirect(url_for('user_dashboard'))


# API for user notifications
@app.route('/api/user/notifications')
def get_user_notifications():
    if 'user_id' not in session:
        return jsonify({'error': 'User not logged in'}), 403
    
    user_id = session['user_id']
    notifications = Notification.query.filter_by(user_id=user_id).all()
    notification_data = [{'message': notification.message, 'seen': notification.seen} for notification in notifications]

    return jsonify(notification_data)

# API for members
# API for members (excluding admins)
@app.route('/api/members', methods=['GET'])
def get_members():
    if 'user_id' not in session:
        return jsonify({'error': 'Unauthorized access'}), 401

    # Exclude users with the role of 'admin'
    members = User.query.filter(User.role != 'admin').all()
    
    member_list = [
        {
            'id': member.id_number,
            'name': f"{member.firstname} {member.lastname}",
            'contact': member.contact_number,
            'dob': member.date_of_birth.strftime('%Y/%m/%d') if member.date_of_birth else None,
            'gender': member.gender
        }
        for member in members
    ]
    return jsonify(member_list)

# Admin Membership route
# Admin Membership route (excluding admins from the membership list)
@app.route('/admin/membership')
def admin_membership():
    if 'user_id' in session and session.get('role') == 'admin':
        # Only show users where role is not 'admin'
        members = User.query.filter(User.role != 'admin').all()
        return render_template('admin_membership.html', members=members)
    else:
        flash('Access denied. Admins only.')
        return redirect(url_for('login'))

# Route to fetch members data
# Route to fetch members data (excluding admins)
@app.route('/admin/members', methods=['GET'])
def fetch_members():
    members = User.query.filter(User.role != 'admin').all()  # Adjusted to use 'role'
    members_data = [
        {
            'id': member.id,
            'name': f"{member.firstname} {member.lastname}",
            'email': member.email,
            'status': member.status  # Assuming 'status' exists
        } for member in members
    ]
    return jsonify(members_data)

@app.route('/admin/delete/<int:id>', methods=['POST'])
def delete_member(id):
    member = Member.query.get(id)
    if member:
        db.session.delete(member)
        db.session.commit()
    return redirect(url_for('admin_membership'))

@app.route('/admin/edit/<int:id>', methods=['POST'])
def edit_member(id):
    member = Member.query.get(id)
    if member:
        member.name = request.form['name']
        member.email = request.form['email']
        member.status = request.form['status']
        db.session.commit()
    return redirect(url_for('admin_membership'))

# Admin Calendar route
@app.route('/admin/calendar')
def admin_calendar():
    if 'user_id' in session and session.get('role') == 'admin':
        return render_template('admin_calendar.html')
    else:
        flash('Access denied. Admins only.')
        return redirect(url_for('login'))

# Admin Booking route
@app.route('/admin_booking')
def admin_booking():
    bookings = Booking.query.all()
    return render_template('admin_booking.html', bookings=bookings)

@app.route('/update_booking_status/<int:booking_id>', methods=['POST'])
def update_booking_status(booking_id):
    try:
        booking = Booking.query.get(booking_id)
        new_status = request.form['status']

        if not booking:
            return jsonify({'success': False, 'error': 'Booking not found'})

        # Fetch the user associated with the booking
        user = User.query.filter_by(contact_number=booking.contact_number).first()

        if not user:
            return jsonify({'success': False, 'error': 'User not found'})

        if new_status.lower() == 'rejected':
            # Capture reason for rejection
            rejection_reason = request.form.get('rejection_reason', 'No specific reason provided')
            solution = request.form.get('solution', 'No solution provided')

            # Create rejection notification
            notification_message = (
                f"Your booking request has been rejected. Reason: {rejection_reason}. Solution: {solution}."
            )
            notification = Notification(user_id=user.id, message=notification_message)
            db.session.add(notification)

            # Remove booking after rejection
            db.session.delete(booking)
            db.session.commit()

        elif new_status.lower() == 'accepted':
            # Update booking status to accepted
            booking.status = 'Accepted'
            db.session.commit()

            # Create acceptance notification
            notification_message = (
                f"Your booking request has been approved. Date of Request: {booking.appointment_date.strftime('%Y-%m-%d')} - "
                f"Time: {booking.appointment_time.strftime('%I:%M %p')}."
            )
            notification = Notification(user_id=user.id, message=notification_message)
            db.session.add(notification)
            db.session.commit()

        return jsonify({'success': True})

    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'success': False, 'error': str(e)})
    
# Admin Borrowing View Route
@app.route('/admin/borrowing')
def admin_borrowing():
    if 'user_id' in session and session.get('role') == 'admin':
        borrowings = EquipmentBorrowing.query.all()
        return render_template('admin_borrowing.html', borrowings=borrowings)
    else:
        flash("Access denied.", "error")
        return redirect(url_for('login'))
    

@app.route('/borrow_equipment', methods=['POST'])
def borrow_equipment():
    # Ensure user is logged in
    if 'user_id' not in session:
        flash("Please log in to borrow equipment.", "error")
        return redirect(url_for('login'))

    user_id = session['user_id']
    equipment_id = request.form.get('equipment_id')
    return_date = request.form.get('return_date')

    # Add borrow request to the database
    new_borrowing = EquipmentBorrowing(
        user_id=user_id,
        equipment_id=equipment_id,
        return_date=datetime.strptime(return_date, '%Y-%m-%d')
    )

    db.session.add(new_borrowing)
    db.session.commit()

    # Flash a success message
    flash("Borrow request submitted successfully!", "success")
    return redirect(url_for('user_equipments'))

# Admin route to manage inventory
@app.route('/admin/inventory', methods=['GET', 'POST'])
def admin_inventory():
    if request.method == 'POST':
        item_name = request.form['item_name']
        condition = request.form['condition']
        quantity = int(request.form['quantity'])
        
        # Handle image upload
        image_file = request.files['image']
        if image_file and image_file.filename != '':
            # Save the file
            filename = secure_filename(image_file.filename)
            image_file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
            image_path = filename
        else:
            image_path = None  # No image uploaded

        # Create new inventory item
        new_item = Inventory(name=item_name, condition=condition, quantity=quantity, image=image_path)
        db.session.add(new_item)
        db.session.commit()
        flash("Item added to inventory successfully.")
        return redirect(url_for('admin_inventory'))

    inventory_items = Inventory.query.all()
    return render_template('admin_inventory.html', inventory_items=inventory_items)
    
@app.route('/edit_item/<int:item_id>', methods=['POST'])
def edit_inventory_item(item_id):
    global inventory_items
    for item in inventory_items:
        if item['id'] == item_id:
            item['quantity'] = request.form['quantity']  # Update only the quantity
            break
    return redirect(url_for('admin_inventory'))


# Route to delete inventory item
@app.route('/delete_inventory_item/<int:item_id>', methods=['POST'])
def delete_inventory_item(item_id):
    item = Inventory.query.get(item_id)
    if item:
        # Delete the image file if it exists
        if item.image:
            image_path = os.path.join(app.config['UPLOAD_FOLDER'], item.image)
            if os.path.exists(image_path):
                os.remove(image_path)
        
        db.session.delete(item)
        db.session.commit()
        flash("Item deleted from inventory.")
    return redirect(url_for('admin_inventory'))

@app.route('/admin/notifications')
def admin_notifications():
    # Logic to handle notifications
    return render_template('admin_notifications.html')

@app.route('/admin/settings')
def admin_settings():
    # Logic for admin settings
    return render_template('admin_settings.html')

# Logout route
@app.route('/logout')
def logout():
    session.pop('user_id', None)
    session.pop('role', None)
    session.pop('username', None)
    flash('You have been logged out.')
    return redirect(url_for('landing'))

# Error handler
@app.errorhandler(404)
def not_found(e):
    return render_template('404.html'), 404

#>>>>>>>>>>>>>>>>>>>>>>>>>>> U S E R <<<<<<<<<<<<<<<<<<<<<<<<<<<<<

@app.route('/upload_profile_picture', methods=['POST'])
def upload_profile_picture():
    # Logic for handling the file upload
    pass

@app.route('/user_appointments', methods=['GET'])
def user_appointments():
    return render_template('user_appointments.html')

@app.route('/book_appointment', methods=['POST'])
def book_appointment():
    user_name = request.form['user_name']
    contact_number = request.form['contact_number']
    appointment_date = request.form['appointment_date']
    appointment_time = request.form['appointment_time']
    message = request.form['message']
    
    # Create a new booking
    new_booking = Booking(
        user_name=user_name,
        contact_number=contact_number,
        appointment_date=datetime.strptime(appointment_date, '%Y-%m-%d'),
        appointment_time=datetime.strptime(appointment_time, '%H:%M').time(),
        message=message,
        status='pending'
    )
    
    db.session.add(new_booking)
    db.session.commit()
    
    return redirect(url_for('user_dashboard'))

# User Borrow Equipment Route
@app.route('/user/borrow_equipment', methods=['POST'])
def submit_borrow_request():
    if 'user_id' not in session:
        flash("Please log in to borrow equipment.", "error")
        return redirect(url_for('login'))

    user_id = session['user_id']
    equipment_id = request.form.get('equipment_id')
    return_date = request.form.get('return_date')

    # Add borrow request to the database
    new_borrowing = EquipmentBorrowing(
        user_id=user_id,
        equipment_id=equipment_id,
        return_date=datetime.strptime(return_date, '%Y-%m-%d')
    )
    db.session.add(new_borrowing)
    db.session.commit()

    # Flash a success message
    flash("Borrow request submitted successfully!", "success")
    return redirect(url_for('user_equipments'))

# User Equipments View Route
@app.route('/user_equipments')
def user_equipments():
    equipment_list = Inventory.query.all()
    return render_template('user_equipments.html', equipment_list=equipment_list)

@app.route('/user_feedback')
def user_feedback():
    return render_template('user_feedback.html')

@app.route('/user_notifications')
def user_notifications():
    if 'user_id' not in session:
        flash('Please log in to view notifications.', 'error')
        return redirect(url_for('login'))

    user_id = session['user_id']
    notifications = Notification.query.filter_by(user_id=user_id).all()
    
    return render_template('user_notifications.html', notifications=notifications)

@app.route('/delete_notification/<int:notification_id>', methods=['DELETE'])
def delete_notification(notification_id):
    if 'user_id' not in session:
        return jsonify({'success': False, 'message': 'User not logged in'}), 403

    notification = Notification.query.get(notification_id)

    if not notification or notification.user_id != session['user_id']:
        return jsonify({'success': False, 'message': 'Notification not found or unauthorized'}), 404

    try:
        db.session.delete(notification)
        db.session.commit()
        return jsonify({'success': True})
    except Exception as e:
        print(f"Error: {e}")
        return jsonify({'success': False, 'message': 'An error occurred while deleting the notification.'}), 500

@app.route('/user_settings')
def user_settings():
    return render_template('user_settings.html')

# Run the application
if __name__ == '__main__':
    app.run(debug=True)
