-- B. Transformation function
CREATE OR REPLACE FUNCTION format_date(date_input DATE)
RETURNS VARCHAR AS 
$$
BEGIN
    RETURN TO_CHAR(date_input, 'MM-DD-YYYY');
END; 
$$ 
LANGUAGE plpgsql;

-- Transformation function #2
CREATE OR REPLACE FUNCTION format_time(time_input TIME)
RETURNS VARCHAR AS 
$$
BEGIN
    RETURN EXTRACT(HOUR FROM time_input) || ' hours and ' ||
           EXTRACT(MINUTE FROM time_input) || ' minutes';
END;
$$
LANGUAGE plpgsql;

-- C. Creation of the detailed and summary tables.
CREATE TABLE detailed_monthly_rental_table (
    rental_month DATE,
    dvd_title VARCHAR(255),
    actor_name VARCHAR(255),
    film_category VARCHAR(100),
    number_of_rentals INT
);

CREATE TABLE summary_monthly_rental_table (
    rental_month DATE,
    actor_name VARCHAR(255),
    film_category VARCHAR(100),
    total_rentals INT
);

-- D. Adding raw data from source to detailed_monthly_rental_table
INSERT INTO detailed_monthly_rental_table (
    rental_month, dvd_title, actor_name, film_category, number_of_rentals)
SELECT
    DATE_TRUNC('month', r.rental_date) AS rental_month,
    f.title AS dvd_title,
    CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
    c.name AS film_category,
    COUNT(r.rental_id) AS number_of_rentals
FROM
    rental r
JOIN
    inventory i ON r.inventory_id = i.inventory_id
JOIN
    film f ON i.film_id = f.film_id
JOIN
    film_category fc ON f.film_id = fc.film_id
JOIN
    category c ON fc.category_id = c.category_id
JOIN
    film_actor fa ON f.film_id = fa.film_id
JOIN
    actor a ON fa.actor_id = a.actor_id
GROUP BY
    rental_month, dvd_title, actor_name, film_category
ORDER BY
    rental_month, dvd_title, actor_name;

-- E. Trigger that updates the summary table, when data is added to detailed table
CREATE OR REPLACE FUNCTION update_summary_table()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO summary_monthly_rental_table (rental_month, actor_name, film_category, total_rentals)
    VALUES (
        NEW.rental_month,
        NEW.actor_name,
        NEW.film_category,
        NEW.number_of_rentals
    )
    ON CONFLICT (rental_month, actor_name, film_category)
    DO UPDATE SET
        total_rentals = summary_monthly_rental_table.total_rentals + EXCLUDED.total_rentals;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_summary_trigger
AFTER INSERT ON detailed_monthly_rental_table
FOR EACH ROW
EXECUTE FUNCTION update_summary_table();

-- F. Stored Procedure to Refresh the Data 
CREATE OR REPLACE PROCEDURE refresh_data()
LANGUAGE plpgsql
AS $$
BEGIN 
    -- clears the content of both tables detailed and summary
    TRUNCATE TABLE detailed_monthly_rental_table;
    TRUNCATE TABLE summary_monthly_rental_table;
    
    -- Repopulates the detailed table like task D and extracts raw data. 
    INSERT INTO detailed_monthly_rental_table (rental_month, dvd_title, actor_name, film_category, number_of_rentals)
    SELECT 
        DATE_TRUNC('month', r.rental_date) AS rental_month, -- data transformation
        f.title AS dvd_title, -- extracts film title
        CONCAT(a.first_name, ' ', a.last_name) AS actor_name, --combines first last name
        c.name AS film_category, --extracts the film category name
        COUNT(r.rental_id) AS number_of_rentals
    FROM
        rental r
    JOIN
        inventory i ON r.inventory_id = i.inventory_id
    JOIN
        film f ON i.film_id = f.film_id
    JOIN
        film_category fc ON f.film_id = fc.film_id
    JOIN 
        category c ON fc.category_id = c.category_id
    JOIN
        film_actor fa ON f.film_id = fa.film_id
    JOIN
        actor a ON fa.actor_id = a.actor_id
    GROUP BY
        rental_month, dvd_title, actor_name, film_category
    ORDER BY
        rental_month, dvd_title, actor_name;
END;
$$;

-- Adding unique constraint so ON CONFLICT can identify existing rows 
ALTER TABLE summary_monthly_rental_table
ADD CONSTRAINT unique_summary_combination
UNIQUE (rental_month, actor_name, film_category);


-- Execute/Call the procedure to refresh the data
CALL refresh_data();



-- DROPS EVERYTHING to rerun query from start
DROP TRIGGER IF EXISTS update_summary_trigger ON detailed_monthly_rental_table;
DROP FUNCTION IF EXISTS update_summary_table();
DROP FUNCTION IF EXISTS format_date(date_input DATE);
DROP FUNCTION IF EXISTS format_time(time_input TIME);
DROP PROCEDURE IF EXISTS refresh_date;
DROP TABLE IF EXISTS detailed_monthly_rental_table;
DROP TABLE IF EXISTS summary_monthly_rental_table;
