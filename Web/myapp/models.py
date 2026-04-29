from django.db import models



# webapp/models.py
from django.db import models
from django.contrib.auth.models import User

# Pharmacy
class Pharmacy(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    pharmacy_name = models.CharField(max_length=100)
    email = models.EmailField()
    phone = models.CharField(max_length=15)
    place = models.CharField(max_length=100)
    latitude = models.FloatField()
    longitude = models.FloatField()
    license_proof = models.FileField(upload_to='licenses/')
    approval_status = models.BooleanField(default=False)

    def __str__(self):
        return self.pharmacy_name

# Patient
class Patient(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    phone = models.CharField(max_length=15)
    email = models.EmailField()
    place = models.CharField(max_length=100)
    age = models.IntegerField()
    gender = models.CharField(max_length=10)
    latitude = models.CharField(max_length=50, null=True, blank=True)  # 🆕
    longitude = models.CharField(max_length=50, null=True, blank=True)  # 🆕

    def __str__(self):
        return self.name

# Complaint
class Complaint(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    complaint = models.TextField()
    reply = models.TextField(blank=True, null=True)
    date = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.date}"

# Pharmacy Medicine
class PharmacyMedicine(models.Model):
    pharmacy = models.ForeignKey(Pharmacy, on_delete=models.CASCADE)
    medicine_name = models.CharField(max_length=100)
    company_name = models.CharField(max_length=100)
    medicine_type = models.CharField(max_length=50)  # capsule, syrup
    manufacture_date = models.DateField()
    expiry_date = models.DateField()
    quantity = models.IntegerField()
    price = models.FloatField()
    details = models.TextField(blank=True, null=True)
    prescription_require = models.BooleanField(default=False)  # True = prescription required

    def __str__(self):
        return f"{self.medicine_name} ({self.pharmacy.pharmacy_name})"

# Prescription
class Prescription(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
    file = models.FileField(upload_to='prescriptions/')
    text = models.TextField(blank=True, null=True)
    date = models.DateTimeField(auto_now_add=True)

# Order Master
class OrderMaster(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
    total_amount = models.FloatField()
    date = models.DateTimeField(auto_now_add=True)
    payment_status = models.CharField(max_length=50)  # Paid, Pending, Failed

# Order Details
class OrderDetails(models.Model):
    pharmacy_medicine = models.ForeignKey(PharmacyMedicine, on_delete=models.CASCADE)
    prescription = models.ForeignKey(Prescription, on_delete=models.SET_NULL, null=True, blank=True)
    quantity = models.IntegerField()
    amount = models.FloatField()
    order_status = models.CharField(max_length=50)  # Pending, Delivered, Cancelled

# Emergency Number
class EmergencyNumber(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
    number = models.CharField(max_length=15)

# Medicine Details
class MedicineDetails(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
    medicine_name = models.CharField(max_length=100)
    dosage = models.CharField(max_length=100)
    quantity = models.IntegerField()
    description = models.TextField(blank=True, null=True)

#
# ✅ SIMPLE REMINDER MODEL
class Reminder(models.Model):
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
    time = models.TimeField()
    message = models.TextField()
class Cart(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    medicine = models.ForeignKey('PharmacyMedicine', on_delete=models.CASCADE)
    quantity = models.PositiveIntegerField(default=1)
    added_on = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.medicine.name} ({self.quantity})"







# Create your models here.
