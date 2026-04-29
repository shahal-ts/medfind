from django.shortcuts import render

from django.shortcuts import render, redirect
from django.contrib.auth.models import User
from django.contrib import messages
from django.contrib.auth import authenticate, login as auth_login
import json
from sympy import Q

from .models import Pharmacy, Cart, OrderMaster, OrderDetails, EmergencyNumber


# Login view (already discussed)
def login_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']

        # Admin Login
        user = authenticate(request, username=username, password=password)
        if user is not None and user.is_superuser:
            auth_login(request, user)
            request.session['usertype'] = 'admin'
            return redirect('admin_home')

        # Pharmacy Login
        try:
            pharmacy_user = User.objects.get(username=username)
            if pharmacy_user.check_password(password):
                pharmacy = Pharmacy.objects.get(user=pharmacy_user)
                if pharmacy.approval_status:
                    auth_login(request, pharmacy_user)
                    request.session['userid'] = pharmacy.id
                    request.session['usertype'] = 'pharmacy'
                    return redirect('pharmacy_home')
                else:
                    messages.error(request, 'Your registration is pending approval.')
                    return redirect('login')
        except (User.DoesNotExist, Pharmacy.DoesNotExist):
            pass

        messages.error(request, 'Invalid credentials')
        return redirect('login')

    return render(request, 'login.html')

#
# # Pharmacy Registration
# def pharmacy_register(request):
#     if request.method == 'POST':
#         username = request.POST['username']
#         password = request.POST['password']
#         pharmacy_name = request.POST['pharmacy_name']
#         email = request.POST['email']
#         phone = request.POST['phone']
#         place = request.POST['place']
#         latitude = request.POST['latitude']
#         longitude = request.POST['longitude']
#         license_proof = request.FILES['license_proof']
#
#         if User.objects.filter(username=username).exists():
#             messages.error(request, 'Username already exists')
#             return redirect('pharmacy_register')
#
#         # Create user
#         user = User.objects.create_user(username=username, password=password, email=email)
#         user.save()
#
#         # Create Pharmacy
#         pharmacy = Pharmacy.objects.create(
#             user=user,
#             pharmacy_name=pharmacy_name,
#             email=email,
#             phone=phone,
#             place=place,
#             latitude=latitude,
#             longitude=longitude,
#             license_proof=license_proof,
#             approval_status=False
#             # admin will approve later
#         )
#         pharmacy.save()
#
#         messages.success(request, 'Registration successful! Wait for admin approval.')
#         return redirect('login')
#
#     return render(request, 'pharmacy_registration.html')


from django.shortcuts import render, redirect
from django.contrib import messages
from django.contrib.auth.models import User
from .models import Pharmacy

