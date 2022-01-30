DROP TABLE IF EXISTS plant_types;
DROP TABLE IF EXISTS plants;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS process;
DROP TABLE IF EXISTS process_input;
DROP TABLE IF EXISTS process_output;

CREATE TABLE plant_types
(
    id   INT PRIMARY KEY,
    name VARCHAR(255) not null
);
CREATE UNIQUE INDEX plant_type_name ON plant_types (name);

CREATE TABLE plants
(
    id            INT PRIMARY KEY,
    name          VARCHAR(255) not null,
    base_speed    DOUBLE       not null,
    tier          INT          not null,
    plant_type_id INT          not null,
    FOREIGN KEY (plant_type_id) REFERENCES plant_types (id)
);
CREATE UNIQUE INDEX plants_name ON plants (name);

CREATE TABLE items
(
    id   INT PRIMARY KEY,
    name VARCHAR(255) not null
);
CREATE UNIQUE INDEX items_name ON plants (name);

CREATE TABLE process
(
    id           INT PRIMARY KEY,
    name         VARCHAR(255) not null,
    process_time DOUBLE       not null,
    plant_id     INT          not null,
    FOREIGN KEY (plant_id) REFERENCES plant_types (id)
);
CREATE UNIQUE INDEX process_name ON process (name);

CREATE TABLE process_input
(
    process_id INT NOT NULL,
    item_id    INT NOT NULL,
    amount     INT NOT NULL,
    FOREIGN KEY (process_id) REFERENCES process (id),
    FOREIGN KEY (item_id) REFERENCES items (id)
);
CREATE UNIQUE INDEX process_input_process_item_ids ON process_input (process_id, item_id);

CREATE TABLE process_output
(
    process_id INT NOT NULL,
    item_id    INT NOT NULL,
    amount     INT NOT NULL,
    FOREIGN KEY (process_id) REFERENCES process (id),
    FOREIGN KEY (item_id) REFERENCES items (id)
);
CREATE UNIQUE INDEX process_output_process_item_ids ON process_output (process_id, item_id);


INSERT INTO plant_types (id, name)
VALUES (1, 'Smelter'),
       (2, 'Assembler'),
       (3, 'Refinery'),
       (4, 'Chem Lab'),
       (5, 'Pump'),
       (6, 'Science Lab'),
       (7, 'Drill'),
       (8, 'Pumpjack'),
       (9, 'Rocket Silo');


INSERT INTO plants (id, name, base_speed, tier, plant_type_id)
VALUES (1, 'Stone Furnace', 0.5, 1, 1),
       (2, 'Steel Furnace', 1, 2, 1),

       (3, 'Assembling Machine 1', 0.5, 2, 2),
       (4, 'Assembling Machine 2', 0.75, 2, 2),
       (5, 'Assembling Machine 3', 1.25, 2, 2);



