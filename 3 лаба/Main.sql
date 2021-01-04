1. Написать представление, которое будет выводить список пользователей и 
их средний чек для выполненных заказов(login пользователя, средний чек)

CREATE VIEW myChecks AS
SELECT users.id, users.login,
	AVG(orders.price ::numeric::float8)
FROM users JOIN orders ON users.id=order.user_id AND orders.status=’F’
GROUP BY users.id;

2.Написать пользовательскую функцию, которая будет списывать сумму с вашего счета, 
если это возможно (входные параметры - login пользователя, сумма, возвращаемое значение - остаток на счете)

CREATE OR REPLACE FUNCTION pay(login varchar, value money) RETURNS money AS $$ DECLARE acc_val money;
BEGIN
SELECT accounts.value INTO acc_val
FROM users JOIN accounts ON accounts.user_id = users.id
	WHERE users.login = $1;
IF acc_val < $2
	THEN RAISE EXCEPTION ‘Error’;
ELSE 
UPDATE accounts
SET value = acc_val - $2
WHERE accounts.user_id = (SELECT users.id FROM users WHERE users.login = $1);
RETURN acc_val - $2;
END IF;
END;

$$ LANGUAGE plpgsql

3. Написать хранимую процедуру, которая будет рассчитывать сумму заказа пользователя и скидку на заказ, 
исходя из стоимости доставки (если таковая имеется) и стоимости товаров в корзине.

CREATE FUNCTION OR REPLACE FUNCTION orderINFO(order_id INT) RETURNS SETOF money AS $$
DECLARE orderPrice MONEY; deliveryPrice MONEY;
BEGIN
SELECT SUM(pr_basket.price) ), delivery_record.price INTO orderPrice,deliveryPrice
FROM orders
LEFT JOIN basket AS pr_basket ON pr_basket.order_id = orders.id
LEFT JOIN delivery_orders AS del_ord ON del_ord.order_id = orders.id
LEFT JOIN delivery AS del_record ON del_ord.delivery_id = del_record.id
WHERE order.id = $1
GROUP BY del_record.price;
UPDATE orders
SET price = orderPrice + deliveryPrice
WHERE orders.id = $1;
RETURN NEXT orderPrice;
RETURN NEXT deliveryPrice;
RETURN;
END;

$$ LANGUAGE plpgsql

4. Написать триггер, который будет пересчитывать сумму заказа пользователя и скидку на заказ,
 при изменении корзины товаров в заказе.

CREATE FUNCTION up_TRIGER() RETURNS trigger AS $$
BEGIN
	EXECUTE PROCEDURE order_info(NEW.id)
	RETURN NEW;
END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER tri_basket
AFTER INSERT OR UPDATE
	OF price ON orders FOR EACH row
EXECUTE PROCEDURE up_TRIGER();

5. Написать триггер, который будет устанавливать статус заказа "Оплачен", если заказ полностью оплачен, 
и списывать с остатков на складе то количество товара, 
которое было в заказе.

CREATE FUNCTION upd_ord() RETURNS trigger AS $$ DECLARE pay BOOLEAN;
BEGIN
SELECT (orders.price = SUM(payment_order.value)) INTO pay
FROM orders RIGHT JOIN payments_orders ON payments_order.order_id = orders.id
WHERE orders.id = NEW.id
GROUP BY orders.id;
IF pay THEN
UPDATE orders
SET status = 'P' WHERE orders.id = NEW.id;
UPDATE products
SET quantity = quantity - pay_basket.quantity
FROM
(SELECT product_basket.quantity, product_id
FROM baskets product_basket
WHERE product_basket.order_id = NEW.id
AND product_basket.product_id = products.id
) AS pay_basket
WHERE products.id=pay_basket.product_id;
END IF;
RETURN NEW;
END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER trig_ord_upd
AFTER ISERT OR UPDATE OF payments_orders ON orders
FOR EACH ROW EXECUTE PROCEDURE upd_ord()




6. Написать запрос, используя оконную функцию, который для заданного пользователя (login) 
будет выводить прогресс по сумме его выполненных заказов (каждая строка должна содержать 3 столбца: login пользователя, 
сумму заказа и сумму заказов начиная с первого до текущего (прогрессирующая сумма)).

SELECT users.login AS login, orders.price AS price,
SUM(order.price) OVER (
PARTITION BY users.login ORDER BY orders.create_at ASC) AS sums
FROM orders
LEFT JOIN users ON orders.user_id = users.id
ORDER BY users.login ASC;



