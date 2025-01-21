USE ecommerce;

-- Insert Users
INSERT INTO users (email, password_hash, first_name, last_name, phone, is_admin) VALUES
('john.doe@email.com', 'hashed_password_1', 'John', 'Doe', '+1-555-0123', FALSE),
('jane.smith@email.com', 'hashed_password_2', 'Jane', 'Smith', '+1-555-0124', FALSE),
('admin@ecommerce.com', 'admin_password_hash', 'Admin', 'User', '+1-555-0125', TRUE),
('mike.wilson@email.com', 'hashed_password_4', 'Mike', 'Wilson', '+1-555-0126', FALSE),
('sarah.brown@email.com', 'hashed_password_5', 'Sarah', 'Brown', '+1-555-0127', FALSE);

-- Insert User Addresses
INSERT INTO user_addresses (user_id, address_type, street_address, city, state, postal_code, country, is_default) VALUES
(1, 'SHIPPING', '123 Main St', 'New York', 'NY', '10001', 'USA', TRUE),
(1, 'BILLING', '123 Main St', 'New York', 'NY', '10001', 'USA', TRUE),
(2, 'SHIPPING', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA', TRUE),
(2, 'BILLING', '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA', TRUE),
(3, 'SHIPPING', '789 Pine Rd', 'Chicago', 'IL', '60601', 'USA', TRUE);

-- Insert Categories
INSERT INTO categories (name, description, image_url) VALUES
('Electronics', 'Electronic devices and accessories', 'electronics.jpg'),
('Smartphones', 'Mobile phones and accessories', 'smartphones.jpg'),
('Laptops', 'Notebooks and accessories', 'laptops.jpg'),
('Fashion', 'Clothing and accessories', 'fashion.jpg'),
('Books', 'Physical and digital books', 'books.jpg');

-- Update parent categories
UPDATE categories SET parent_category_id = 1 WHERE category_id IN (2, 3);

-- Insert Brands
INSERT INTO brands (name, description, website, founded_year) VALUES
('Apple', 'Consumer electronics manufacturer', 'www.apple.com', 1976),
('Samsung', 'Electronics manufacturer', 'www.samsung.com', 1938),
('Dell', 'Computer hardware company', 'www.dell.com', 1984),
('Nike', 'Sports apparel and equipment', 'www.nike.com', 1964),
('Amazon Basics', 'Amazon house brand', 'www.amazon.com', 2009);

-- Insert Products
INSERT INTO products (category_id, brand_id, name, description, sku, price, msrp, weight) VALUES
(2, 1, 'iPhone 14 Pro', '6.1-inch iPhone 14 Pro 256GB', 'IPH14P-256', 999.99, 1099.99, 0.45),
(2, 2, 'Samsung Galaxy S23', '6.8-inch Galaxy S23 Ultra 512GB', 'SGAS23-512', 1199.99, 1299.99, 0.50),
(3, 3, 'Dell XPS 15', '15-inch Dell XPS laptop', 'DELL-XPS15', 1799.99, 1999.99, 2.20),
(4, 4, 'Nike Air Max', 'Nike Air Max Running Shoes', 'NIKE-AM2023', 129.99, 149.99, 0.30),
(5, 5, 'Kindle Paperwhite', 'Amazon Kindle E-reader', 'KINDLE-PW', 139.99, 159.99, 0.20);

-- Insert Product Images
INSERT INTO product_images (product_id, image_url, alt_text, is_primary) VALUES
(1, 'iphone14pro.jpg', 'iPhone 14 Pro in Deep Purple', TRUE),
(2, 'galaxys23.jpg', 'Samsung Galaxy S23 Ultra in Phantom Black', TRUE),
(3, 'dellxps15.jpg', 'Dell XPS 15 Laptop', TRUE),
(4, 'nikeairmax.jpg', 'Nike Air Max Shoes', TRUE),
(5, 'kindle.jpg', 'Kindle Paperwhite E-reader', TRUE);

-- Insert Product Attributes
INSERT INTO product_attributes (product_id, name, value) VALUES
(1, 'Color', 'Deep Purple'),
(1, 'Storage', '256GB'),
(2, 'Color', 'Phantom Black'),
(2, 'Storage', '512GB'),
(3, 'Processor', 'Intel i9-12900HK');

-- Insert Warehouses
INSERT INTO warehouses (name, address, city, state, postal_code, country) VALUES
('NY Warehouse', '100 Distribution Ave', 'New York', 'NY', '10001', 'USA'),
('LA Warehouse', '200 Logistics Blvd', 'Los Angeles', 'CA', '90001', 'USA'),
('Chicago Hub', '300 Supply Chain Rd', 'Chicago', 'IL', '60601', 'USA');

-- Insert Inventory
INSERT INTO inventory (product_id, warehouse_id, quantity, low_stock_threshold) VALUES
(1, 1, 100, 20),
(1, 2, 150, 20),
(2, 1, 75, 15),
(3, 3, 50, 10),
(4, 2, 200, 30);

-- Insert Inventory Transactions
INSERT INTO inventory_transactions (inventory_id, transaction_type, quantity, reference_id) VALUES
(1, 'RECEIPT', 100, 'PO-001'),
(2, 'RECEIPT', 150, 'PO-002'),
(3, 'SHIPMENT', -5, 'ORD-001'),
(4, 'ADJUSTMENT', -2, 'ADJ-001'),
(5, 'RETURN', 1, 'RET-001');

-- Insert Shopping Carts
INSERT INTO carts (user_id) VALUES
(1),
(2),
(4);

-- Insert Cart Items
INSERT INTO cart_items (cart_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 3, 1),
(2, 2, 1),
(3, 4, 2);

-- Insert Orders
INSERT INTO orders (user_id, status, total_amount, shipping_address_id, billing_address_id, shipping_method, payment_method) VALUES
(1, 'DELIVERED', 2799.98, 1, 2, 'Express', 'Credit Card'),
(2, 'PROCESSING', 1199.99, 3, 4, 'Standard', 'PayPal'),
(4, 'SHIPPED', 259.98, 5, 5, 'Standard', 'Credit Card');

-- Insert Order Items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 999.99, 999.99),
(1, 3, 1, 1799.99, 1799.99),
(2, 2, 1, 1199.99, 1199.99),
(3, 4, 2, 129.99, 259.98);