# Pharmacy Registration
def pharmacy_register(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')
        pharmacy_name = request.POST.get('pharmacy_name')
        email = request.POST.get('email')
        phone = request.POST.get('phone')
        place = request.POST.get('place')
        latitude = request.POST.get('latitude')
        longitude = request.POST.get('longitude')
        license_proof = request.FILES.get('license_proof')

        # Validation
        if not latitude or not longitude:
            messages.error(request, 'Please select pharmacy location on map')
            return redirect('pharmacy_register')

        if User.objects.filter(username=username).exists():
            messages.error(request, 'Username already exists')
            return redirect('pharmacy_register')

        # Create user
        user = User.objects.create_user(
            username=username,
            password=password,
            email=email
        )

        # Create Pharmacy
        Pharmacy.objects.create(
            user=user,
            pharmacy_name=pharmacy_name,
            email=email,
            phone=phone,
            place=place,
            latitude=latitude,
            longitude=longitude,
            license_proof=license_proof,
            approval_status=False  # Admin approval pending
        )

        messages.success(request, 'Registration successful! Wait for admin approval.')
        return redirect('login')

    return render(request, 'pharmacy_registration.html')


def home(request):
    return render(request, 'home.html')

def admin_home(request):
    return render(request, 'admin_home.html')

def pharmacy_home(request):
    return  render(request, 'pharmacy_home.html')


from django.contrib.auth import logout
from django.shortcuts import redirect

def logout_view(request):
    logout(request)
    return redirect('login')  # change 'login' to your login URL name



from django.shortcuts import render, redirect
from .models import Pharmacy

def admin_manage_pharmacies(request):
    pharmacies = Pharmacy.objects.all()
    return render(request, 'admin_manage_pharmacies.html', {'pharmacies': pharmacies})

def approve_pharmacy(request, pid):
    pharmacy = Pharmacy.objects.get(id=pid)
    pharmacy.approval_status = True   # Correct field name
    pharmacy.save()
    return redirect('admin_manage_pharmacies')

def reject_pharmacy(request, pid):
    pharmacy = Pharmacy.objects.get(id=pid)
    pharmacy.approval_status = False  # Correct field name
    pharmacy.save()
    return redirect('admin_manage_pharmacies')

def admin_manage_users(request):
    users = Patient.objects.all()  # fetch all registered users
    return render(request, 'admin_manage_users.html', {'users': users})

def delete_user(request, user_id):
    try:
        patient = Patient.objects.get(id=user_id)
        # First delete the linked Django User object
        patient.user.delete()
        # Then delete the Patient record
        patient.delete()
    except Patient.DoesNotExist:
        pass
    return redirect('admin_manage_users')


from django.shortcuts import render, redirect, get_object_or_404
from django.contrib.auth.decorators import login_required
from django.contrib import messages
from .models import PharmacyMedicine, Pharmacy

# Show all medicines for the logged-in pharmacy
@login_required
def pharmacy_medicines(request):
    pharmacy = get_object_or_404(Pharmacy, user=request.user)
    medicines = PharmacyMedicine.objects.filter(pharmacy=pharmacy)
    return render(request, 'pharmacy_medicines.html', {'medicines': medicines})

# Add new medicine
@login_required
def add_medicine(request):
    pharmacy = get_object_or_404(Pharmacy, user=request.user)
    if request.method == 'POST':
        prescription_require = request.POST.get('prescription_require') == 'on'
        PharmacyMedicine.objects.create(
            pharmacy=pharmacy,
            medicine_name=request.POST['medicine_name'],
            company_name=request.POST['company_name'],
            medicine_type=request.POST['medicine_type'],
            manufacture_date=request.POST['manufacture_date'],
            expiry_date=request.POST['expiry_date'],
            quantity=request.POST['quantity'],
            price=request.POST['price'],
            details=request.POST['details'],
            prescription_require=prescription_require
        )
        messages.success(request, 'Medicine added successfully!')
        return redirect('pharmacy_medicines')

    return render(request, 'add_medicine.html')

# Edit existing medicine
@login_required
def edit_medicine(request, mid):
    medicine = get_object_or_404(PharmacyMedicine, id=mid)
    if request.method == 'POST':
        medicine.medicine_name = request.POST['medicine_name']
        medicine.company_name = request.POST['company_name']
        medicine.medicine_type = request.POST['medicine_type']
        medicine.manufacture_date = request.POST['manufacture_date']
        medicine.expiry_date = request.POST['expiry_date']
        medicine.quantity = request.POST['quantity']
        medicine.price = request.POST['price']
        medicine.details = request.POST['details']
        medicine.prescription_require = request.POST.get('prescription_require') == 'on'
        medicine.save()
        messages.success(request, 'Medicine updated successfully!')
        return redirect('pharmacy_medicines')

    return render(request, 'edit_medicine.html', {'medicine': medicine})

# Delete medicine
@login_required
def delete_medicine(request, mid):
    medicine = get_object_or_404(PharmacyMedicine, id=mid)
    medicine.delete()
    messages.success(request, 'Medicine deleted successfully!')
    return redirect('pharmacy_medicines')


from .models import Complaint, Pharmacy

@login_required
def pharmacy_complaint(request):
    try:
        pharmacy = Pharmacy.objects.get(user=request.user)
    except Pharmacy.DoesNotExist:
        messages.error(request, "You are not registered as a pharmacy!")
        return redirect('pharmacy_home')

    if request.method == 'POST':
        complaint_text = request.POST.get('complaint')
        if complaint_text:
            Complaint.objects.create(user=request.user, complaint=complaint_text)
            messages.success(request, "Complaint sent successfully!")
            return redirect('pharmacy_complaint')
        else:
            messages.error(request, "Please enter a complaint.")

    # Show all complaints sent by this pharmacy
    complaints = Complaint.objects.filter(user=request.user).order_by('-date')
    return render(request, 'pharmacy_complaint.html', {'complaints': complaints})


@login_required
def admin_view_complaints(request):
    # Only show complaints to users with session usertype 'admin'
    if request.session.get('usertype') != 'admin':
        messages.error(request, 'Access denied.')
        return redirect('home')  # or some other page

    complaints = Complaint.objects.all().order_by('-date')
    return render(request, 'admin_view_complaints.html', {'complaints': complaints})

@login_required
def admin_reply_complaint(request, cid):
    if request.session.get('usertype') != 'admin':
        messages.error(request, 'Access denied.')
        return redirect('home')

    complaint = get_object_or_404(Complaint, id=cid)
    if request.method == 'POST':
        complaint.reply = request.POST.get('reply')
        complaint.save()
        messages.success(request, 'Reply sent successfully!')
        return redirect('admin_view_complaints')

    return render(request, 'admin_reply_complaint.html', {'complaint': complaint})


import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.models import User
from .models import Patient

@csrf_exempt
def register(request):
    if request.method == 'POST':
        try:
            data = json.loads(request.body)

            name = data.get('username')
            phone = data.get('phone')
            email = data.get('email')
            place = data.get('address')
            age = data.get('age')
            gender = data.get('gender')
            password = data.get('password')

            if not all([name, phone, email, place, age, gender, password]):
                return JsonResponse({
                    'status': 'error',
                    'message': 'All fields are required'
                })

            if User.objects.filter(username=name).exists():
                return JsonResponse({
                    'status': 'error',
                    'message': 'Username already exists'
                })

            user = User.objects.create_user(
                username=name,
                email=email,
                password=password
            )

            Patient.objects.create(
                user=user,
                name=name,
                phone=phone,
                email=email,
                place=place,
                age=age,
                gender=gender
            )

            return JsonResponse({'status': 'ok'})

        except Exception as e:
            return JsonResponse({
                'status': 'error',
                'message': str(e)
            })

    return JsonResponse({'status': 'invalid request'})

from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from django.contrib.auth import authenticate
from .models import Patient

@csrf_exempt
def login(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('password')

        if not username or not password:
            return JsonResponse({
                'status': 'error',
                'message': 'Username and password required'
            })

        user = authenticate(username=username, password=password)

        if user is not None:
            if Patient.objects.filter(user=user).exists():
                return JsonResponse({
                    'status': 'ok',
                    'lid': user.id
                })
            else:
                return JsonResponse({
                    'status': 'error',
                    'message': 'User not authorized'
                })
        else:
            return JsonResponse({
                'status': 'error',
                'message': 'Invalid username or password'
            })

    return JsonResponse({'status': 'invalid request'})

@csrf_exempt
def view_profile(request):
            if request.method == 'POST':
                lid = request.POST.get('lid')
                try:
                    user = User.objects.get(id=lid)
                    patient = Patient.objects.get(user=user)
                    return JsonResponse({
                        'status': 'ok',
                        'name': patient.name,
                        'phone': patient.phone,
                        'email': patient.email,
                        'place': patient.place,
                        'age': patient.age,
                        'gender': patient.gender,
                    })
                except Patient.DoesNotExist:
                    return JsonResponse({'status': 'notfound'})
                except Exception as e:
                    return JsonResponse({'status': 'error', 'message': str(e)})

        # Edit Profile
@csrf_exempt
def edit_profile(request):
            if request.method == 'POST':
                lid = request.POST.get('lid')
                try:
                    user = User.objects.get(id=lid)
                    patient = Patient.objects.get(user=user)

                    # Update fields
                    patient.name = request.POST.get('name', patient.name)
                    patient.phone = request.POST.get('phone', patient.phone)
                    patient.email = request.POST.get('email', patient.email)
                    patient.place = request.POST.get('place', patient.place)
                    patient.age = int(request.POST.get('age', patient.age))
                    patient.gender = request.POST.get('gender', patient.gender)

                    patient.save()
                    return JsonResponse({'status': 'ok'})
                except Patient.DoesNotExist:
                    return JsonResponse({'status': 'notfound'})
                except Exception as e:
                    return JsonResponse({'status': 'error', 'message': str(e)})


# Create your views here.
def view_medicines(request, pharmacy_id):
    try:
        pharmacy = Pharmacy.objects.get(id=pharmacy_id)
    except Pharmacy.DoesNotExist:
        return JsonResponse({'status': 'error', 'message': 'Pharmacy not found'})

    medicines = PharmacyMedicine.objects.filter(pharmacy=pharmacy)
    medicine_list = []
    for med in medicines:
        medicine_list.append({
            'id': med.id,
            'name': med.medicine_name,
            'description': med.details or '',
            'price': str(med.price),
            'stock': med.quantity,
            'type': med.medicine_type,
            'company': med.company_name,
            'expiry_date': med.expiry_date.strftime('%Y-%m-%d'),
        })

    return JsonResponse({'status': 'ok', 'pharmacy': pharmacy.pharmacy_name, 'medicines': medicine_list})

# def all_pharmacies(request):
#     """
#     Returns all pharmacies (no search filter)
#     """
#     pharmacies = Pharmacy.objects.all()
#
#     pharmacy_list = []
#     for pharmacy in pharmacies:
#         pharmacy_list.append({
#             'id': pharmacy.id,
#             'pharmacy_name': pharmacy.pharmacy_name,
#             'place': pharmacy.place,
#             'latitude': pharmacy.latitude,
#             'longitude': pharmacy.longitude,
#         })
#
#     return JsonResponse({'status': 'ok', 'pharmacies': pharmacy_list})


from django.http import JsonResponse
from .models import Pharmacy
from math import radians, cos, sin, asin, sqrt

# 📏 Distance calculation (Haversine formula)
def calculate_distance(lat1, lon1, lat2, lon2):
    lon1, lat1, lon2, lat2 = map(radians, [lon1, lat1, lon2, lat2])
    dlon = lon2 - lon1
    dlat = lat2 - lat1
    a = sin(dlat/2)**2 + cos(lat1) * cos(lat2) * sin(dlon/2)**2
    c = 2 * asin(sqrt(a))
    km = 6371 * c
    return km


def nearby_pharmacies(request):
    if request.method == "POST":
        user_lat = float(request.POST['latitude'])
        user_lng = float(request.POST['longitude'])

        pharmacies = Pharmacy.objects.all()
        pharmacy_list = []

        for p in pharmacies:
            distance = calculate_distance(
                user_lat, user_lng,
                float(p.latitude), float(p.longitude)
            )

            if distance <= 5:  # 🔥 5 KM radius
                pharmacy_list.append({
                    'id': p.id,
                    'pharmacy_name': p.pharmacy_name,
                    'place': p.place,
                    'latitude': p.latitude,
                    'longitude': p.longitude,
                    'distance': distance,
                })

        pharmacy_list.sort(key=lambda x: x['distance'])

        return JsonResponse({
            'status': 'ok',
            'pharmacies': pharmacy_list
        })

@csrf_exempt
def add_to_cart(request):
    if request.method == "POST":
        patient_id = request.POST.get("patient_id")
        medicine_id = request.POST.get("medicine_id")
        quantity = int(request.POST.get("quantity"))

        # create OrderMaster if not exists, then add OrderDetails
        from .models import Patient, OrderMaster, OrderDetails, PharmacyMedicine

        patient = Patient.objects.get(id=patient_id)
        medicine = PharmacyMedicine.objects.get(id=medicine_id)

        # simple order creation
        order = OrderMaster.objects.create(
            patient=patient,
            total_amount=medicine.price * quantity,
            payment_status="Pending"
        )

        OrderDetails.objects.create(
            pharmacy_medicine=medicine,
            quantity=quantity,
            amount=medicine.price * quantity,
            order_status="Pending"
        )

        return JsonResponse({"status": "ok"})


@csrf_exempt
def add_to_cart(request):
    if request.method == "POST":
        lid = request.POST.get('lid')  # user id
        medicine_id = request.POST.get('medicine_id')
        quantity = request.POST.get('quantity', 1)

        try:
            user = User.objects.get(id=lid)
        except User.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'User not found'})

        try:
            medicine = PharmacyMedicine.objects.get(id=medicine_id)
        except PharmacyMedicine.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'Medicine not found'})

        # Check if the medicine is already in cart
        cart_item, created = Cart.objects.get_or_create(
            user=user,
            medicine=medicine,
            defaults={'quantity': quantity}
        )

        if not created:
            cart_item.quantity += int(quantity)
            cart_item.save()

        return JsonResponse({'status': 'ok', 'message': 'Added to cart successfully'})

    return JsonResponse({'status': 'error', 'message': 'Invalid request'})


