from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login, logout
from .models import AccountHolder, User, LoanApplication, CreditCardApplication,LoanDisbursement, LoanInstallment

from django.contrib.auth.decorators import login_required
from django.http import JsonResponse
from django.shortcuts import get_object_or_404, redirect
import pickle
import pandas as pd
from django.shortcuts import render, redirect
from django.contrib import messages
from .models import AccountHolder
import numpy as np
import razorpay
from decimal import Decimal
from django.conf import settings
from django.views.decorators.csrf import csrf_exempt
from django.http import HttpResponse
from datetime import datetime, timedelta
from banking.models import CreditCardDisbursement
from banking.models import CreditCardBilling





def upload_account_data(request):
    if request.method == "POST" and request.FILES["file"]:
        file = request.FILES["file"]
        
        try:
            # Read Excel file
            df = pd.read_excel(file)

            # Loop through each row
            for index, row in df.iterrows():
                # Ensure all required fields exist in the file
                if "account_number" in row and "ifsc" in row and "dob" in row and "name" in row and "balance" in row:
                    
                    # Convert dob to correct format
                    dob = pd.to_datetime(row["dob"]).date()

                    # Create AccountHolder entry
                    AccountHolder.objects.create(
                        account_number=row["account_number"],
                        ifsc=row["ifsc"],
                        dob=dob,
                        name=row["name"],
                        balance=row["balance"]
                    )

            messages.success(request, "File uploaded and data saved successfully!")
            return redirect("admin_dashboard")  # Change this to your admin URL
        
        except Exception as e:
            messages.error(request, f"Error processing file: {str(e)}")

    return render(request, "admin_upload.html")


# Load the trained XGBoost model
MODEL_PATH = r"C:\Users\delwi\credit_management\credit\models\xgb_model.pkl"
with open(MODEL_PATH, 'rb') as model_file:
    loan_model = pickle.load(model_file)

@login_required
def check_loan_eligibility(request):
    if request.method == "POST":
        try:
            # Collect input data
            num_dependents = int(request.POST["num_dependents"])
            education = int(request.POST["education"])  # Encode categorical fields
            self_employed = int(request.POST["self_employed"])  # Encode categorical fields
            income_annum = float(request.POST["income_annum"])
            loan_amount = float(request.POST["loan_amount"])
            loan_term = int(request.POST["loan_term"])
            cibil_score = int(request.POST["cibil_score"])
            residential_assets_value = float(request.POST["residential_assets_value"])
            commercial_assets_value = float(request.POST["commercial_assets_value"])
            luxury_assets_value = float(request.POST["luxury_assets_value"])
            bank_asset_value = float(request.POST["bank_asset_value"])

            # Prepare input data in model format
            input_data = np.array([
                [
                    num_dependents, education, self_employed,
                    income_annum, loan_amount, loan_term, cibil_score,
                    residential_assets_value, commercial_assets_value,
                    luxury_assets_value, bank_asset_value
                ]
            ])

            # Make prediction
            prediction = loan_model.predict(input_data)[0]  # Output: 1 (Eligible) or 0 (Not Eligible)

            if prediction == 1:
                messages.success(request, "Congratulations! You are eligible for a loan.")
            else:
                messages.error(request, "Sorry, you are not eligible for a loan.")

        except Exception as e:
            messages.error(request, f"Error processing request: {str(e)}")

    return render(request, "check_loan_eligibility.html")

# Register User
def register(request):
    if request.method == "POST":
        account_number = request.POST["account_number"]
        ifsc = request.POST["ifsc"]
        dob = request.POST["dob"]
        username = request.POST["username"]
        password = request.POST["password"]
        
        try:
            account = AccountHolder.objects.get(account_number=account_number, ifsc=ifsc, dob=dob)
            user = User.objects.create_user(username=username, password=password, account=account)
            return redirect("login")
        except AccountHolder.DoesNotExist:
            return render(request, "register.html", {"error": "Invalid account details"})

    return render(request, "register.html")

# Login View
def user_login(request):
    if request.method == "POST":
        username = request.POST["username"]
        password = request.POST["password"]
        user = authenticate(request, username=username, password=password)
        if user:
            login(request, user)
            if user.is_superuser:
                return redirect("admin_dashboard")
            else:
                return redirect("user_dashboard")
        else:
            return render(request, "login.html", {"error": "Invalid credentials"})
    return render(request, "login.html")