-- Insert Order Tracking
INSERT INTO order_tracking (order_id, status, location, carrier, tracking_number) VALUES
(1, 'DELIVERED', 'New York, NY', 'FedEx', 'FDX123456789'),
(2, 'IN_TRANSIT', 'Los Angeles, CA', 'UPS', 'UPS987654321'),
(3, 'SHIPPED', 'Chicago, IL', 'USPS', 'USPS456789123');

-- Insert Product Reviews
INSERT INTO product_reviews (product_id, user_id, rating, title, review_text, is_verified_purchase) VALUES
(1, 2, 5, 'Best iPhone Ever!', 'Amazing camera and battery life', TRUE),
(2, 1, 4, 'Great Android Phone', 'Excellent performance but a bit pricey', TRUE),
(3, 4, 5, 'Perfect Laptop', 'Perfect for both work and gaming', TRUE),
(4, 5, 4, 'Comfortable Shoes', 'Very comfortable for running', TRUE);

-- Insert Review Images
INSERT INTO review_images (review_id, image_url) VALUES
(1, 'review1_photo1.jpg'),
(1, 'review1_photo2.jpg'),
(2, 'review2_photo1.jpg');

-- Insert Promotions
INSERT INTO promotions (name, description, discount_type, discount_value, start_date, end_date, minimum_purchase) VALUES
('Summer Sale', 'Summer clearance sale', 'PERCENTAGE', 20.00, '2024-06-01', '2024-06-30', 50.00),
('Holiday Special', 'Holiday season deals', 'FIXED_AMOUNT', 50.00, '2024-12-01', '2024-12-31', 200.00);

-- Insert Promotion Products
INSERT INTO promotion_products (promotion_id, product_id) VALUES
(1, 4),
(1, 5),
(2, 1),
(2, 2),
(2, 3);

-- Insert Coupons
INSERT INTO coupons (code, description, discount_type, discount_value, minimum_purchase, start_date, end_date, usage_limit) VALUES
('WELCOME10', 'New customer discount', 'PERCENTAGE', 10.00, 50.00, '2024-01-01', '2024-12-31', 1000),
('SUMMER2024', 'Summer season discount', 'FIXED_AMOUNT', 25.00, 100.00, '2024-06-01', '2024-08-31', 500);

-- Insert Wishlists
INSERT INTO wishlists (user_id, name, is_public) VALUES
(1, 'My Tech Wishlist', TRUE),
(2, 'Gift Ideas', FALSE),
(4, 'Birthday Wishlist', TRUE);

-- Insert Wishlist Items
INSERT INTO wishlist_items (wishlist_id, product_id) VALUES
(1, 2),
(1, 3),
(2, 1),
(3, 4);

-- Insert Support Tickets
INSERT INTO support_tickets (user_id, order_id, subject, description, status, priority) VALUES
(1, 1, 'Order Delivery Question', 'When will my order arrive?', 'RESOLVED', 'MEDIUM'),
(2, 2, 'Wrong Item Received', 'I received a different model', 'IN_PROGRESS', 'HIGH'),
(4, 3, 'Return Request', 'How do I return this item?', 'OPEN', 'MEDIUM');

-- Insert Ticket Messages
INSERT INTO ticket_messages (ticket_id, user_id, message, is_staff_reply) VALUES
(1, 1, 'Can you provide an estimated delivery date?', FALSE),
(1, 3, 'Your order will be delivered tomorrow by 5 PM.', TRUE),
(2, 2, 'I ordered the black model but received silver.', FALSE),
(3, 4, 'I want to return the item due to size issues.', FALSE); 