from django.http import JsonResponse
from .models import Cart, PharmacyMedicine
from django.contrib.auth.models import User

def view_cart(request, user_id):
    try:
        user = User.objects.get(id=user_id)
    except User.DoesNotExist:
        return JsonResponse({'status': 'error', 'message': 'User not found'})

    cart_items = Cart.objects.filter(user=user)
    cart_list = []

    for item in cart_items:
        cart_list.append({
            'id': item.id,  # cart item id
            'medicine_id': item.medicine.id,
            'medicine_name': item.medicine.medicine_name,  # match your model
            'description': item.medicine.details,  # match your model
            'price': str(item.medicine.price),
            'stock': item.medicine.quantity,  # available stock
            'quantity': item.quantity,
        })

    return JsonResponse({'status': 'ok', 'cart_items': cart_list})

@csrf_exempt
def update_cart_quantity(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        cart_id = data.get('cart_id')
        quantity = data.get('quantity')

        try:
            cart_item = Cart.objects.get(id=cart_id)
            cart_item.quantity = quantity
            cart_item.save()
            return JsonResponse({'status': 'ok'})
        except Cart.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'Cart item not found'})

@csrf_exempt
def remove_from_cart(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        cart_id = data.get('cart_id')

        try:
            cart_item = Cart.objects.get(id=cart_id)
            cart_item.delete()
            return JsonResponse({'status': 'ok'})
        except Cart.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'Cart item not found'})

