Question 1
WITH SplitProducts AS (
  SELECT 
    OrderID,
    CustomerName,
    TRIM(value) AS Product
  FROM ProductDetail
  CROSS APPLY STRING_SPLIT(Products, ',')
)
SELECT 
  OrderID,
  CustomerName,
  Product
FROM SplitProducts
ORDER BY OrderID, Product;

Question 2
Step 1
-- Create the Orders table with OrderID as primary key
CREATE TABLE Orders AS
SELECT DISTINCT 
    OrderID, 
    CustomerName
FROM OrderDetails;

Step 2
-- Create the Order_Products table with composite primary key (OrderID, Product)
CREATE TABLE Order_Products AS
SELECT 
    OrderID, 
    Product, 
    Quantity
FROM OrderDetails;

Step 3
-- Add primary key to Orders table
ALTER TABLE Orders ADD PRIMARY KEY (OrderID);

-- Add composite primary key to Order_Products table
ALTER TABLE Order_Products ADD PRIMARY KEY (OrderID, Product);

Step 4
-- This query reconstructs the original data from the normalized tables
SELECT 
    op.OrderID,
    o.CustomerName,
    op.Product,
    op.Quantity
FROM 
    Order_Products op
JOIN 
    Orders o ON op.OrderID = o.OrderID
ORDER BY 
    op.OrderID, op.Product;
