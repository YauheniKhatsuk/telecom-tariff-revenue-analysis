The database consists of several tables in the telecom schema: users, calls, internet, messages, and tariffs.

1. users

Contains information about the customers.

Field	Description
user_id	Unique identifier of the user (Primary Key)
age	Age of the user
churn_date	Contract end date; if the contract is active, this field is empty
city	User’s city of residence
first_name	First name of the user
last_name	Last name of the user
reg_date	Date of registration
tariff	User’s tariff plan (Foreign Key → tariffs.tariff_name)

2. calls

Contains information about phone calls.

Field	Description
id	Unique identifier of the call (Primary Key)
call_date	Date of the call
duration	Duration of the call in minutes
user_id	Identifier of the user who made the call (Foreign Key → users.user_id)

3. internet

Contains information about internet sessions.

Field	Description
id	Unique identifier of the session (Primary Key)
mb_used	Internet traffic used in megabytes during the session
session_date	Date of the session
user_id	Identifier of the user (Foreign Key → users.user_id)

4. messages

Contains information about messages sent by users.

Field	Description
id	Unique identifier of the message (Primary Key)
message_date	Date when the message was sent
user_id	Identifier of the user (Foreign Key → users.user_id)

5. tariffs

Contains information about the tariff plans.

Field	Description
tariff_name	Tariff name (Primary Key)
messages_included	Number of messages included in the plan
mb_per_month_included	Internet traffic included per month in MB
minutes_included	Number of call minutes included in the plan
rub_monthly_fee	Monthly subscription fee (RUB)
rub_per_gb	Cost per extra GB of internet traffic beyond the plan
rub_per_message	Cost per message beyond the plan
rub_per_minute	Cost per extra minute beyond the plan
Notes

1 GB = 1024 MB.

The tariff field in users links each user to their plan in tariffs.

This database can be used to calculate user activity, monthly spending, and over-limit charges for product analysis and revenue modeling.
