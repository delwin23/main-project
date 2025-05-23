# Generated by Django 4.2.19 on 2025-03-02 13:06

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('banking', '0009_rename_credit_card_application_creditcarddisbursement_card_application_and_more'),
    ]

    operations = [
        migrations.RenameField(
            model_name='creditcarddisbursement',
            old_name='card_application',
            new_name='credit_card_application',
        ),
        migrations.RemoveField(
            model_name='creditcarddisbursement',
            name='annual_fee',
        ),
        migrations.RemoveField(
            model_name='creditcarddisbursement',
            name='disbursement_date',
        ),
        migrations.AddField(
            model_name='creditcarddisbursement',
            name='due_date',
            field=models.DateField(blank=True, null=True),
        ),
        migrations.AddField(
            model_name='creditcarddisbursement',
            name='emi_amount',
            field=models.DecimalField(blank=True, decimal_places=2, max_digits=12, null=True),
        ),
        migrations.AlterField(
            model_name='creditcarddisbursement',
            name='interest_rate',
            field=models.DecimalField(decimal_places=2, default=3.0, max_digits=5),
        ),
        migrations.DeleteModel(
            name='CreditCardBill',
        ),
    ]
