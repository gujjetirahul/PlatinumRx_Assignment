CREATE TABLE clinics (
    cid       VARCHAR(20)  PRIMARY KEY,
    clinic_name VARCHAR(100) NOT NULL,
    city      VARCHAR(50),
    state     VARCHAR(50),
    country   VARCHAR(50)
);

CREATE TABLE customer (
    uid       VARCHAR(20)  PRIMARY KEY,
    name      VARCHAR(100) NOT NULL,
    mobile    VARCHAR(15)
);

CREATE TABLE clinic_sales (
    oid            VARCHAR(20)  PRIMARY KEY,
    uid            VARCHAR(20)  NOT NULL,
    cid            VARCHAR(20)  NOT NULL,
    amount         DECIMAL(10, 2) NOT NULL,
    datetime       DATETIME     NOT NULL,
    sales_channel  VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

CREATE TABLE expenses (
    eid         VARCHAR(20)  PRIMARY KEY,
    cid         VARCHAR(20)  NOT NULL,
    description VARCHAR(255),
    amount      DECIMAL(10, 2) NOT NULL,
    datetime    DATETIME     NOT NULL,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- clinics
INSERT INTO clinics (cid, clinic_name, city, state, country) VALUES
('cnc-0100001', 'XYZ Clinic',        'Lorem',    'Ipsum',      'Dolor'),
('cnc-0100002', 'Apollo Health',     'Mumbai',   'Maharashtra','India'),
('cnc-0100003', 'City Care Clinic',  'Hyderabad','Telangana',  'India'),
('cnc-0100004', 'MedPlus Center',    'Chennai',  'Tamil Nadu', 'India'),
('cnc-0100005', 'LifeLine Hospital', 'Bangalore','Karnataka',  'India');

-- customer
INSERT INTO customer (uid, name, mobile) VALUES
('bk-09f3e-95hj', 'Jon Doe',      '9700000001'),
('bk-09f3e-95hk', 'Jane Smith',   '9700000002'),
('bk-09f3e-95hl', 'Ravi Kumar',   '9700000003'),
('bk-09f3e-95hm', 'Priya Sharma', '9700000004'),
('bk-09f3e-95hn', 'Ali Hassan',   '9700000005');

-- clinic_sales
INSERT INTO clinic_sales (oid, uid, cid, amount, datetime, sales_channel) VALUES
('ord-00100-00100', 'bk-09f3e-95hj', 'cnc-0100001', 24999.00, '2021-09-23 12:03:22', 'sodat'),
('ord-00100-00101', 'bk-09f3e-95hk', 'cnc-0100002',  8500.00, '2021-10-01 09:15:00', 'online'),
('ord-00100-00102', 'bk-09f3e-95hl', 'cnc-0100003', 15000.00, '2021-10-05 14:22:10', 'walk-in'),
('ord-00100-00103', 'bk-09f3e-95hm', 'cnc-0100004', 32000.00, '2021-10-10 11:45:33', 'sodat'),
('ord-00100-00104', 'bk-09f3e-95hn', 'cnc-0100005',  5750.00, '2021-10-15 16:30:55', 'online'),
('ord-00100-00105', 'bk-09f3e-95hj', 'cnc-0100003', 11200.00, '2021-10-20 10:05:18', 'walk-in'),
('ord-00100-00106', 'bk-09f3e-95hk', 'cnc-0100001', 19800.00, '2021-10-22 13:50:44', 'sodat');

-- expenses
INSERT INTO expenses (eid, cid, description, amount, datetime) VALUES
('exp-0100-00100', 'cnc-0100001', 'first-aid supplies',  557.00, '2021-09-23 07:36:48'),
('exp-0100-00101', 'cnc-0100002', 'staff salaries',    45000.00, '2021-10-01 08:00:00'),
('exp-0100-00102', 'cnc-0100003', 'equipment maintenance', 3200.00, '2021-10-05 09:30:00'),
('exp-0100-00103', 'cnc-0100004', 'electricity bill',   1800.00, '2021-10-10 10:00:00'),
('exp-0100-00104', 'cnc-0100005', 'cleaning supplies',   420.00, '2021-10-15 07:15:00'),
('exp-0100-00105', 'cnc-0100001', 'rent',              25000.00, '2021-10-20 09:00:00'),
('exp-0100-00106', 'cnc-0100003', 'medical consumables', 6750.00, '2021-10-22 11:20:00');