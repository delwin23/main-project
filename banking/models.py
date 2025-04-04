from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils import timezone

class AccountHolder(models.Model):
    account_number = models.CharField(max_length=20, unique=True)
    ifsc = models.CharField(max_length=15)
    dob = models.DateField()
    name = models.CharField(max_length=100)
    balance = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return self.name

class User(AbstractUser):
    account = models.OneToOneField('AccountHolder', on_delete=models.CASCADE, null=True, blank=True)
    has_loan = models.BooleanField(default=False)

from django.db import models
from django.conf import settings  # Import settings to get AUTH_USER_MODEL

class LoanApplication(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)  # Use AUTH_USER_MODEL
    full_name = models.CharField(max_length=200)
    email = models.EmailField()
    phone_number = models.CharField(max_length=15)
    loan_amount = models.DecimalField(max_digits=12, decimal_places=2)
    loan_purpose = models.TextField()
    employment_type = models.CharField(max_length=100, choices=[('Salaried', 'Salaried'), ('Self-Employed', 'Self-Employed')])
    monthly_income = models.DecimalField(max_digits=10, decimal_places=2)
    existing_loans = models.BooleanField(default=False)
    loan_duration = models.IntegerField(help_text="Duration in months")
    id_proof = models.FileField(upload_to='documents/id_proofs/')
    possession_certificate = models.FileField(upload_to='documents/possession_certificates/', blank=True, null=True)
    salary_slip = models.FileField(upload_to='documents/salary_slips/', blank=True, null=True)
    written_request = models.FileField(upload_to='documents/written_requests/')
    status = models.CharField(max_length=20, choices=[('Pending', 'Pending'), ('Approved', 'Approved'), ('Rejected', 'Rejected')], default='Pending')
    applied_date = models.DateTimeField(auto_now_add=True)

class CreditCardApplication(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)  # Use AUTH_USER_MODEL
    full_name = models.CharField(max_length=200)
    email = models.EmailField()
    phone_number = models.CharField(max_length=15)
    employment_status = models.CharField(max_length=100, choices=[('Salaried', 'Salaried'), ('Self-Employed', 'Self-Employed')])
    annual_income = models.DecimalField(max_digits=12, decimal_places=2)
    cibil_score = models.IntegerField()
    id_proof = models.FileField(upload_to='documents/id_proofs/')
    address_proof = models.FileField(upload_to='documents/address_proofs/')
    salary_slip = models.FileField(upload_to='documents/salary_slips/', blank=True, null=True)
    status = models.CharField(max_length=20, choices=[('Pending', 'Pending'), ('Approved', 'Approved'), ('Rejected', 'Rejected')], default='Pending')
    applied_date = models.DateTimeField(auto_now_add=True)


class LoanDisbursement(models.Model):
    loan_application = models.OneToOneField(LoanApplication, on_delete=models.CASCADE, related_name='disbursement')
    disbursement_date = models.DateField(auto_now_add=True)
    loan_amount = models.DecimalField(max_digits=12, decimal_places=2)
    interest_rate = models.DecimalField(max_digits=5, decimal_places=2)  # Annual interest rate in percentage
    tenure_months = models.IntegerField()
    monthly_installment = models.DecimalField(max_digits=12, decimal_places=2)
    total_repayment_amount = models.DecimalField(max_digits=12, decimal_places=2)
    
    def __str__(self):
        return f"Loan for {self.loan_application.user.username} - ₹{self.loan_amount}"

class LoanInstallment(models.Model):
    disbursement = models.ForeignKey(LoanDisbursement, on_delete=models.CASCADE, related_name='installments')
    due_date = models.DateField()
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    status = models.CharField(max_length=20, choices=[
        ('Pending', 'Pending'),
        ('Paid', 'Paid'),
        ('Overdue', 'Overdue')
    ], default='Pending')
    
    def __str__(self):
        return f"Installment for {self.disbursement.loan_application.user.username} due on {self.due_date}"

# New fields for Razorpay integration
    payment_id = models.CharField(max_length=100, blank=True, null=True)
    order_id = models.CharField(max_length=100, blank=True, null=True)
    payment_date = models.DateTimeField(blank=True, null=True)
    
    def __str__(self):
        return f"Installment for {self.disbursement.loan_application.user.username} due on {self.due_date}"
    
    def is_payable(self):
        """Check if the installment is payable (pending or overdue)"""
        return self.status in ['Pending', 'Overdue']
    
    def mark_as_paid(self, payment_id):
        """Mark the installment as paid with the payment ID"""
        self.status = 'Paid'
        self.payment_id = payment_id
        self.payment_date = timezone.now()
        self.save()

# Add these models to your models.py file
class CreditCardDisbursement(models.Model):
    credit_card_application = models.OneToOneField(CreditCardApplication, on_delete=models.CASCADE, related_name='disbursement')
    disbursement_date = models.DateField(auto_now_add=True)
    credit_limit = models.DecimalField(max_digits=12, decimal_places=2)
    interest_rate = models.DecimalField(max_digits=5, decimal_places=2)  # Annual interest rate in percentage
    
    def __str__(self):
        return f"Credit Card for {self.credit_card_application.user.username} - ₹{self.credit_limit}"

class CreditCardBilling(models.Model):
    disbursement = models.ForeignKey(CreditCardDisbursement, on_delete=models.CASCADE, related_name='billings')
    due_date = models.DateField()
    amount = models.DecimalField(max_digits=12, decimal_places=2)
    status = models.CharField(max_length=20, choices=[
        ('Pending', 'Pending'),
        ('Paid', 'Paid'),
        ('Overdue', 'Overdue')
    ], default='Pending')
    payment_id = models.CharField(max_length=100, blank=True, null=True)
    order_id = models.CharField(max_length=100, blank=True, null=True)
    payment_date = models.DateTimeField(blank=True, null=True)
    
    def __str__(self):
        return f"Billing for {self.disbursement.credit_card_application.user.username} due on {self.due_date}"
    
    def is_payable(self):
        """Check if the billing is payable (pending or overdue)"""
        return self.status in ['Pending', 'Overdue']
    
    def mark_as_paid(self, payment_id):
        """Mark the billing as paid with the payment ID"""
        self.status = 'Paid'
        self.payment_id = payment_id
        self.payment_date = timezone.now()
        self.save()

class EmailOTP(models.Model):
    email = models.EmailField()
    otp = models.CharField(max_length=6)
    created_at = models.DateTimeField(auto_now_add=True)
    is_verified = models.BooleanField(default=False)
    
    def __str__(self):
        return f"{self.email} - {self.is_verified}"
    
    class Meta:
        verbose_name = "Email OTP"
        verbose_name_plural = "Email OTPs"