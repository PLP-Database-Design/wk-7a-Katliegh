USE salesDB;

-- Question 1: Achieving 1NF (First Normal Form)

-- First, create a temporary table to hold the original unnormalized data
CREATE TABLE IF NOT EXISTS TempProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Products VARCHAR(255)
);

-- Insert the sample data into the temporary table
INSERT INTO TempProductDetail VALUES
(101, 'John Doe', 'Laptop, Mouse'),
(102, 'Jane Smith', 'Tablet, Keyboard, Mouse'),
(103, 'Emily Clark', 'Phone');

-- Transform to 1NF
-- Create the ProductDetail table that follows 1NF

-- Create a new ProductDetail table that follows 1NF
CREATE TABLE ProductDetail (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100)
);

-- Insert data into the 1NF table by splitting the comma-separated products
-- For OrderID 101
INSERT INTO ProductDetail VALUES
(101, 'John Doe', 'Laptop'),
(101, 'John Doe', 'Mouse');

-- For OrderID 102
INSERT INTO ProductDetail VALUES
(102, 'Jane Smith', 'Tablet'),
(102, 'Jane Smith', 'Keyboard'),
(102, 'Jane Smith', 'Mouse');

-- For OrderID 103
INSERT INTO ProductDetail VALUES
(103, 'Emily Clark', 'Phone');

-- Question 2: Achieving 2NF (Second Normal Form)

-- Create the OrderDetails table (already in 1NF)
CREATE TABLE IF NOT EXISTS TempOrderDetails (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

-- Insert the sample data
INSERT INTO TempOrderDetails VALUES
(101, 'John Doe', 'Laptop', 2),
(101, 'John Doe', 'Mouse', 1),
(102, 'Jane Smith', 'Tablet', 3),
(102, 'Jane Smith', 'Keyboard', 1),
(102, 'Jane Smith', 'Mouse', 2),
(103, 'Emily Clark', 'Phone', 1);

-- Transform to 2NF
-- Create two new tables to remove the partial dependency

-- Table for Order information (CustomerName depends only on OrderID)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Table for Order-Product details (Quantity depends on both OrderID and Product)
CREATE TABLE Product (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Insert unique orders into the Orders table
INSERT INTO Orders
SELECT DISTINCT OrderID, CustomerName FROM TempOrderDetails;

-- Insert order-product relationships into the Product table
INSERT INTO Product
SELECT OrderID, Product, Quantity FROM TempOrderDetails;

