-- Users table
CREATE TABLE users (
    user_id       VARCHAR(50)  PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    phone_number  VARCHAR(15),
    mail_id       VARCHAR(100) UNIQUE,
    billing_address TEXT
);

-- Rooms table (referenced by bookings)
CREATE TABLE rooms (
    room_no  VARCHAR(50) PRIMARY KEY
);

-- Bookings table
CREATE TABLE bookings (
    booking_id    VARCHAR(50)  PRIMARY KEY,
    booking_date  TIMESTAMP    NOT NULL,
    room_no       VARCHAR(50)  REFERENCES rooms(room_no),
    user_id       VARCHAR(50)  REFERENCES users(user_id)
);

-- Items table
CREATE TABLE items (
    item_id    VARCHAR(50)    PRIMARY KEY,
    item_name  VARCHAR(100)   NOT NULL,
    item_rate  DECIMAL(10, 2) NOT NULL
);

-- Booking commercials table
CREATE TABLE booking_commercials (
    id              VARCHAR(50)    PRIMARY KEY,
    booking_id      VARCHAR(50)    REFERENCES bookings(booking_id),
    bill_id         VARCHAR(50)    NOT NULL,
    bill_date       TIMESTAMP      NOT NULL,
    item_id         VARCHAR(50)    REFERENCES items(item_id),
    item_quantity   DECIMAL(10, 2) NOT NULL
);

-- Users
INSERT INTO users (user_id, name, phone_number, mail_id, billing_address) VALUES
('21wrcxuy-67erfn', 'John Doe',    '9712345678', 'john.doe@example.com',  '12, Street A, Mumbai'),
('32xsdtyv-78fgop', 'Jane Smith',  '9823456789', 'jane.smith@example.com','34, Street B, Delhi'),
('43yteuzw-89ghpq', 'Bob Wilson',  '9934567890', 'bob.wilson@example.com','56, Street C, Chennai'),
('54zufvax-90hiqr', 'Alice Brown', '9045678901', 'alice.brown@example.com','78, Street D, Kolkata');

-- Rooms
INSERT INTO rooms (room_no) VALUES
('rm-bhf9-aerjn'),
('rm-c2d4-bfskm'),
('rm-e5f6-cgtnp'),
('rm-g7h8-dhurq');

-- Bookings
INSERT INTO bookings (booking_id, booking_date, room_no, user_id) VALUES
('bk-09f3e-95hj', '2021-09-23 07:36:48', 'rm-bhf9-aerjn', '21wrcxuy-67erfn'),
('bk-q034-q4op',  '2021-09-23 08:15:00', 'rm-c2d4-bfskm', '32xsdtyv-78fgop'),
('bk-r145-r5pq',  '2021-09-24 09:00:00', 'rm-e5f6-cgtnp', '43yteuzw-89ghpq'),
('bk-s256-s6qr',  '2021-09-25 10:30:00', 'rm-g7h8-dhurq', '54zufvax-90hiqr');

-- Items
INSERT INTO items (item_id, item_name, item_rate) VALUES
('itm-a9e8-q8fu',  'Tawa Paratha',    18.00),
('itm-a07vh-aer8', 'Mix Veg',         89.00),
('itm-w978-23u4',  'Masala Chai',     30.00),
('itm-b123-cd45',  'Paneer Butter Masala', 149.00),
('itm-e678-fg90',  'Veg Biryani',     120.00),
('itm-h234-ij56',  'Cold Coffee',      60.00);

-- Booking Commercials
INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity) VALUES
('q34r-3q4o8-q34u', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a9e8-q8fu',  3),
('q3o4-ahf32-o2u4', 'bk-09f3e-95hj', 'bl-0a87y-q340', '2021-09-23 12:03:22', 'itm-a07vh-aer8', 1),
('134lr-oyfo8-3qk4','bk-q034-q4op',  'bl-34qhd-r7h8', '2021-09-23 12:05:37', 'itm-w978-23u4',  0.5),
('34qj-k3q4h-q34k', 'bk-q034-q4op',  'bl-34qhd-r7h8', '2021-09-23 12:05:37', 'itm-b123-cd45',  2),
('45rk-l4r5i-r45l', 'bk-r145-r5pq',  'bl-45rie-s8i9', '2021-09-24 13:10:00', 'itm-e678-fg90',  2),
('56sl-m5s6j-s56m', 'bk-r145-r5pq',  'bl-45rie-s8i9', '2021-09-24 13:10:00', 'itm-h234-ij56',  1),
('67tm-n6t7k-t67n', 'bk-s256-s6qr',  'bl-56sjf-t9j0', '2021-09-25 14:20:00', 'itm-a9e8-q8fu',  4),
('78un-o7u8l-u78o', 'bk-s256-s6qr',  'bl-56sjf-t9j0', '2021-09-25 14:20:00', 'itm-b123-cd45',  1);