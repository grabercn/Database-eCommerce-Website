-- Database Requirements



/* User requirements
 * The application should support two types of users.
 * 1.) Customers: Customers of the store can search for products and look up information about
 *     products, set up an account and change their preferences and account details, order
 *     products, and make payments. For each customer, the application should record the NAME
 *     of the customer, one or more ADDRESSES (address for delivery and/or for payment), and 
 *     CREDIT CARD information. A customer can have multiple credit cards and each credit card
 *     should be associated with a payment address. For each customer, the database should
 *     maintain the current BALANCE of the customer’s account, i.e., the dollar amount of
 *     outstanding payments for the customer.
 * 2.) Staff Members: Staff of the store can modify and create products, update the
 *     availability of products in the stock, query customer information, and process orders.
 *     The database stores NAME, ADDRESS, SALARY, and JOB TITLE.
 */

/*
-- Create the Users table if it doesn't exist
CREATE TABLE IF NOT EXISTS Users (
    user_id SERIAL PRIMARY KEY,
    user_type VARCHAR(20) NOT NULL, -- The application should support two types of users
    name VARCHAR(100) NOT NULL, -- For each customer, the application should record the NAME of the customer
);
*/

-- Create the Addresses table (for both delivery and payment addresses)
-- For each customer, the application should record one or more ADDRESSES (address for
-- delivery and/or for payment)


--DROP SCHEMA public CASCADE;

CREATE TABLE IF NOT EXISTS Addresses (
    address_id SERIAL PRIMARY KEY,
    address_type VARCHAR(20) NOT NULL, -- 'Delivery' or 'Payment'
    street_address VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(50) NOT NULL,
    zip_code VARCHAR(10) NOT NULL
);

-- Create the CreditCards table (for multiple credit cards per user)
CREATE TABLE IF NOT EXISTS CreditCards (
    card_id SERIAL PRIMARY KEY,
    card_number VARCHAR(20) NOT NULL,
    expiration_date DATE NOT NULL,
	address_id SERIAL NOT NULL,
	FOREIGN KEY (address_id) REFERENCES Addresses(address_id)
);

CREATE TABLE IF NOT EXISTS Customers (
	customer_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	address_id SERIAL NOT NULL,
	card_id SERIAL NOT NULL,
	balance DECIMAL(10, 2) DEFAULT 0.0,
	FOREIGN KEY (address_id) REFERENCES Addresses(address_id),
	FOREIGN KEY (card_id) REFERENCES CreditCards(card_id)
);

-- Create the StaffMembers table
CREATE TABLE IF NOT EXISTS StaffMembers (
    staff_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address_id SERIAL NOT NULL,
    salary DECIMAL(10, 2) NOT NULL,
    job_title VARCHAR(50) NOT NULL,
	FOREIGN KEY (address_id) REFERENCES Addresses(address_id)
);

-- Create the Products table
CREATE TABLE IF NOT EXISTS Products (
    product_id SERIAL PRIMARY KEY,
    category VARCHAR(50) NOT NULL,
    product_name VARCHAR(100) NOT NULL,
    brand VARCHAR(50),
    size VARCHAR(20),
    description TEXT,
    price DECIMAL(10, 2) NOT NULL
);

-- Create the Warehouses table
CREATE TABLE IF NOT EXISTS Warehouses (
    warehouse_id SERIAL PRIMARY KEY,
    address_id SERIAL NOT NULL,
    capacity INT NOT NULL, -- New field for warehouse capacity
	FOREIGN KEY (address_id) REFERENCES Addresses(address_id)
);

-- Create the Stock table
CREATE TABLE IF NOT EXISTS Stock (
    stock_id SERIAL PRIMARY KEY,
    product_id SERIAL NOT NULL,
    warehouse_id SERIAL NOT NULL,
    quantity INT NOT NULL,
	FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),
	FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Create the Orders table
CREATE TABLE IF NOT EXISTS Orders (
    order_id SERIAL PRIMARY KEY,
    order_status VARCHAR(20) NOT NULL, -- 'Issued', 'Sent', or 'Received'
	customer_id SERIAL NOT NULL,
    card_id SERIAL NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	FOREIGN KEY (card_id) REFERENCES CreditCards(card_id),
	FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Create the OrderItems table
CREATE TABLE IF NOT EXISTS OrderItems (
    order_item_id SERIAL PRIMARY KEY,
    order_id SERIAL NOT NULL,
    product_id SERIAL NOT NULL,
    quantity INT NOT NULL,
	FOREIGN KEY (order_id) REFERENCES Orders(order_id),
	FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Create the DeliveryPlan table
CREATE TABLE IF NOT EXISTS DeliveryPlan (
    order_id SERIAL NOT NULL,
    delivery_type VARCHAR(20) NOT NULL, -- 'Express', 'Standard', or 'Customizable'
    delivery_price DECIMAL(10, 2) NOT NULL,
    delivery_date DATE NOT NULL,
    ship_date DATE NOT NULL,
	FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Create the Suppliers table
CREATE TABLE IF NOT EXISTS Suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    address_id SERIAL NOT NULL,
	FOREIGN KEY (address_id) REFERENCES Addresses(address_id)
);

-- Create the SupplierItems table (for supplier-specific prices)
CREATE TABLE IF NOT EXISTS SupplierItems (
    supplier_id SERIAL NOT NULL,
    product_id SERIAL NOT NULL,
    supplier_price DECIMAL(10, 2) NOT NULL,
	FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),
	FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