@login_required
def user_dashboard(request):
    return render(request, "user_dashboard.html", {"balance": request.user.account.balance})

@login_required
def apply_loan(request):
    if request.method == 'POST':
        # Collecting text input fields
        full_name = request.POST.get('full_name')
        email = request.POST.get('email')
        email_verified = request.POST.get('email_verified') == 'true'
        phone_number = request.POST.get('phone_number')
        loan_amount = request.POST.get('loan_amount')
        loan_purpose = request.POST.get('loan_purpose')
        employment_type = request.POST.get('employment_type')
        monthly_income = request.POST.get('monthly_income')
        loan_duration = request.POST.get('loan_duration')
        existing_loans = request.POST.get('existing_loans') == 'on'  # Checkbox handling

        # Collecting file uploads
        id_proof = request.FILES.get('id_proof')
        possession_certificate = request.FILES.get('possession_certificate')
        salary_slip = request.FILES.get('salary_slip')
        written_request = request.FILES.get('written_request')

        # Basic validation
        required_fields = [full_name, email, phone_number, loan_amount, loan_purpose, employment_type, monthly_income, loan_duration, id_proof, written_request]
        if not all(required_fields):
            messages.error(request, "Please fill all required fields.")
            return redirect('apply-loan')
        
        # Verify that email has been verified with OTP
        if not email_verified:
            messages.error(request, "Please verify your email with OTP before submitting.")
            return redirect('apply-loan')
        
        # Check if there's a verified OTP for this email
        try:
            otp_obj = EmailOTP.objects.get(email=email, is_verified=True)
        except EmailOTP.DoesNotExist:
            messages.error(request, "Email verification failed. Please verify your email.")
            return redirect('apply-loan')

        # Creating and saving the loan application
        LoanApplication.objects.create(
            user=request.user,
            full_name=full_name,
            email=email,
            phone_number=phone_number,
            loan_amount=loan_amount,
            loan_purpose=loan_purpose,
            employment_type=employment_type,
            monthly_income=monthly_income,
            loan_duration=loan_duration,
            existing_loans=existing_loans,
            id_proof=id_proof,
            possession_certificate=possession_certificate,
            salary_slip=salary_slip,
            written_request=written_request,
            status='Pending'
        )

        messages.success(request, "Loan application submitted successfully!")
        return redirect('user-dashboard')

    return render(request, 'apply_loan.html')@login_required
def apply_credit_card(request):
    if request.method == "POST":
        full_name = request.POST.get("full_name")
        email = request.POST.get("email")
        phone_number = request.POST.get("phone_number")
        employment_status = request.POST.get("employment_status")
        annual_income = request.POST.get("annual_income")
        cibil_score = request.POST.get("cibil_score")

        id_proof = request.FILES.get("id_proof")
        address_proof = request.FILES.get("address_proof")
        salary_slip = request.FILES.get("salary_slip")

        if not all([full_name, email, phone_number, employment_status, annual_income, cibil_score, id_proof, address_proof]):
            messages.error(request, "All required fields must be filled.")
            return redirect("apply_credit_card.html")

        try:
            annual_income = float(annual_income)
            cibil_score = int(cibil_score)
        except ValueError:
            messages.error(request, "Invalid income or CIBIL score format.")
            return redirect("apply_credit_card.html")

        # Create a new credit card application
        CreditCardApplication.objects.create(
            user=request.user,
            full_name=full_name,
            email=email,
            phone_number=phone_number,
            employment_status=employment_status,
            annual_income=annual_income,
            cibil_score=cibil_score,
            id_proof=id_proof,
            address_proof=address_proof,
            salary_slip=salary_slip
        )

        messages.success(request, "Credit Card Application Submitted Successfully!")
        return redirect("user_dashboard.html")

    return render(request, "apply_credit_card.html")

@login_required
def application_status(request):
    loans = LoanApplication.objects.filter(user=request.user)
    cards = CreditCardApplication.objects.filter(user=request.user)
    return render(request, "application_status.html", {"loans": loans, "cards": cards})

