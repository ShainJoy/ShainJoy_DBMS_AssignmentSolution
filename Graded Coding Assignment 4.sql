CREATE DATABASE TravelOnTheGo;

USE TravelOnTheGo;

/*
  To achieve the Normal Form standards, the data has split into 7 tables.
*/

CREATE TABLE Bus_Type (
			id INT PRIMARY KEY,
            bus_type VARCHAR(20));
            
CREATE TABLE Bus_Category (
			id INT PRIMARY KEY,
            category VARCHAR(20));
            
CREATE TABLE passenger (
			id INT PRIMARY KEY,
            passenger_name VARCHAR(50),
            gender CHAR);

/*
  Since more than one person can travel from one place to another and to avoid 
  duplicacy boarding, destination & distance together made a table named 'route'.
*/

CREATE TABLE routes (
			id INT PRIMARY KEY,
            boarding VARCHAR(50),
            destination VARCHAR(50),
            distance INT);
            
CREATE TABLE price (
			id INT PRIMARY KEY,
            bus_type_id INT,
            distance INT,
            price DOUBLE,
            FOREIGN KEY (bus_type_id) REFERENCES Bus_Type (id));
            
/*
  'Trips' is table carries data of which bus type & catagory is used on a route
*/

CREATE TABLE trips (
			id INT PRIMARY KEY,
            route_id INT,
            bus_catogory_id INT,
            bus_type_id INT,
            FOREIGN KEY (route_id) REFERENCES routes (id),
            FOREIGN KEY (bus_catogory_id) REFERENCES Bus_Category (id),
            FOREIGN KEY (bus_type_id) REFERENCES Bus_Type (id));
            
/*
	'Travel' table contains data of passenger & their trips
*/

CREATE TABLE travel (
			id INT PRIMARY KEY,
            trip_id INT,
            passenger_id INT,
            FOREIGN KEY (trip_id) REFERENCES trips (id),
            FOREIGN KEY (passenger_id) REFERENCES passenger (id));
            
INSERT INTO Bus_Type VALUES (1,"Sleeper"),
							(2,"Sitting");
            
INSERT INTO Bus_Category VALUES (1,"AC"),
								(2,"Non-Ac");
                                
INSERT INTO passenger VALUES (1,"Sejal",'F'),
							(2,"Anmol",'M'),
							(3,"Pallavi",'F'),
							(4,"Khusboo",'F'),
							(5,"Udit",'M'),
							(6,"Ankur",'M'),
							(7,"Hemant",'M'),
							(8,"Manish",'M'),
							(9,"Piyush",'M');

INSERT INTO routes VALUES (1,"Bengaluru","Chennai",350),
							(2,"Mumbai","Hyderabad",700),
							(3,"Panaji","Bengaluru",600),
							(4,"Chennai","Mumbai",1500),
							(5,"Trivandrum","panaji",1000),
							(6,"Nagpur","Hyderabad",500),
							(7,"Panaji","Mumbai",700),
							(8,"Hyderabad","Bengaluru",500),
							(9,"Pune","Nagpur",700);

INSERT INTO price VALUES (1,1,350,770),
						(2,1,500,1100),
						(3,1,600,1320),
						(4,1,700,1540),
						(5,1,1000,2200),
						(6,1,1200,2640),
						(7,1,1500,2700),
						(8,2,500,620),
						(9,2,600,744),
						(10,2,700,868),
						(11,2,1000,1240),
						(12,2,1200,1488),
						(13,2,1500,1860);

INSERT INTO trips VALUES (1,1,1,1),
						(2,2,2,2),
						(3,3,1,1),
						(4,4,1,1),
						(5,5,2,1),
						(6,6,1,2),
						(7,7,2,1),
						(8,8,2,2),
						(9,9,1,2);

INSERT INTO travel VALUES (1,1,1),
						(2,2,2),
						(3,3,3),
						(4,4,4),
						(5,5,5),
						(6,6,6),
						(7,7,7),
						(8,8,8),
						(9,9,9);

/*
 3) How many females and how many male passengers travelled for a minimum distance of 
	600 KM s?
*/
SELECT iQry.gender AS Gender, COUNT(iQry.gender) AS No_Of_Passengers FROM routes AS rut
INNER JOIN
(SELECT pasn.passenger_name, pasn.gender, trp.route_id FROM trips AS trp
INNER JOIN
(SELECT pas.passenger_name, pas.gender, trv.trip_id FROM passenger AS pas
INNER JOIN travel AS trv
ON pas.id = trv.passenger_id) AS pasn
ON pasn.trip_id = trp.id) AS iQry
ON iQry.route_id = rut.id AND rut.distance >= 600
GROUP BY iQry.gender;

/*
	4) Find the minimum ticket price for Sleeper Bus. 
*/
SELECT bus.bus_type AS Bus_Type, MIN(prc.price) AS Minimum_Ticket_Price FROM price AS prc 
INNER JOIN
(SELECT bst.id, bst.bus_type FROM bus_type AS bst WHERE bst.bus_type = "Sleeper") AS bus
ON prc.bus_type_id = bus.id;

/*
	5) Select passenger names whose names start with character 'S' 
*/
SELECT passenger_name FROM passenger WHERE passenger_name LIKE "S%";