INSERT INTO items (id, name)
VALUES (1, 'Iron ore'),
       (2, 'Coal'),
       (3, 'Copper'),
       (4, 'Crude Oil'),
       (5, 'Iron Plate'),
       (6, 'Copper Plate'),
       (7, 'Steel Plate'),
       (8, 'Electronic Circuit'),
       (9, 'Advanced Circuit'),
       (10, 'Automation Science Pack'),
       (11, 'Logistic Science Pack'),
       (12, 'Petroleum Gas'),
       (13, 'Copper Cable'),
       (14, 'Iron Gear Wheel'),
       (15, 'Plastic Bar'),
       (16, 'Sulfuric Acid'),

       (17, 'Transport Belt'),
       (18, 'Fast Transport Belt'),
       (19, 'Express Transport Belt'),
       (20, 'Inserter'),
       (21, 'Long Handed Inserter'),
       (22, 'Stone Furnace'),
       (23, 'Steel Furnace'),
       (24, 'Electric Furnace'),
       (25, 'Assembling Machine 1'),
       (26, 'Assembling Machine 2'),
       (27, 'Electric Engine Unit'),
       (28, 'Engine Unit'),
       (29, 'Lubricant'),
       (30, 'Concrete'),
       (31, 'Stone Brick'),
       (32, 'Stone'),
       (33, 'Pipe'),
       (34, 'Accumulator'),
       (35, 'Battery'),
       (36, 'Low Density Structure'),
       (37, 'Radar'),
       (38, 'Rocket Fuel'),
       (39, 'Light Oil'),
       (40, 'Solid Fuel'),
       (41, 'Solar Panel'),
       (42, 'Speed Module'),
       (43, 'Military Science Pack'),
       (44, 'Chemical Science Pack'),
       (45, 'Sulfur'),
       (46, 'Water'),
       (47, 'Production Science Pack'),
       (48, 'Productivity Module'),
       (49, 'Rail'),
       (50, 'Iron Stick'),
       (51, 'Utility Science Pack'),
       (52, 'Flying Robot Frame'),
       (53, 'Space Science Pack'),
       (54, 'Heavy Oil'),
       (55, 'Grenade'),
       (56, 'Piercing Round Magazine'),
       (57, 'Firearm Magazine'),
       (58, 'Wall'),
       (59, 'Processing Unit'),
       (60, 'Rocket Control Unit'),
       (61, 'Rocket Part'),
       (62, 'Satellite');


------------------------ Iron Ore ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (1, 'Drill Iron', 2, 7);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (1, 1, 1);

------------------------ Coal -------------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (2, 'Drill Coal', 2, 7);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (2, 2, 1);


------------------------ Copper Ore ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (3, 'Drill Copper', 2, 7);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (3, 3, 1);


------------------------ Crude Ore ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (4, 'Extract Oil', 1, 8);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (4, 4, 2);


