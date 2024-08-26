
A. Summarize
DVD Rental Store wants to find out how many DVDs are rented per month based on the film actor and the film category in order to calculate which DVDs to overstock for the next restock.

A1. Identify the specific fields that will be included in the detailed table and the summary table of the report. 
Detailed Table: detailed_monthly_rental_table
Column	Data Type
rental_month	DATE
dvd_title	VARCHAR(255)
actor_name	VARCHAR(255)
film_category	VARCHAR(100)
number_of_rentals	 INT

Summary Table: summary_monthly_rental_table
Column	Data Type
rental_month	DATE
actor_name	VARCHAR(255)
film_category	VARCHAR(100)
total_rentals	INT



A2. Describe the types of data fields used for the report.
Detailed Table: detailed_monthly_rental_table
•	DATE: rental_month
•	VARCHAR: dvd_title, actor_name, film_category
•	INTEGER: number_of_rentals
Summary Table: summary_monthly_rental_table
•	DATE: rental_month
•	VARCHAR: actor_name, film_category
•	INTEGER: total_rentals
Explanation: Basically, the DATE field displays the rental months, and VARCHAR is used to store string fields for the names of DVD titles, actor names, and film categories. Finally, INTEGER is used to display the number of rentals based on film category or the total rentals for the summary table.

A3. Identify at least two specific tables from the given dataset that will provide the data necessary for the detailed table section and the summary table section of the report.
-	Rental Table, this table will provide the rental dates in specific detail as well as the retantal ID to determine the number of people renting DVDs.
-	Category Table, this table will contain information about the category of films and the ID of the films.
-	Actor Table, finally, the Actor Table will provide the ID of actors as well as the actors' names, linking to the Film Table to determine how these two are correlated.

A4. Identify at least one field in the detailed table section that will require a custom transformation with a user-defined function and explain why it should be transformed (e.g., you might translate a field with a value of N to No and Y to Yes).
I have chosen two fields that will require a transformation for visual clarity. I switched the rental_date display format to the standard date format used in the USA, which is MM-DD-YYYY, from DD-MM-YYYY. I also transformed the total rental time of DVDs to a more visually appealing format, changing it from the standard time of 22:03:00 to 22 hours and 3 minutes, clearly displaying the total rental duration.

A5. Explain the different business uses of the detailed table section and the summary table section of the report.
The business use for the detailed table is to provide information regarding dates, actors, and film categories to help the business track which DVDs are rented and which actor and categorie they are associate with specifically. The summary table, on the other hand, gives the total rentals overall, which can help the business determine how much stock will be needed and the overall total of rented DVDs based on dates, actors and film category.

A6. Explain how frequently your report should be refreshed to remain relevant to stakeholders.
The report I made should be refreshed on a monthly basis. A monthly report will keep up-to-date information on relevant titles, actors, and films that could be included in the store for restocking. It will also help track inventory needs to make informed decisions on which titles are relevant, ensuring customer satisfaction with the DVDs offered by the store.

F 1. Identify a relevant job scheduling tool that can be used to automate the stored procedure.
pgAgent or pgCron they are build in PostgreSQL

H. SOURCES 
PostgreSQL Global Development Group. (2024). Triggers. PostgreSQL Documentation. https://www.postgresql.org/docs/17/plpgsql-trigger.html#PLPGSQL-EVENT-TRIGGER