from django.http import JsonResponse
from django.contrib.auth.models import User
from .models import Cart

@csrf_exempt
def payment_view(request):
    if request.method == 'POST':
        try:
            lid = request.POST.get('lid')
            total_sum = request.POST.get('total_sum')
            payment_id = request.POST.get('payment_id')

            print("📦 Payment Request Received:", lid, total_sum, payment_id)

            if not lid or not total_sum:
                return JsonResponse({'status': 'no', 'message': 'Missing parameters'})

            user = User.objects.get(id=lid)

            # make sure this user has a linked Patient profile
            try:
                patient = user.patient
            except Exception:
                return JsonResponse({'status': 'no', 'message': 'Patient not found for this user'})

            cart_items = Cart.objects.filter(user=user)
            if not cart_items.exists():
                return JsonResponse({'status': 'no', 'message': 'Cart is empty'})

            # create the main order (works as payment record)
            order = OrderMaster.objects.create(
                patient=patient,
                total_amount=total_sum,
                payment_status='Paid'
            )

            # save details for each item
            for item in cart_items:
                OrderDetails.objects.create(
                    pharmacy_medicine=item.medicine,
                    quantity=item.quantity,
                    amount=item.medicine.price * item.quantity,
                    order_status='Pending'
                )

            # clear cart
            cart_items.delete()

            print("✅ Payment Success for:", user.username)
            return JsonResponse({'status': 'ok', 'message': 'Payment success', 'payment_id': payment_id})

        except Exception as e:
            print("❌ Error in payment_view:", e)
            return JsonResponse({'status': 'error', 'message': str(e)})
    else:
        return JsonResponse({'status': 'no', 'message': 'Invalid method'})


