"""
URL configuration for medifindproject project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/5.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path

from myapp import views

urlpatterns = [

    path('',views.home,name='home'),
    path('login/', views.login_view, name='login'),
    path('pharmacy_register/', views.pharmacy_register, name='pharmacy_register'),
    path('admin_home/', views.admin_home, name='admin_home'),  # placeholder for admin dashboard
    path('pharmacy_home', views.pharmacy_home, name='pharmacy_home'),  # placeholder for pharmacy dashboard

    path('admin_manage_pharmacies/', views.admin_manage_pharmacies, name='admin_manage_pharmacies'),
    path('approve_pharmacy/<int:pid>/', views.approve_pharmacy, name='approve_pharmacy'),
    path('reject_pharmacy/<int:pid>/', views.reject_pharmacy, name='reject_pharmacy'),

    path('pharmacy_medicines/', views.pharmacy_medicines, name='pharmacy_medicines'),  # view all medicines
    path('add_medicine/', views.add_medicine, name='add_medicine'),  # add new medicine
    path('edit_medicine/<int:mid>/', views.edit_medicine, name='edit_medicine'),  # edit medicine
    path('delete_medicine/<int:mid>/', views.delete_medicine, name='delete_medicine'),  # delete medicine
    path('pharmacy_complaint/', views.pharmacy_complaint, name='pharmacy_complaint'),

    path('admin_view_complaints/', views.admin_view_complaints, name='admin_view_complaints'),
    path('admin_reply_complaint/<int:cid>/', views.admin_reply_complaint, name='admin_reply_complaint'),
    path('admin_manage_users/', views.admin_manage_users, name='admin_manage_users'),
    path('admin_delete_user/<int:user_id>/', views.delete_user, name='delete_user'),

    path('user_login/', views.login, name='user_login'),
    path('register/', views.register, name='register'),
    path('viewprofile/', views.view_profile, name='view_profile'),
    path('editprofile/', views.edit_profile, name='edit_profile'),
    # path('all_pharmacies/', views.all_pharmacies, name='all_pharmacies'),
    path('nearby_pharmacies/', views.nearby_pharmacies),

    path('view_medicines/<int:pharmacy_id>/', views.view_medicines, name='view_medicines'),
    path('add_to_cart/', views.add_to_cart, name='add_to_cart'),
    path('view_cart/<int:user_id>/', views.view_cart, name='view_cart'),
    path('update_cart_quantity/', views.update_cart_quantity, name='update_cart_quantity'),
    path('remove_from_cart/', views.remove_from_cart, name='remove_from_cart'),
    # path('payment_view/<int:user_id>/', views.payment_view, name='payment'),
    path('sumofcart/', views.sumofcart, name='sumofcart'),
    path('payment_view/', views.payment_view, name='payment_view'),
    path('view_payments/', views.view_payments, name='view_payments'),
    path('pharmacy_view_orders/', views.pharmacy_view_orders, name='pharmacy_view_orders'),
    path('update_payment_status/<int:payment_id>/', views.update_payment_status, name='update_payment_status'),
    path('upload_prescription/', views.upload_prescription, name='upload_prescription'),
    path('set_emergency_number/', views.set_emergency_number, name='set_emergency_number'),
    # path('add_reminder/', views.add_reminder, name='add_reminder'),
    path('get_call_numbers/', views.get_call_numbers, name='get_call_numbers'),
    # path('view_reminders/<int:lid>/', views.view_reminders, name='view_reminders'),
    #
    # path('add_medicine_with_reminder/',views.add_medicine_with_reminder,name='add_medicine_with_reminder'),

    # path('update_location/', views.update_location, name='update_location'),
    path('set_medicine_reminder/', views.set_medicine_reminder, name='set_medicine_reminder'),
    path('view_medicine_reminders/', views.view_medicine_reminders, name='view_medicine_reminders'),
    path('delete_reminder/', views.delete_reminder, name='delete_reminder'),
    path('logout/', views.logout_view, name='logout'),

]
