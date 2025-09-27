-- September 27, 2025
-- 
-- Ross Jervin Lorenz B. Ruiz
-- 2023305556
-- BS Data Science DS3A
-- DS313 Advanced Database Management and Systems (ADMS)
-- Lab Activity 5

-- CREATE TABLE books_stocks(
-- 	book_id SERIAL PRIMARY KEY,
-- 	book_title VARCHAR(255),
-- 	book_author VARCHAR(255),
-- 	book_genre VARCHAR(255),
-- 	book_price numeric(10,2)
-- );

-- CREATE TABLE books_logs(
-- 	booklog_id SERIAL PRIMARY KEY,
-- 	action_time TIMESTAMP DEFAULT now(),
-- 	action VARCHAR(255),
-- 	edited_author VARCHAR(255)
-- );

-- INSERT INTO books_stocks VALUES(0001, 'Inferno', 'Dan Brown', 'Fictional', 30);
-- INSERT INTO books_stocks VALUES(0002, 'To Ride A Motorcycle', 'Kyle Mallari', 'Non-Fictional', 20);
-- INSERT INTO books_stocks VALUES(0003, 'How To Move On Quick', 'Ralo Ratunil', 'Fictional', 22);
-- INSERT INTO books_stocks VALUES(0004, 'Tips on Sleeping', 'Amiel Nayve', 'Non-Fictional', 20);
-- INSERT INTO books_stocks VALUES(0005, 'Pink Fashion 101', 'Gabby Lapad', 'Non-Fictional', 18);

-- SELECT * FROM books_stocks;

-- Procedure
-- CREATE PROCEDURE insert_books(
-- 	book_id INTEGER,
-- 	book_title VARCHAR(255),
-- 	book_author VARCHAR(255),
-- 	book_genre VARCHAR(255),
-- 	book_price numeric(10,2)
-- 	)
	
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- 	INSERT INTO books_stocks VALUES (book_id, book_title, book_author, book_genre, book_price);
-- END;
-- $$;

-- CALL insert_books(10, 'ADMS Tips', 'Marlou Apaya', 'Non-Fictional', 21);
-- SELECT * FROM books_stocks;

-- Function
-- CREATE FUNCTION bp_to_peso(bp numeric(10,2))
-- RETURNS numeric(10,2)
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- 	RETURN bp * 58;
-- END;
-- $$;

-- SELECT book_title, bp_to_peso(book_price) FROM books_stocks;

-- Trigger
-- CREATE FUNCTION insert_book_log()
-- RETURNS TRIGGER
-- LANGUAGE plpgsql
-- AS $$
-- BEGIN
-- 	INSERT INTO books_logs(action, edited_author) VALUES ('INSERT', NEW.book_author);
-- 	RETURN NEW;
-- END;
-- $$;

-- CREATE TRIGGER after_book_log
-- AFTER INSERT on books_stocks
-- FOR EACH ROW
-- EXECUTE FUNCTION insert_book_log();

-- INSERT INTO books_stocks(book_id, book_title, book_author, book_genre, book_price) VALUES (11, 'ML Tips', 'Rosemarie' , 'Fictional' , 16);


-- Fetch
SELECT * FROM books_stocks;