/*
	6) Calculate price charged for each passenger displaying Passenger name, Boarding City, 
		Destination City, Bus_Type, Price in the output
*/
SELECT iQry.passenger_name AS 'Passenger name', iQry.boarding AS 'Boarding City', 
iQry.destination AS 'Destination City', iQry.bus_type AS 'Bus_Type', prc.price AS Price FROM price AS prc
INNER JOIN
(SELECT qry.passenger_name, qry.boarding, qry.destination, qry.distance, qry.bus_type_id, bus.bus_type FROM bus_type AS bus
INNER JOIN
(SELECT trvl_dtls.passenger_name, rut.boarding, rut.destination, rut.distance, trvl_dtls.bus_type_id FROM routes AS rut
INNER JOIN
(SELECT pas_trv.passenger_name, trp.route_id, trp.bus_type_id FROM trips AS trp
INNER JOIN
(SELECT pas.passenger_name, trv.trip_id FROM passenger AS pas
INNER JOIN travel AS trv
ON pas.id = trv.passenger_id) AS pas_trv
ON pas_trv.trip_id = trp.id) AS trvl_dtls
ON trvl_dtls.route_id = rut.id) AS qry
ON qry.bus_type_id = bus.id) AS iQry
ON iQry.bus_type_id = prc.bus_type_id AND iQry.distance = prc.distance;

/*
	7) What are the passenger name/s and his/her ticket price who travelled in the Sitting bus 
		for a distance of 1000 KM s
        (In fact there are NO records meeting this condition)
*/
SELECT iQry.passenger_name AS 'Passenger name', iQry.bus_type AS 'Bus Type', 
prc.price AS 'Ticket Price' FROM price AS prc
INNER JOIN
(SELECT qry.passenger_name, qry.boarding, qry.destination, qry.distance, qry.bus_type_id, bus.bus_type FROM bus_type AS bus
INNER JOIN
(SELECT trvl_dtls.passenger_name, rut.boarding, rut.destination, rut.distance, trvl_dtls.bus_type_id FROM routes AS rut
INNER JOIN
(SELECT pas_trv.passenger_name, trp.route_id, trp.bus_type_id FROM trips AS trp
INNER JOIN
(SELECT pas.passenger_name, trv.trip_id FROM passenger AS pas
INNER JOIN travel AS trv
ON pas.id = trv.passenger_id) AS pas_trv
ON pas_trv.trip_id = trp.id) AS trvl_dtls
ON trvl_dtls.route_id = rut.id) AS qry
ON qry.bus_type_id = bus.id AND bus.bus_type = "Sitting") AS iQry
ON iQry.bus_type_id = prc.bus_type_id AND iQry.distance = prc.distance
WHERE iQry.distance > 1000;

/*
	8) What will be the Sitting and Sleeper bus charge for Pallavi to travel from Bangalore to 
		Panaji?
*/
SELECT iQry.city2  AS 'City 1', iQry.city1 AS 'City 2', iQry.distance AS 'Distance in Kms', 
bus.bus_type AS 'Bus Type', iQry.price AS Price FROM bus_type AS bus
INNER JOIN
(SELECT trp.city1, trp.city2, trp.distance, prc.bus_type_id, prc.price  FROM price AS prc 
INNER JOIN
(SELECT rut.boarding AS city1, rut.destination AS city2, rut.distance FROM routes AS rut WHERE id = 3) AS trp
ON trp.distance = prc.distance) AS iQry
ON iQry.bus_type_id = bus.id;

/*
	9) List the distances from the "Passenger" table which are unique (non-repeated 
		distances) in descending order.
*/
SELECT distance FROM routes GROUP BY distance ORDER BY distance DESC;

/*
	10) Display the passenger name and percentage of distance travelled by that passenger 
		from the total distance travelled by all passengers without using user variables
*/
SELECT pass.passenger_name AS 'Passenger name', iQry.distance AS 'Distance Travelled',
 ROUND(iQry.percentage,2) AS 'Percentage of travel' FROM passenger AS pass
INNER JOIN
(SELECT trvl.passenger_id, trp_qry.boarding, trp_qry.destination, trp_qry.distance, 
trp_qry.percentage FROM travel as trvl
INNER JOIN
(SELECT trp.id, rut_sum.boarding, rut_sum.destination, rut_sum.distance, rut_sum.percentage FROM trips AS trp
INNER JOIN
(SELECT rut.id, rut.boarding, rut.destination, rut.distance, 
(distance/get_ttl.ttl*100) AS percentage FROM routes AS rut
CROSS JOIN
(SELECT SUM(distance) AS ttl FROM routes) AS get_ttl) AS rut_sum
ON rut_sum.id = trp.id) AS trp_qry
ON trp_qry.id = trvl.trip_id) AS iQry
ON iQry.passenger_id = pass.id;

/*
	11) Display the distance, price in three categories in table Price
		a) Expensive if the cost is more than 1000
		b) Average Cost if the cost is less than 1000 and greater than 500
		c) Cheap otherwise
*/
SELECT distance AS Distance, price AS Price,
	CASE 
		WHEN price > 1000 THEN "Expensive"
        WHEN price > 500 THEN "Average Cost"
        ELSE "Cheap"
    END AS Price_Category
 FROM price;