------------------------ Iron Plate ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (5, 'Smelt Iron', 3.2, 1);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (5, 1, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (5, 5, 1);

------------------------ Copper Plate ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (6, 'Smelt Copper', 3.2, 1);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (6, 3, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (6, 6, 1);

------------------------ Steel Plate ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (7, 'Smelt Steel', 16, 1);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (7, 5, 5);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (7, 7, 1);

------------------------ Electronic Circuit ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (8, 'Assemble Electronic Circuit', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (8, 13, 3),
       (8, 5, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (8, 8, 1);

------------------------ Advanced Circuit ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (9, 'Assemble Advanced Circuit', 6, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (9, 13, 4),
       (9, 8, 2),
       (9, 15, 2);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (9, 9, 1);

------------------------ Automation Science Pack ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (10, 'Assemble Automation Science Pack', 5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (10, 6, 1),
       (10, 14, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (10, 10, 1);

------------------------ Logistic Science Pack ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (11, 'Assemble Logistic Science Pack', 6, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (11, 20, 1),
       (11, 17, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (11, 11, 1);

------------------------ Petroleum Gas ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (12, 'Advanced Oil Processing', 5, 3);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (12, 4, 100),
       (12, 46, 50);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (12, 54, 25),
       (12, 39, 45),
       (12, 12, 55);


INSERT INTO process (id, name, process_time, plant_id)
VALUES (13, 'Light Oil Cracking', 2, 4);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (13, 39, 30),
       (13, 46, 30);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (13, 12, 20);

------------------------ Copper Cable ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (14, 'Assemble Copper Cable', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (14, 6, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (14, 13, 2);

------------------------ Iron Gear Wheel ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (15, 'Assemble Iron Gear Wheel', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (15, 5, 2);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (15, 14, 1);

------------------------ Plastic Bar ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (16, 'Synthesize Plastic Bar', 1, 4);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (16, 2, 1),
       (16, 12, 20);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (16, 15, 2);

------------------------ Sulfuric Acid ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (17, 'Synthesize Sulfuric Acid', 1, 4);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (17, 5, 1),
       (17, 45, 5),
       (17, 46, 100);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (17, 16, 50);

------------------------ Transport Belt ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (18, 'Assemble Transport Belt', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (18, 14, 1),
       (18, 5, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (18, 17, 2);

------------------------ Fast Transport Belt ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (19, 'Assemble Fast Transport Belt', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (19, 14, 5),
       (19, 17, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (19, 18, 1);

------------------------ Express Transport Belt ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (20, 'Assemble Express Transport Belt', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (20, 18, 1),
       (20, 14, 10),
       (20, 29, 20);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (20, 19, 1);

------------------------ Inserter ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (21, 'Assemble Inserter', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (21, 8, 1),
       (21, 14, 1),
       (21, 5, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (21, 20, 1);

------------------------ Long Handed Inserter ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (22, 'Assemble Long Handed Inserter', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (22, 20, 1),
       (22, 14, 1),
       (22, 5, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (22, 21, 1);

------------------------ Stone Furnace ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (23, 'Assemble Stone Furnace', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (23, 32, 5);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (23, 22, 1);

------------------------ Steel Furnace ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (24, 'Assemble Steel Furnace', 3, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (24, 7, 6),
       (24, 31, 10);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (24, 23, 1);

------------------------ Electric Furnace ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (25, 'Assemble Electric Furnace', 5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (25, 9, 5),
       (25, 7, 10),
       (25, 31, 10);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (25, 24, 1);

------------------------ Assembling Machine 1 ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (26, 'Assemble Assembling Machine 1', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (26, 8, 3),
       (26, 14, 5),
       (26, 5, 9);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (26, 25, 1);

------------------------ Assembling Machine 2 ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (27, 'Assemble Assembling Machine 2', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (27, 25, 1),
       (27, 8, 3),
       (27, 14, 5),
       (27, 7, 2);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (27, 26, 1);

------------------------ Electric Engine Unit ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (28, 'Assemble Electric Engine Unit', 10, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (28, 8, 2),
       (28, 28, 1),
       (28, 29, 15);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (28, 27, 1);

------------------------ Engine unit ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (29, 'Assemble Engine unit', 10, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (29, 14, 1),
       (29, 33, 2),
       (29, 7, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (29, 28, 1);

------------------------ Lubricant ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (30, 'Synthesize Lubricant', 1, 4);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (30, 54, 10);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (30, 29, 10);

------------------------ Concrete ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (31, 'Assemble Concrete', 10, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (31, 1, 1),
       (31, 31, 5),
       (31, 46, 100);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (31, 30, 10);

------------------------ Stone Brick ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (32, 'Smelt Stone', 3.2, 1);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (32, 32, 2);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (32, 31, 1);

------------------------ Stone ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (33, 'Drill Stone', 2, 7);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (33, 32, 1);

------------------------ Pipe ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (34, 'Assemble Pipe', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (34, 5, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (34, 33, 1);

------------------------ Accumulator ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (35, 'Assemble Accumulator', 10, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (35, 35, 5),
       (35, 5, 2);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (35, 34, 1);

------------------------ Battery ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (36, 'Synthesize Battery', 4, 4);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (36, 6, 1),
       (36, 5, 1),
       (36, 16, 20);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (36, 35, 1);

------------------------ Low Density Structure ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (37, 'Assemble Low Density Structure', 20, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (37, 6, 20),
       (37, 15, 5),
       (37, 7, 2);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (37, 36, 1);

------------------------ Radar ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (38, 'Assemble Radar', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (38, 8, 5),
       (38, 14, 5),
       (38, 5, 10);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (38, 37, 1);

------------------------ Rocket Fuel ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (39, 'Assemble Rocket Fuel', 30, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (39, 39, 10),
       (39, 40, 10);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (39, 38, 1);

------------------------ Light Oil ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (40, 'Heavy Oil Cracking', 2, 4);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (40, 54, 40),
       (40, 46, 30);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (40, 39, 30);

------------------------ Solid Fuel ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (41, 'Synthesize Solid Fuel', 2, 4);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (41, 39, 10);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (41, 40, 1);

------------------------ Solar Panel ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (42, 'Assemble Solar Panel', 10, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (42, 6, 5),
       (42, 8, 15),
       (42, 7, 5);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (42, 41, 1);

------------------------ Speed Module ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (43, 'Assemble Speed Module', 15, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (43, 9, 5),
       (43, 8, 5);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (43, 42, 1);

------------------------ Military Science Pack ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (44, 'Assemble Military Science Pack', 10, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (44, 55, 1),
       (44, 56, 1),
       (44, 58, 2);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (44, 43, 2);

------------------------ Chemical Science Pack ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (45, 'Assemble Chemical Science Pack', 24, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (45, 9, 3),
       (45, 28, 2),
       (45, 45, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (45, 44, 2);

------------------------ Sulfur ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (46, 'Synthesize Sulfur', 1, 4);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (46, 12, 30),
       (46, 46, 30);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (46, 45, 2);

------------------------ Water ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (47, 'Pump Water', 1, 5);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (47, 46, 1200);

------------------------ Production Science Pack ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (48, 'Assemble Production Science Pack', 21, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (48, 24, 1),
       (48, 48, 1),
       (48, 49, 30);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (48, 47, 3);

------------------------ Productivity Module ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (49, 'Assemble Productivity Module', 15, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (49, 9, 5),
       (49, 8, 5);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (49, 48, 1);

------------------------ Rail ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (50, 'Assemble Rail', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (50, 50, 1),
       (50, 7, 1),
       (50, 32, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (50, 49, 2);

------------------------ Iron Stick ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (51, 'Assemble Iron Stick', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (51, 5, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (51, 50, 2);

------------------------ Utility Science Pack ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (52, 'Assemble Utility Science Pack', 21, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (52, 52, 1),
       (52, 36, 3),
       (52, 59, 2);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (52, 51, 3);

------------------------ Flying Robot Frame ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (53, 'Assemble Flying Robot Frame', 20, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (53, 35, 2),
       (53, 27, 1),
       (53, 8, 3),
       (53, 7, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (53, 52, 1);

------------------------ Space Science Pack ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (54, 'Launch Satellite for Space Science Pack', 40.33, 9);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (54, 61, 100),
       (54, 62, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (54, 53, 1000);

------------------------ Grenade ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (55, 'Assemble Grenade', 8, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (55, 2, 10),
       (55, 5, 5);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (55, 55, 1);

------------------------ Piercing Round Magazine ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (56, 'Assemble Piercing Round Magazine', 3, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (56, 6, 5),
       (56, 57, 1),
       (56, 7, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (56, 56, 1);

------------------------ Firearm Magazine ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (57, 'Assemble Firearm Magazine', 1, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (57, 5, 4);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (57, 57, 1);

------------------------ Wall ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (58, 'Assemble Wall', 0.5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (58, 31, 5);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (58, 58, 1);

------------------------ Processing Unit ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (59, 'Assemble Processing Unit', 10, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (59, 9, 2),
       (59, 8, 20),
       (59, 16, 5);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (59, 59, 1);

------------------------ Rocket Control Unit ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (60, 'Assemble Rocket Control Unit', 30, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (60, 59, 1),
       (60, 42, 1);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (60, 60, 1);

------------------------ Rocket Part ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (61, 'Space Assemble Rocket Part', 3, 9);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (61, 36, 10),
       (61, 60, 10),
       (61, 38, 10);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (61, 61, 1);

------------------------ Satellite ------------------------
INSERT INTO process (id, name, process_time, plant_id)
VALUES (62, 'Assemble Satellite', 5, 2);

INSERT INTO process_input (process_id, item_id, amount)
VALUES (62, 34, 100),
       (62, 36, 100),
       (62, 59, 100),
       (62, 37, 5),
       (62, 38, 50),
       (62, 41, 100);

INSERT INTO process_output (process_id, item_id, amount)
VALUES (62, 62, 1);