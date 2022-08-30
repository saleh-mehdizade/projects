CREATE DATABASE customer_activity;


CREATE TABLE country(
id INT PRIMARY KEY AUTO_INCREMENT,
country_name VARCHAR(50) NOT NULL
);

CREATE TABLE product(
id INT PRIMARY KEY AUTO_INCREMENT,
product_name VARCHAR(50) NOT NULL,
FOREIGN KEY(country_id) REFERENCES country(id)
);

CREATE TABLE report_date(
id INT PRIMARY KEY AUTO_INCREMENT,
date DATETIME
);

CREATE TABLE turnover(
FOREIGN KEY(country_id) REFERENCES country(id),
FOREIGN KEY(product_id) REFERENCES product(id),
FOREIGN KEY(report_date_id) REFERENCES report_date(id),
value FLOAT
);
CREATE TABLE wins(
FOREIGN KEY(country_id) REFERENCES country(id),
FOREIGN KEY(product_id) REFERENCES product(id),
FOREIGN KEY(report_date_id) REFERENCES report_date(id),
value FLOAT
);
CREATE TABLE pending_bets(
FOREIGN KEY(country_id) REFERENCES country(id),
FOREIGN KEY(product_id) REFERENCES product(id),
FOREIGN KEY(report_date_id) REFERENCES report_date(id),
value FLOAT
);
CREATE TABLE gross_gaming_revenue(
FOREIGN KEY(country_id) REFERENCES country(id),
FOREIGN KEY(product_id) REFERENCES product(id),
FOREIGN KEY(report_date_id) REFERENCES report_date(id),
value FLOAT
);
CREATE TABLE jackpot_contribution(
FOREIGN KEY(country_id) REFERENCES country(id),
FOREIGN KEY(product_id) REFERENCES product(id),
FOREIGN KEY(report_date_id) REFERENCES report_date(id),
value FLOAT
);
CREATE TABLE bonuses(
FOREIGN KEY(country_id) REFERENCES country(id),
FOREIGN KEY(product_id) REFERENCES product(id),
FOREIGN KEY(report_date_id) REFERENCES report_date(id),
value FLOAT
);
CREATE TABLE net_gaming_revenue(
FOREIGN KEY(country_id) REFERENCES country(id),
FOREIGN KEY(product_id) REFERENCES product(id),
FOREIGN KEY(report_date_id) REFERENCES report_date(id),
value FLOAT
);