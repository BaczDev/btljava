-- =============================
-- eShop Database Full Schema
-- Compatible with MySQL 8.0+
-- =============================

-- 1️⃣ Tạo Database
DROP DATABASE IF EXISTS eshop;
CREATE DATABASE eshop CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE eshop;

-- =============================
-- 2️⃣ Tạo các bảng
-- =============================

CREATE TABLE countries (
  country_id INT PRIMARY KEY AUTO_INCREMENT,
  country_name VARCHAR(100) NOT NULL
);

CREATE TABLE states (
  state_id INT PRIMARY KEY AUTO_INCREMENT,
  state_name VARCHAR(100) NOT NULL,
  country_id INT,
  FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

CREATE TABLE cities (
  city_id INT PRIMARY KEY AUTO_INCREMENT,
  city_name VARCHAR(100) NOT NULL,
  state_id INT,
  FOREIGN KEY (state_id) REFERENCES states(state_id)
);

CREATE TABLE address (
  address_id INT PRIMARY KEY AUTO_INCREMENT,
  street VARCHAR(255) NOT NULL,
  city_id INT,
  FOREIGN KEY (city_id) REFERENCES cities(city_id)
);

CREATE TABLE admin_types (
  type_id INT PRIMARY KEY AUTO_INCREMENT,
  type_name VARCHAR(100) NOT NULL
);

CREATE TABLE site_admins (
  admin_id INT PRIMARY KEY AUTO_INCREMENT,
  admin_name VARCHAR(100),
  Admin_type INT,
  FOREIGN KEY (Admin_type) REFERENCES admin_types(type_id)
);

CREATE TABLE site_users (
  user_id INT PRIMARY KEY AUTO_INCREMENT,
  user_name VARCHAR(100),
  email VARCHAR(100)
);

CREATE TABLE site_companies_info (
  company_id INT PRIMARY KEY AUTO_INCREMENT,
  company_name VARCHAR(255),
  login_id INT,
  FOREIGN KEY (login_id) REFERENCES site_admins(admin_id)
);

CREATE TABLE product_categories (
  category_id INT PRIMARY KEY AUTO_INCREMENT,
  category_name VARCHAR(100),
  parent_category_id INT,
  FOREIGN KEY (parent_category_id) REFERENCES product_categories(category_id)
);

CREATE TABLE brands (
  brand_id INT PRIMARY KEY AUTO_INCREMENT,
  brand_name VARCHAR(100)
);

CREATE TABLE product (
  product_id INT PRIMARY KEY AUTO_INCREMENT,
  product_name VARCHAR(255),
  category_id INT,
  brand_id INT,
  FOREIGN KEY (category_id) REFERENCES product_categories(category_id),
  FOREIGN KEY (brand_id) REFERENCES brands(brand_id)
);

CREATE TABLE product_item (
  product_item_id INT PRIMARY KEY AUTO_INCREMENT,
  product_id INT,
  sku VARCHAR(100),
  price DECIMAL(12,2),
  FOREIGN KEY (product_id) REFERENCES product(product_id)
);

CREATE TABLE shipping_method (
  shipping_method_id INT PRIMARY KEY AUTO_INCREMENT,
  method_name VARCHAR(100)
);

CREATE TABLE order_status (
  status_id INT PRIMARY KEY AUTO_INCREMENT,
  status_name VARCHAR(100)
);

CREATE TABLE payment_types (
  payment_type_id INT PRIMARY KEY AUTO_INCREMENT,
  payment_type_name VARCHAR(100)
);

CREATE TABLE payment_methods (
  payment_method_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  payment_type_id INT,
  provider VARCHAR(100),
  FOREIGN KEY (user_id) REFERENCES site_users(user_id),
  FOREIGN KEY (payment_type_id) REFERENCES payment_types(payment_type_id)
);

CREATE TABLE shop_order (
  order_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  payment_method_id INT,
  shipping_address INT,
  shipping_method INT,
  order_status INT,
  FOREIGN KEY (user_id) REFERENCES site_users(user_id),
  FOREIGN KEY (payment_method_id) REFERENCES payment_methods(payment_method_id),
  FOREIGN KEY (shipping_address) REFERENCES address(address_id),
  FOREIGN KEY (shipping_method) REFERENCES shipping_method(shipping_method_id),
  FOREIGN KEY (order_status) REFERENCES order_status(status_id)
);

CREATE TABLE order_line (
  order_line_id INT PRIMARY KEY AUTO_INCREMENT,
  order_id INT,
  product_item_id INT,
  quantity INT,
  FOREIGN KEY (order_id) REFERENCES shop_order(order_id),
  FOREIGN KEY (product_item_id) REFERENCES product_item(product_item_id)
);

CREATE TABLE user_review (
  review_id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT,
  ordered_product_id INT,
  review_text VARCHAR(255),
  FOREIGN KEY (user_id) REFERENCES site_users(user_id),
  FOREIGN KEY (ordered_product_id) REFERENCES order_line(order_line_id)
);

CREATE TABLE user_address_mapping (
  user_id INT,
  address_id INT,
  FOREIGN KEY (user_id) REFERENCES site_users(user_id),
  FOREIGN KEY (address_id) REFERENCES address(address_id)
);

-- =============================
-- 3️⃣ Dữ liệu mẫu
-- =============================

INSERT INTO countries (country_id, country_name) VALUES
(1, 'Vietnam'),
(2, 'United States'),
(3, 'Japan');

INSERT INTO states (state_id, state_name, country_id) VALUES
(1, 'Hanoi', 1),
(2, 'Ho Chi Minh City', 1),
(3, 'California', 2),
(4, 'Tokyo', 3);

INSERT INTO cities (city_id, city_name, state_id) VALUES
(1, 'Ba Dinh', 1),
(2, 'District 1', 2),
(3, 'Los Angeles', 3),
(4, 'Shibuya', 4);

INSERT INTO address (address_id, street, city_id) VALUES
(1, '123 Nguyen Trai', 2),
(2, '456 Kim Ma', 1),
(3, '789 Hollywood Blvd', 3),
(4, '101 Sakura St', 4);

INSERT INTO admin_types (type_id, type_name) VALUES
(1, 'Super Admin'),
(2, 'Manager');

INSERT INTO site_admins (admin_id, admin_name, Admin_type) VALUES
(1, 'John Admin', 1),
(2, 'Linh Manager', 2);

INSERT INTO site_users (user_id, user_name, email) VALUES
(1, 'user1', 'user1@gmail.com'),
(2, 'user2', 'user2@gmail.com');

INSERT INTO site_companies_info (company_id, company_name, login_id) VALUES
(1, 'Eshop Vietnam', 1);

INSERT INTO product_categories (category_id, category_name, parent_category_id) VALUES
(1, 'Electronics', NULL),
(2, 'Phones', 1);

INSERT INTO brands (brand_id, brand_name) VALUES
(1, 'Apple'),
(2, 'Samsung');

INSERT INTO product (product_id, product_name, category_id, brand_id) VALUES
(1, 'iPhone 15', 2, 1),
(2, 'Galaxy S24', 2, 2);

INSERT INTO product_item (product_item_id, product_id, sku, price) VALUES
(1, 1, 'IP15-BLK', 25000000),
(2, 2, 'S24-WHT', 23000000);

INSERT INTO shipping_method (shipping_method_id, method_name) VALUES
(1, 'Standard Delivery'),
(2, 'Express Delivery');

INSERT INTO order_status (status_id, status_name) VALUES
(1, 'Pending'),
(2, 'Completed');

INSERT INTO payment_types (payment_type_id, payment_type_name) VALUES
(1, 'Credit Card'),
(2, 'Cash On Delivery');

INSERT INTO payment_methods (payment_method_id, user_id, payment_type_id, provider) VALUES
(1, 1, 1, 'VISA'),
(2, 2, 2, 'COD');

INSERT INTO shop_order (order_id, user_id, payment_method_id, shipping_address, shipping_method, order_status) VALUES
(1, 1, 1, 1, 1, 1),
(2, 2, 2, 2, 2, 2);

INSERT INTO order_line (order_line_id, order_id, product_item_id, quantity) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2);

INSERT INTO user_review (review_id, user_id, ordered_product_id, review_text) VALUES
(1, 1, 1, 'Sản phẩm tốt');

INSERT INTO user_address_mapping (user_id, address_id) VALUES
(1, 1),
(2, 2);

COMMIT;