# Admin Dashboard
@login_required
def admin_dashboard(request):
    if not request.user.is_superuser:
        return redirect("user_dashboard")
    loans = LoanApplication.objects.all()
    cards = CreditCardApplication.objects.all()
    return render(request, "admin_dashboard.html", {"loans": loans, "cards": cards})

@login_required
def approve_loan(request, loan_id):
    loan = LoanApplication.objects.get(id=loan_id)
    loan.status = "Approved"
    loan.user.has_loan = True
    loan.save()
    return redirect("admin_dashboard")

@login_required
def reject_loan(request, loan_id):
    loan = LoanApplication.objects.get(id=loan_id)
    loan.status = "Rejected"
    loan.save()
    return redirect("admin_dashboard")

@login_required
def approve_credit_card(request, card_id):
    """ Approve a credit card application """
    card = get_object_or_404(CreditCardApplication, id=card_id)
    card.status = "Approved"
    card.save()
    messages.success(request, f"Credit Card Application for {card.user.username} has been approved.")
    return redirect('admin_dashboard')

@login_required
def reject_credit_card(request, card_id):
    """ Reject a credit card application """
    card = get_object_or_404(CreditCardApplication, id=card_id)
    card.status = "Rejected"
    card.save()
    messages.error(request, f"Credit Card Application for {card.user.username} has been rejected.")
    return redirect('admin_dashboard')


#Add these functions to your views.py
from datetime import datetime, timedelta
from decimal import Decimal
import calendar

@login_required
def disburse_loan(request, loan_id):
    if not request.user.is_superuser:
        messages.error(request, "You don't have permission to perform this action")
        return redirect("user_dashboard")
    
    loan = get_object_or_404(LoanApplication, id=loan_id)
    
    # Check if the loan is approved and not already disbursed
    if loan.status != "Approved":
        messages.error(request, "Only approved loans can be disbursed")
        return redirect("admin_dashboard")
    
    if hasattr(loan, 'disbursement'):
        messages.error(request, "This loan has already been disbursed")
        return redirect("admin_dashboard")
    
    if request.method == "POST":
        interest_rate = Decimal(request.POST.get('interest_rate'))
        
        # Calculate monthly installment using the formula for EMI:
        # EMI = [P x R x (1+R)^N]/[(1+R)^N-1]
        # Where P = Principal, R = Monthly interest rate, N = Number of months
        principal = Decimal(loan.loan_amount)
        tenure_months = int(loan.loan_duration)
        annual_interest = interest_rate
        monthly_interest = annual_interest / 12 / 100  # Convert annual percentage to monthly decimal
        
        # EMI calculation formula
        monthly_installment = principal * monthly_interest * (1 + monthly_interest) ** tenure_months
        monthly_installment = monthly_installment / ((1 + monthly_interest) ** tenure_months - 1)
        
        total_repayment = monthly_installment * Decimal(tenure_months)
        
        # Create loan disbursement record
        disbursement = LoanDisbursement.objects.create(
            loan_application=loan,
            loan_amount=principal,
            interest_rate=annual_interest,
            tenure_months=tenure_months,
            monthly_installment=monthly_installment.quantize(Decimal('0.01')),  # Round to 2 decimal places
            total_repayment_amount=total_repayment.quantize(Decimal('0.01'))
        )
        
        # Create installment records for each month
        today = datetime.now().date()
        for i in range(1, tenure_months + 1):
            # Calculate next month's date while handling month transitions correctly
            next_month = today.month + i
            next_year = today.year + (next_month - 1) // 12
            next_month = ((next_month - 1) % 12) + 1
            
            # Adjust for month length differences
            last_day = calendar.monthrange(next_year, next_month)[1]
            due_day = min(today.day, last_day)
            
            due_date = datetime(next_year, next_month, due_day).date()
            
            LoanInstallment.objects.create(
                disbursement=disbursement,
                due_date=due_date,
                amount=monthly_installment.quantize(Decimal('0.01'))
            )
        
        # Update user's account balance
        account = loan.user.account
        account.balance += principal
        account.save()
        
        messages.success(request, f"Loan of ₹{principal} has been disbursed to {loan.user.username}")
        return redirect("admin_dashboard")
    
    return render(request, "disburse_loan.html", {"loan": loan})



