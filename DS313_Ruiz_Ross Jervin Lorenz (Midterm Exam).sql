-- October 18, 2025

-- Ross Jervin Lorenz B. Ruiz
-- 2023305556
-- BS Data Science DS3A
-- DS313 Advanced Database Management Systems (ADMS)
-- Midterm Exam

-- 1. Data Modeling (Designing the Full Database Schema)

-- A. Users in Chirp
CREATE TABLE chirp_users(
 	user_id SERIAL PRIMARY KEY,
 	fullname VARCHAR(100) NOT NULL,
	username VARCHAR(50) UNIQUE NOT NULL,
 	email VARCHAR(255) UNIQUE NOT NULL,
 	password TEXT NOT NULL,
	time_created_at TIMESTAMP DEFAULT NOW()
);

-- -- B. Posts in Chirp
CREATE TABLE chirp_posts(
	post_id SERIAL PRIMARY KEY,
 	user_id INT NOT NULL REFERENCES chirp_users(user_id) ON DELETE CASCADE,
	post_content TEXT NOT NULL CHECK (char_length(post_content) > 0),
	time_created_at TIMESTAMP DEFAULT NOW()
);

-- -- C. Comments in Chirp
CREATE TABLE chirp_comments(
	comment_id SERIAL PRIMARY KEY,
	post_id INT NOT NULL REFERENCES chirp_posts(post_id) ON DELETE CASCADE,
 	user_id INT NOT NULL REFERENCES chirp_users(user_id) ON DELETE CASCADE,
 	comment_content TEXT NOT NULL,
	time_created_at TIMESTAMP DEFAULT NOW()
);

-- -- D. Likes in Chirp
CREATE TABLE chirp_likes(
	like_id SERIAL PRIMARY KEY,
	post_id INT NOT NULL REFERENCES chirp_posts(post_id) ON DELETE CASCADE,
 	user_id INT NOT NULL REFERENCES chirp_users(user_id) ON DELETE CASCADE,
	time_created_at TIMESTAMP DEFAULT NOW(),
	UNIQUE (post_id, user_id) 
-- 	-- only one like per user per post
);

-- -- E. Follows (both followers and followed) in Chirp
CREATE TABLE chirp_follows(
	follower_id INT NOT NULL REFERENCES chirp_users(user_id) ON DELETE CASCADE,
	followed_id INT NOT NULL REFERENCES chirp_users(user_id) ON DELETE CASCADE,
	followed_at TIMESTAMP DEFAULT NOW(),
	PRIMARY KEY (follower_id, followed_id),
	CHECK (follower_id != followed_id) 
-- 	-- a user cannot follow themselves
);

-- -- F. Private Messages in Chirp
CREATE TABLE chirp_messages(
	message_id SERIAL PRIMARY KEY,
	sender_id INT NOT NULL REFERENCES chirp_users(user_id) ON DELETE CASCADE,
	receiver_id INT NOT NULL REFERENCES chirp_users(user_id) ON DELETE CASCADE,
	message_content TEXT NOT NULL,
	message_sent_at TIMESTAMP DEFAULT NOW()
);

-- **** END OF PART 1 ****


-- 2. CRUD Operations Using SQL Procedures

-- STEP 1: "Create" Operation (INSERT)
-- 1A. Create a User:
CREATE OR REPLACE PROCEDURE create_user(
    _fullname VARCHAR(100),
	   _username VARCHAR(50),
    _email VARCHAR(255),
    _password TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO chirp_users (fullname, username, email, password)
    VALUES (_fullname, _username, _email, _password);
END;
$$;

-- 1B. Create a Post:
CREATE OR REPLACE PROCEDURE create_post(
    _user_id INT,
	_post_content TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO chirp_posts (user_id, post_content)
    VALUES (_user_id, _post_content);
END;
$$;

-- 1C. Create/Add a Comment:
CREATE OR REPLACE PROCEDURE add_comment(
    _post_id INT,
	_user_id INT,
	_comment_content TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO chirp_comments (post_id, user_id, comment_content)
    VALUES (_post_id, _user_id, _comment_content);
END;
$$;

-- 1D. Like a Post:
CREATE OR REPLACE PROCEDURE like_post(
    _post_id INT,
	_user_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO chirp_likes (post_id, user_id)
    VALUES (_post_id, _user_id)
	ON CONFLICT (post_id, user_id) DO NOTHING;
-- Prevents duplicate likes
END;
$$;

-- 1E. Follow a User:
CREATE OR REPLACE PROCEDURE follow_user(
    _follower INT,
	_followed INT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO chirp_follows (follower_id, followed_id)
    VALUES (_follower, _followed)
	ON CONFLICT DO NOTHING;
-- Prevents duplicate follows
END;
$$;

-- 1F. Send a Message:
CREATE OR REPLACE PROCEDURE send_message(
    _sender INT,
	_receiver INT,
	_message_content TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO chirp_messages (sender_id, receiver_id, message_content)
    VALUES (_sender, _receiver, _message_content);
END;
$$;

-- STEP 2: "Read" Operation (SELECT)
-- 2A. Get All Users:
CREATE OR REPLACE FUNCTION get_all_users()
RETURNS TABLE(
	user_id INT,
    fullname VARCHAR,
	username VARCHAR,
    email VARCHAR,
    time_created_at TIMESTAMP
)
LANGUAGE sql
AS $$
	SELECT user_id, fullname, username, email, time_created_at
	FROM chirp_users
	ORDER BY time_created_at DESC;
$$;

-- 2B. Get All Posts:
CREATE OR REPLACE FUNCTION get_all_posts()
RETURNS TABLE(
	post_id INT,
    post_author VARCHAR,
    post_content TEXT,
    time_created_at TIMESTAMP
)
LANGUAGE sql
AS $$
	SELECT p.post_id, u.username AS post_author, p.post_content, p.time_created_at
	FROM chirp_posts p
	JOIN chirp_users u ON p.user_id = u.user_id
	ORDER BY p.time_created_at DESC;
$$;

-- STEP 3: "Update" Operation (UPDATE)
-- 3A. Change User's Fullname:
CREATE OR REPLACE PROCEDURE update_user_fullname(
	_user_id INT,
    _new_fullname VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE chirp_users
	SET fullname = _new_fullname
	WHERE user_id = _user_id;
END;
$$;

-- STEP 4: "Delete" Operation (DELETE)
-- 4A. Delete a User by User ID:
CREATE OR REPLACE PROCEDURE delete_user(
	_user_id INT
)
LANGUAGE plpgsql
AS $$
BEGIN
	DELETE FROM chirp_users
	WHERE user_id = _user_id;
END;
$$;

-- **** END OF PART 2 ****

-- Test Cases:
-- CALL create_user('Rjel Ruiz', 'rjelbruiz', 'rjelbruiz@example.com', 'qwertyuiop');
-- CALL create_post(1, 'My Test My Test!');
-- CALL add_comment(1, 1, 'Sound Check!');
-- SELECT * FROM get_all_posts();