from django.db.models import Sum


@csrf_exempt
def sumofcart(request):
    if request.method == 'POST':
        try:
            lid = request.POST.get('lid')
            if not lid:
                return JsonResponse({'status': 'no', 'message': 'Missing lid'})

            user = User.objects.get(id=lid)

            # Join with PharmacyMedicine to calculate total = price * quantity
            cart_items = Cart.objects.filter(user=user).select_related('medicine')

            if not cart_items.exists():
                return JsonResponse({'status': 'no', 'message': 'Cart is empty'})

            total_sum = 0
            for item in cart_items:
                total_sum += item.medicine.price * item.quantity

            return JsonResponse({'status': 'ok', 'total_sum': total_sum})

        except User.DoesNotExist:
            return JsonResponse({'status': 'no', 'message': 'User not found'})
        except Exception as e:
            print("Error in sumofcart:", e)
            return JsonResponse({'status': 'error', 'message': str(e)})
    else:
        return JsonResponse({'status': 'no', 'message': 'Invalid method'})


@csrf_exempt
def view_payments(request):
    if request.method == 'POST':
        try:
            lid = request.POST.get('lid')
            user = User.objects.get(id=lid)
            patient = Patient.objects.get(user=user)

            orders = OrderMaster.objects.filter(patient=patient).order_by('-date')

            data = []
            for order in orders:
                data.append({
                    'order_id': order.id,
                    'total_amount': order.total_amount,
                    'date': order.date.strftime('%Y-%m-%d %H:%M'),
                    'payment_status': order.payment_status,  # ✅ fixed field name

                })

            return JsonResponse({'status': 'ok', 'payments': data})
        except Exception as e:
            print("🔥 Error in view_payments:", e)
            return JsonResponse({'status': 'error', 'message': str(e)})
    else:
        return JsonResponse({'status': 'no', 'message': 'Invalid method'})