# Initialize Razorpay client
# Replace with your test API keys
razorpay_client = razorpay.Client(auth=("rzp_test_gozbzdgitkbAUC", "ztKv7PqOZgsMsk7fdRbdyOK4"))

@login_required
def loan_repayment_details(request, loan_id):
    loan = get_object_or_404(LoanApplication, id=loan_id)
    
    # Check if the user is the loan owner or an admin
    if request.user != loan.user and not request.user.is_superuser:
        messages.error(request, "You don't have permission to view this information")
        return redirect("user_dashboard")
    
    if not hasattr(loan, 'disbursement'):
        messages.error(request, "This loan has not been disbursed yet")
        return redirect("application_status" if not request.user.is_superuser else "admin_dashboard")
    
    # Get the disbursement and installment details
    disbursement = loan.disbursement
    installments = disbursement.installments.all().order_by('due_date')
    
    # Calculate projected balance (assuming payment of pending installments)
    account_balance = loan.user.account.balance
    next_installment = None
    simulated_balance = account_balance
    
    for installment in installments:
        if installment.status == 'Pending':
            if not next_installment and installment.due_date >= datetime.now().date():
                next_installment = installment
            simulated_balance -= installment.amount
    
    context = {
        "loan": loan,
        "disbursement": disbursement,
        "installments": installments,
        "current_balance": account_balance,
        "simulated_balance": simulated_balance,
        "next_installment": next_installment
    }
    
    return render(request, "loan_repayment_details.html", context)




@login_required
def create_razorpay_order(request, installment_id):
    """Create a Razorpay order for the installment payment"""
    installment = get_object_or_404(LoanInstallment, id=installment_id)
    loan_application = installment.disbursement.loan_application
    
    # Check if the user is authorized to pay this installment
    if request.user != loan_application.user:
        return JsonResponse({"error": "Unauthorized"}, status=403)
    
    # Check if installment is payable
    if not installment.is_payable():
        return JsonResponse({"error": "This installment is already paid"}, status=400)
    
    # Convert amount to paise (Razorpay uses smallest currency unit)
    amount_in_paise = int(float(installment.amount) * 100)
    
    # Create Razorpay Order
    razorpay_order = razorpay_client.order.create({
        "amount": amount_in_paise,
        "currency": "INR",
        "receipt": f"installment_{installment_id}",
        "payment_capture": 1,  # Auto-capture payment
        "notes": {
            "installment_id": installment_id,
            "loan_id": loan_application.id,
            "user_id": request.user.id
        }
    })
    
    # Save order ID to installment
    installment.order_id = razorpay_order['id']
    installment.save()
    
    return JsonResponse({
        "id": razorpay_order['id'],
        "amount": amount_in_paise,
        "currency": "INR",
        "name": f"Loan Installment {installment.due_date}",
        "description": f"Payment for loan #{loan_application.id}",
        "prefill": {
            "name": request.user.get_full_name() or request.user.username,
            "email": loan_application.email,
            "contact": loan_application.phone_number
        }
    })

@csrf_exempt
@login_required
def razorpay_callback(request):
    """Handle Razorpay payment callback"""
    if request.method == "POST":
        payment_id = request.POST.get('razorpay_payment_id', '')
        order_id = request.POST.get('razorpay_order_id', '')
        signature = request.POST.get('razorpay_signature', '')
        
        # Verify payment signature
        params_dict = {
            'razorpay_payment_id': payment_id,
            'razorpay_order_id': order_id,
            'razorpay_signature': signature
        }
        
        try:
            # Verify signature
            razorpay_client.utility.verify_payment_signature(params_dict)
            
            # Find installment by order_id
            installment = get_object_or_404(LoanInstallment, order_id=order_id)
            
            # Mark installment as paid
            installment.mark_as_paid(payment_id)
            
            # Update account balance
            user = installment.disbursement.loan_application.user
            account = user.account
            account.balance -= installment.amount
            account.save()
            
            messages.success(request, f"Payment of ₹{installment.amount} successful!")
            
        except Exception as e:
            messages.error(request, f"Payment verification failed: {str(e)}")
        
        # Redirect back to loan details page
        return redirect('loan_repayment_details', loan_id=installment.disbursement.loan_application.id)
    
    return HttpResponse("Invalid request", status=400)

