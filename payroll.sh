#!/bin/bash
echo "############ PAYROLL TIMESHEET #############"
echo "Note,
>> This database is searchable by HR staff only
>> Enter time in 24 hour format, i.e, for 7 am, only 7 but for 1 pm, 13.
>> Employees who work less than 32 hours, pay 5% in taxes.
>> Employees who work more than 32 hours but less than 40 hours, pay 10% in taxes.
>> Employees who work over 40 hours, pay 15% in taxes."

while :
do
echo -e "Main Menu: 1. Add Record 2. Search Records 3. Exit 
-----> \c"
read CHOICES
if [ $CHOICES = 3 ]
then
echo "Goodbye, Have a nice day!"
break
fi
if [ $CHOICES = 2 ]
then
echo "Search Records"
# Search function
while :
do
echo -e "Enter the employee ID or name to search --> \c"
read SEARCH
echo "Search Results:"
echo "========|==========|============|============|====|====|====|====|====|=======|============|====="
echo "Date | Full Name | Employee ID | Hourly Wage | Mon | Tue | Wed | Thu | Fri | Weekly | Monthly Pay | Tax"
echo "========|==========|============|============|====|====|====|====|====|=======|============|====="
grep -i "$SEARCH" payroll.txt | column -t -s "|"
echo "========|==========|============|============|====|====|====|====|====|=======|============|====="
#############REPEAT SEARCH##########
echo -e "Would you like to perfom another search? 1. YES 2. NO
--->\c"
read SEARCHagain
if [ $SEARCHagain = 2 ]
then
echo "Returning to main menu..." 
break
fi
if [ $SEARCHagain = 1 ]
then
echo -e "Enter the employee ID or name to search --> \c"
read secondSEARCH
echo "Search Results:"
echo "========|==========|============|============|====|====|====|====|====|=======|============|====="
echo "Date | Full Name | Employee ID | Hourly Wage | Mon | Tue | Wed | Thu | Fri | Weekly | Monthly Pay | Tax"
echo "========|==========|============|============|====|====|====|====|====|=======|============|====="
grep -i "$secondSEARCH" payroll.txt | column -t -s "|"
echo "========|==========|============|============|====|====|====|====|====|=======|============|====="
fi
done
fi
if [ $CHOICES = 1 ]
then 

echo -e "Enter the first date of the work week [MM/DD/YYYY] --> \c"
read DATE

echo -e "Please assign an employee ID --> \c"
read EMPLID ##### easier to search ##########

echo -e "Enter the full name of the employee --> \c"
read FULLNAME

echo -e "Enter the hourly pay for $FULLNAME --> \c"
read WAGE

echo "Employee ID: $EMPLID
Employee: $FULLNAME
Pay Rate: \$$WAGE/hr"

echo -e "Monday : Time In: \c"
read MONin
echo -e "Monday : Time Out: \c"
read MONout
MONhour=$(($MONout - $MONin))
echo "Monday Hours: $MONhour"

echo -e "Tuesday : Time In: \c"
read TUEin
echo -e "Tuesday : Time Out: \c"
read TUEout
TUEhour=$(($TUEout - $TUEin))
echo "Tuesday Hours: $TUEhour"

echo -e "Wednesday : Time In: \c"
read WEDin
echo -e "Wednesday : Time Out: \c"
read WEDout
WEDhour=$(($WEDout - $WEDin))
echo "Wednesday Hours: $WEDhour"

echo -e "Thursday : Time In: \c"
read THURin
echo -e "Thursday : Time Out: \c"
read THURout
THURhour=$(($THURout - $THURin))
echo "Thursday Hours: $THURhour"

echo -e "Friday : Time In: \c"
read FRIin
echo -e "Friday : Time Out: \c"
read FRIout
FRIhour=$(($FRIout - $FRIin))
echo "Friday Hours: $FRIhour"
###########PAY SUMMARY########################
echo "******* Pay Summary | $FULLNAME ********"
WEEKLY=$(($MONhour+$TUEhour+$WEDhour+$THURhour+$FRIhour))
echo "Total Weekly Hours: $WEEKLY"
WEEKpay=$(($WEEKLY * $WAGE))
echo "Total Weekly Pay: [$WEEKLY * \$$WAGE/hr] --> \$$WEEKpay"
MONTHpay=$(($WEEKpay * 4))
echo "Total Monthly Pay (before taxes): \$$MONTHpay"
#####################TAXES######################
if [ $WEEKLY -lt 32 ]
then
TAXfive=$(($MONTHpay *  5/100))
echo "Total amount of taxes: \$$TAXfive"
tax=$(($MONTHpay - $TAXfive))
echo "Total Monthly Pay (after Taxes): \$$tax"
elif [[ $WEEKLY -ge 32 && $WEEKLY -lt 40 ]]
then 
TAXten=$(($MONTHpay * 10/100)) 
echo "Total Amount of taxes: \$$TAXten"
SECONDtax=$(($MONTHpay - $TAXten))
echo "Total Monthly Pay (after taxes): \$$SECONDtax"
elif [[ $WEEKLY -ge 40 ]]
then
TAXfifteen=$(($MONTHpay * 15/100)) 
echo "Total Amont of taxes: \$$TAXfifteen"
THIRDtax=$(($MONTHpay - $TAXfifteen))
echo "Total Monthly Pay (after Taxes): \$$THIRDtax"
fi
############TABLE#####################
echo "*****************************"
echo "$DATE|$FULLNAME|$EMPLID|\$$WAGE|$MONhour|$TUEhour|$WEDhour|$THURhour|$FRIhour|$WEEKLY|\$$MONTHpay|\$$tax \$$SECONDtax \$$THIRDtax" >> payroll.txt
cat payroll.txt | column -t -s "|"
echo "Record added successfully! Returning to main menu..."
fi
done