import random
import string
from django.core.mail import send_mail
from django.conf import settings
from datetime import datetime, timedelta
from .models import EmailOTP

def generate_otp():
    """Generate a 6-digit OTP"""
    return ''.join(random.choices(string.digits, k=6))

def send_otp_email(email):
    """Generate and send OTP to the provided email"""
    otp = generate_otp()
    
    # Save OTP to database (delete any existing OTPs for this email first)
    EmailOTP.objects.filter(email=email).delete()
    EmailOTP.objects.create(email=email, otp=otp)
    
    # Send email
    subject = "Your OTP for Loan Application"
    message = f"Your OTP for email verification is: {otp}. This OTP is valid for 10 minutes."
    email_from = settings.EMAIL_HOST_USER
    recipient_list = [email]
    
    send_mail(subject, message, email_from, recipient_list)
    return True

def verify_otp(email, otp):
    """Verify the OTP entered by the user"""
    try:
        otp_obj = EmailOTP.objects.get(email=email, otp=otp)
        # Check if OTP is expired (10 minutes)
        if datetime.now() - otp_obj.created_at.replace(tzinfo=None) > timedelta(minutes=10):
            return False
        
        # Mark as verified and save
        otp_obj.is_verified = True
        otp_obj.save()
        return True
    except EmailOTP.DoesNotExist:
        return False