# Add this function to simulate processing of due installments (could be called via cron job)
def process_due_installments():
    today = datetime.now().date()
    due_installments = LoanInstallment.objects.filter(due_date__lte=today, status='Pending')
    
    for installment in due_installments:
        # Deduct the installment amount from the user's account
        user = installment.disbursement.loan_application.user
        account = user.account
        
        if account.balance >= installment.amount:
            account.balance -= installment.amount
            account.save()
            installment.status = 'Paid'
            installment.save()
        else:
            installment.status = 'Overdue'
            installment.save()

@login_required
def disburse_credit_card(request, card_id):
    if not request.user.is_superuser:
        messages.error(request, "You don't have permission to perform this action")
        return redirect("user_dashboard")
    
    card = get_object_or_404(CreditCardApplication, id=card_id)
    
    # Check if the card application is approved and not already disbursed
    if card.status != "Approved":
        messages.error(request, "Only approved credit cards can be disbursed")
        return redirect("admin_dashboard")
    
    if hasattr(card, 'disbursement'):
        messages.error(request, "This credit card has already been disbursed")
        return redirect("admin_dashboard")
    
    # Calculate credit limit based on CIBIL score and annual income
    # This is a simple formula - you might want to adjust based on your business rules
    cibil_score = card.cibil_score
    annual_income = card.annual_income
    
    if cibil_score >= 750:
        # Excellent credit score
        credit_limit = min(annual_income * Decimal('0.4'), Decimal('500000'))
        interest_rate = Decimal('12.99')
    elif cibil_score >= 700:
        # Good credit score
        credit_limit = min(annual_income * Decimal('0.3'), Decimal('300000'))
        interest_rate = Decimal('14.99')
    elif cibil_score >= 650:
        # Fair credit score
        credit_limit = min(annual_income * Decimal('0.2'), Decimal('200000'))
        interest_rate = Decimal('18.99')
    else:
        # Poor credit score
        credit_limit = min(annual_income * Decimal('0.1'), Decimal('100000'))
        interest_rate = Decimal('21.99')
    
    if request.method == "POST":
        # If admin wants to override the calculated values
        credit_limit = Decimal(request.POST.get('credit_limit', credit_limit))
        interest_rate = Decimal(request.POST.get('interest_rate', interest_rate))
        
        # Create credit card disbursement record
        disbursement = CreditCardDisbursement.objects.create(
            credit_card_application=card,
            credit_limit=credit_limit.quantize(Decimal('0.01')),
            interest_rate=interest_rate
        )
        
        # Generate first monthly billing cycle (due in 30 days)
        due_date = datetime.now() + timedelta(days=30)
        
        # Minimum payment is typically 5% of the credit limit for the first month
        # (in a real system, this would be based on actual usage)
        minimum_payment = credit_limit * Decimal('0.05')
        
        CreditCardBilling.objects.create(
            disbursement=disbursement,
            due_date=due_date,
            amount=minimum_payment.quantize(Decimal('0.01')),
            status='Pending'
        )
        
        messages.success(request, f"Credit card with limit ₹{credit_limit} has been disbursed to {card.user.username}")
        return redirect('admin_dashboard')
    
    # If this is a GET request, render the form for admin to override values
    return render(request, 'disburse_credit_card.html', {
        'card': card,
        'suggested_credit_limit': credit_limit,
        'suggested_interest_rate': interest_rate
    })

@login_required
def credit_card_details(request, card_id):
    card = get_object_or_404(CreditCardApplication, id=card_id)
    
    # Make sure the user is viewing their own card
    if request.user != card.user and not request.user.is_superuser:
        messages.error(request, "You don't have permission to view this information")
        return redirect('user_dashboard')
    
    if not hasattr(card, 'disbursement'):
        messages.error(request, "This credit card has not been disbursed yet")
        return redirect('application_status')
    
    # Get billing information
    billings = card.disbursement.billings.all().order_by('due_date')
    
    return render(request, 'credit_card_details.html', {
        'card': card,
        'disbursement': card.disbursement,
        'billings': billings
    })