def pharmacy_view_orders(request):
    payments = OrderMaster.objects.all().order_by('-date')
    return render(request, 'pharmacy_view_orders.html', {'payments': payments})

def update_payment_status(request, payment_id):
    payment = get_object_or_404(OrderMaster, id=payment_id)
    if request.method == 'POST':
        status = request.POST.get('status')
        payment.payment_status = status
        payment.save()
        return redirect('pharmacy_view_orders')




# views.py
from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
from PIL import Image
from .models import Prescription, Patient
import google.generativeai as genai
import os

genai.configure(api_key="AIzaSyC6Aqsq13RWFteUBYV3tXLuJU7rnZR_xew")

@csrf_exempt
def upload_prescription(request):
    """
    Receives image from Flutter -> extracts text -> saves to DB -> returns result
    """
    if request.method == "POST":
        try:
            # ✅ Flutter sends these fields
            user_id = request.POST.get("lid") or request.POST.get("user_id")
            image_file = request.FILES.get("prescription") or request.FILES.get("image")

            if not user_id or not image_file:
                return JsonResponse({"status": "error", "message": "Missing user ID or image"})

            patient = Patient.objects.get(user__id=user_id)

            # Save image temporarily
            temp_path = f"temp_{image_file.name}"
            with open(temp_path, "wb+") as f:
                for chunk in image_file.chunks():
                    f.write(chunk)

            # Gemini model
            model = genai.GenerativeModel('gemini-2.0-flash')
            response = model.generate_content([
                "Extract the medicine name, dosage, frequency, and duration from this prescription:",
                Image.open(temp_path)
            ])

            extracted_text = response.text.replace("*", "").strip()

            # Save into DB
            Prescription.objects.create(
                patient=patient,
                file=image_file,
                text=extracted_text
            )

            # Cleanup
            if os.path.exists(temp_path):
                os.remove(temp_path)

            return JsonResponse({
                "status": "ok",
                "extracted_text": extracted_text,
                "message": "Prescription uploaded successfully"
            })

        except Patient.DoesNotExist:
            return JsonResponse({"status": "error", "message": "Patient not found"})
        except Exception as e:
            return JsonResponse({"status": "error", "message": str(e)})

    return JsonResponse({"status": "error", "message": "Invalid request"})


@csrf_exempt
def set_emergency_number(request):
    if request.method == 'POST':
        data = json.loads(request.body.decode('utf-8'))
        user_id = data.get('lid')
        number = data.get('number')

        try:
            patient = Patient.objects.get(user__id=user_id)
            EmergencyNumber.objects.update_or_create(
                patient=patient,
                defaults={'number': number}
            )
            return JsonResponse({"status": "ok", "message": "Emergency number saved successfully"})
        except Patient.DoesNotExist:
            return JsonResponse({"status": "error", "message": "Patient not found"})

    elif request.method == 'GET':
        user_id = request.GET.get('lid')
        try:
            patient = Patient.objects.get(user__id=user_id)
            emergency = EmergencyNumber.objects.get(patient=patient)
            return JsonResponse({
                "status": "ok",
                "number": emergency.number
            })
        except (Patient.DoesNotExist, EmergencyNumber.DoesNotExist):
            return JsonResponse({"status": "error", "message": "No emergency number found"})







@csrf_exempt
def get_call_numbers(request):
    if request.method == 'POST':
        try:
            lid = request.POST.get('lid')
            if not lid:
                return JsonResponse({'status': 'error', 'message': 'Login ID not provided'})

            patient = Patient.objects.get(user__id=lid)
            emergency_number = EmergencyNumber.objects.get(patient=patient)

            return JsonResponse({'status': 'ok', 'number': emergency_number.number})

        except Patient.DoesNotExist:
            return JsonResponse({'status': 'error', 'message': 'Patient profile not found'})
        except EmergencyNumber.DoesNotExist:
            return JsonResponse({'status': 'no', 'message': 'No emergency number found'})
        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)})
    return JsonResponse({'status': 'error', 'message': 'Invalid request method'})


