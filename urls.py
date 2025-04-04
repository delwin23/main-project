"""
URL configuration for bank_system project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
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
from django.urls import path
from banking import views
from django.contrib.auth.views import LogoutView
from django.conf.urls.static import static
from django.conf import settings
from banking.views import razorpay_callback
from banking.views import disburse_credit_card  # Import the view function
from django.shortcuts import redirect
from banking.views import generate_otp
from banking.views import verify_otp  

def redirect_to_login(request):
    return redirect("login")  # Redirects to the login page






urlpatterns = [
    path("", redirect_to_login, name="home"),
    path("check-loan-eligibility/", views.check_loan_eligibility, name="check_loan_eligibility"),
    path('upload-account-holders/', views.upload_account_data, name='upload_account_holders'),
    path('logout/', views.user_logout, name='logout'),
    path("register/", views.register, name="register"),
    path("login/", views.user_login, name="login"),
    path("dashboard/", views.user_dashboard, name="user_dashboard"),
    path("apply-loan/", views.apply_loan, name="apply_loan"),
    path("apply-credit-card/", views.apply_credit_card, name="apply_credit_card"),
    path("status/", views.application_status, name="application_status"),
    path("admin-dashboard/", views.admin_dashboard, name="admin_dashboard"),
    path("approve-loan/<int:loan_id>/", views.approve_loan, name="approve_loan"),
    path("reject-loan/<int:loan_id>/", views.reject_loan, name="reject_loan"),
    path('approve_credit_card/<int:card_id>/', views.approve_credit_card, name='approve_credit_card'),
    path('reject_credit_card/<int:card_id>/', views.reject_credit_card, name='reject_credit_card'),
    path("disburse-loan/<int:loan_id>/", views.disburse_loan, name="disburse_loan"),
    path("loan-repayment-details/<int:loan_id>/", views.loan_repayment_details, name="loan_repayment_details"),
    path('loan/<int:loan_id>/repayment/', views.loan_repayment_details, name='loan_repayment_details'),
    path('installment/<int:installment_id>/create-order/', views.create_razorpay_order, name='create_razorpay_order'),
    path('razorpay-callback/', views.razorpay_callback, name='razorpay_callback'),
    # Add these to your urlpatterns list in urls.py
     path("credit-card-details/<int:card_id>/", views.credit_card_details, name="credit_card_details"),
    path("create-credit-card-payment/<int:billing_id>/", views.create_credit_card_payment_order, 
         name="create_credit_card_payment_order"),
    path("razorpay-credit-card-callback/", views.razorpay_credit_card_callback, 
         name="razorpay_credit_card_callback"),
    path("billing-details/<int:billing_id>/", views.billing_details, name="billing_details"),
    path('disburse-credit-card/<int:card_id>/', disburse_credit_card, name='disburse_credit_card'),

    path('payment/receipt/<int:receipt_id>/', views.payment_receipt, name='payment_receipt'),
    path('generate-otp/', views.generate_otp, name='generate_otp'),
    path('verify-otp/', views.verify_otp, name='verify_otp'),
]



if settings.DEBUG:  # Serve media files in development only
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)