@login_required
def create_credit_card_payment_order(request, billing_id):
    billing = get_object_or_404(CreditCardBilling, id=billing_id)
    
    # Ensure the user owns this billing
    if request.user != billing.disbursement.credit_card_application.user:
        messages.error(request, "You don't have permission to make this payment")
        return redirect('user_dashboard')
    
    if not billing.is_payable():
        messages.error(request, "This bill has already been paid")
        return redirect('credit_card_details', card_id=billing.disbursement.credit_card_application.id)
    
    # Use hardcoded credentials like in the loan repayment
    client = razorpay.Client(auth=("rzp_test_gozbzdgitkbAUC", "ztKv7PqOZgsMsk7fdRbdyOK4"))
    
    amount = int(billing.amount * 100)  # Convert to paisa
    order_currency = 'INR'
    
    payment_order = client.order.create({
        'amount': amount,
        'currency': order_currency,
        'payment_capture': '1'  # Auto-capture
    })
    
    # Save order_id to billing
    billing.order_id = payment_order['id']
    billing.save()
    
    return render(request, 'credit_card_payment.html', {
        'billing': billing,
        'order_id': payment_order['id'],
        'amount': billing.amount,
        'razorpay_key_id': "rzp_test_gozbzdgitkbAUC"  # Hardcode this too
    })

@login_required
def razorpay_credit_card_callback(request):
    if request.method == "POST":
        payment_id = request.POST.get('razorpay_payment_id', '')
        order_id = request.POST.get('razorpay_order_id', '')
        signature = request.POST.get('razorpay_signature', '')
        
        # Verify signature
        client = razorpay.Client(auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_KEY_SECRET))
        
        try:
            client.utility.verify_payment_signature({
                'razorpay_payment_id': payment_id,
                'razorpay_order_id': order_id,
                'razorpay_signature': signature
            })
            
            # Find the billing by order_id
            try:
                billing = CreditCardBilling.objects.get(order_id=order_id)
                
                # Mark as paid
                billing.mark_as_paid(payment_id)
                
                messages.success(request, "Payment successful!")
                return redirect('credit_card_details', card_id=billing.disbursement.credit_card_application.id)
            
            except CreditCardBilling.DoesNotExist:
                messages.error(request, "Payment verification failed: Billing not found")
        
        except:
            messages.error(request, "Payment verification failed")
    
    return redirect('user_dashboard')


@login_required
def billing_details(request, billing_id):
    billing = get_object_or_404(CreditCardBilling, id=billing_id)
    
    # Make sure the user is viewing their own billing
    if request.user != billing.disbursement.credit_card_application.user and not request.user.is_superuser:
        messages.error(request, "You don't have permission to view this information")
        return redirect('user_dashboard')
    
    # Get payment information if available
    payment_info = None
    if billing.payment_id:
        # If you want to fetch detailed payment info from Razorpay
        # client = razorpay.Client(auth=(settings.RAZORPAY_KEY_ID, settings.RAZORPAY_KEY_SECRET))
        # payment_info = client.payment.fetch(billing.payment_id)
        
        # For now, just use the data we have
        payment_info = {
            'id': billing.payment_id,
            'date': billing.payment_date,
            'amount': billing.amount
        }
    
    return render(request, 'billing_details.html', {
        'billing': billing,
        'payment_info': payment_info,
        'card': billing.disbursement.credit_card_application,
        'disbursement': billing.disbursement
    })

    
@require_POST
def send_otp_view(request):
    try:
        data = json.loads(request.body)
        email = data.get('email')
        
        if not email:
            return JsonResponse({'success': False, 'message': 'Email is required'})
        
        # Send OTP to the provided email
        send_otp_email(email)
        
        return JsonResponse({'success': True, 'message': 'OTP sent successfully'})
    except Exception as e:
        return JsonResponse({'success': False, 'message': str(e)})

@require_POST
def verify_otp_view(request):
    try:
        data = json.loads(request.body)
        email = data.get('email')
        otp = data.get('otp')
        
        if not email or not otp:
            return JsonResponse({'success': False, 'message': 'Email and OTP are required'})
        
        # Verify the OTP
        if verify_otp(email, otp):
            return JsonResponse({'success': True, 'message': 'Email verified successfully'})
        else:
            return JsonResponse({'success': False, 'message': 'Invalid OTP'})
    except Exception as e:
        return JsonResponse({'success': False, 'message': str(e)})