#
# from django.http import JsonResponse
# from .models import Patient, Reminder
#
# def view_reminders(request, lid):
#     try:
#         patient = Patient.objects.get(user__id=lid)
#         reminders = Reminder.objects.filter(medicine_details__patient=patient)
#
#         reminder_list = []  # ✅ initialize list
#         for r in reminders:
#             reminder_list.append({  # ✅ use append, not add
#                 'id': r.id,
#                 'medicine_name': r.medicine_details.medicine_name,
#                 'dosage': r.medicine_details.dosage,
#                 'quantity': r.medicine_details.quantity,
#                 'description': r.medicine_details.description,
#                 'time_to_take': r.time_to_take.strftime("%H:%M"),
#                 'start_date': r.start_date.strftime("%Y-%m-%d"),
#                 'end_date': r.end_date.strftime("%Y-%m-%d"),
#                 'status': r.status
#             })
#
#         return JsonResponse({'status': 'ok', 'reminders': reminder_list})
#
#     except Patient.DoesNotExist:
#         return JsonResponse({'status': 'error', 'message': 'Patient not found'})
#     except Exception as e:
#         return JsonResponse({'status': 'error', 'message': str(e)})

from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import get_object_or_404
from .models import Patient, Reminder
import json
from datetime import datetime


@csrf_exempt
def set_medicine_reminder(request):
    """
    Sets a reminder for a patient.
    Expects POST data: 'lid' (user id), 'time' (HH:MM or HH:MM:SS), 'message'
    """
    if request.method == 'POST':
        try:
            lid = request.POST.get('lid')
            time_str = request.POST.get('time')
            message = request.POST.get('message')

            if not all([lid, time_str, message]):
                return JsonResponse({'status': 'error', 'message': 'All fields are required'})

            patient = get_object_or_404(Patient, user__id=lid)

            # Convert time string to Python time object
            try:
                reminder_time = datetime.strptime(time_str, "%H:%M").time()
            except ValueError:
                try:
                    reminder_time = datetime.strptime(time_str, "%H:%M:%S").time()
                except ValueError:
                    return JsonResponse({'status': 'error', 'message': 'Invalid time format. Use HH:MM or HH:MM:SS'})

            reminder = Reminder.objects.create(
                patient=patient,
                time=reminder_time,
                message=message
            )

            return JsonResponse({
                'status': 'success',
                'data': {
                    'id': reminder.id,
                    'time': reminder.time.strftime("%H:%M"),
                    'message': reminder.message
                }
            })
        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)})
    return JsonResponse({'status': 'error', 'message': 'Invalid request method'})


@csrf_exempt
def view_medicine_reminders(request):
    """
    Returns all reminders for a patient.
    Expects POST data: 'lid' (user id)
    """
    if request.method == 'POST':
        try:
            lid = request.POST.get('lid')
            if not lid:
                return JsonResponse({'status': 'error', 'message': 'Missing user ID'})

            patient = get_object_or_404(Patient, user__id=lid)
            reminders = Reminder.objects.filter(patient=patient).order_by('time')

            data = [
                {
                    'id': r.id,
                    'time': r.time.strftime("%H:%M"),
                    'message': r.message
                } for r in reminders
            ]

            return JsonResponse({'status': 'success', 'data': data})

        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)})

    return JsonResponse({'status': 'error', 'message': 'Invalid request method'})


@csrf_exempt
def delete_reminder(request):
    """
    Deletes a reminder.
    Expects POST JSON: {'reminder_id': <id>}
    """
    if request.method == 'POST':
        try:
            data = json.loads(request.body.decode('utf-8'))
            reminder_id = data.get('reminder_id')
            if not reminder_id:
                return JsonResponse({'status': 'error', 'message': 'Missing reminder ID'})

            reminder = get_object_or_404(Reminder, id=reminder_id)
            reminder.delete()
            return JsonResponse({'status': 'success', 'message': 'Reminder deleted successfully'})

        except Exception as e:
            return JsonResponse({'status': 'error', 'message': str(e)})

    return JsonResponse({'status': 'error', 'message': 'Invalid request method'})
