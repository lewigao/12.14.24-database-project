-- DATABASE CREATION

DROP DATABASE IF EXISTS GameDataBase;
CREATE DATABASE IF NOT EXISTS GameDatabase;

USE GameDatabase;

DROP TABLE IF EXISTS PlayerInventory;
DROP TABLE IF EXISTS NPCInventory;
DROP TABLE IF EXISTS Card;
DROP TABLE IF EXISTS Effect;
DROP TABLE IF EXISTS NPC;
DROP TABLE IF EXISTS Player;

-- Table: Player
CREATE TABLE Player (
    playerID 			VARCHAR(8) 		PRIMARY KEY,	-- Primary key (inherently NOT NULL)
    playerName 			VARCHAR(32) 	NOT NULL,   	-- A player must have a name
    HP 					INT 			NOT NULL,   	-- Players must have an HP value
    playerLevel 		INT 			NOT NULL    	-- Players must have a level
);

-- Table: NPC
CREATE TABLE NPC (
    npcID 				VARCHAR(8) 		PRIMARY KEY,   	-- Primary key (inherently NOT NULL)
    npcName 			VARCHAR(32) 	NOT NULL		UNIQUE,      	-- NPC must have a name
    HP 					INT 			NOT NULL,      	-- NPC must have an HP value
    npcLevel 			INT 			NOT NULL,      	-- NPC must have a level
    aggressive 			BOOLEAN 		NOT NULL       	-- Aggressive state must be defined TRUE/FALSE
);

-- Table: Effect
CREATE TABLE Effect (
    effectID 			VARCHAR(8) 		PRIMARY KEY,   	-- Primary key (inherently NOT NULL)
    effectName 			VARCHAR(32) 	NOT NULL		UNIQUE,  		-- Effect must have a name
    effectDescription 	VARCHAR(1028)  	NOT NULL		-- Description is optional
);

-- Table: Card
CREATE TABLE Card (
    cardID 				VARCHAR(8) 		PRIMARY KEY,   	-- Primary key (inherently NOT NULL)
    effectID 			VARCHAR(8)		NOT NULL, 		-- Foreign key to Effect
    cardName 			VARCHAR(32) 	NOT NULL		UNIQUE,      	-- A card must have a name
    element 			VARCHAR(32) 		NOT NULL,       -- A card must have an element
    cooldown 			INT 			NOT NULL,  		-- A card must have a cooldown
    durability 			INT 			NOT NULL,       -- A card must have a durability value
    cardDescription 	VARCHAR(2056)	NOT NULL,		-- Description is optional
    maxStackable 		INT 			NOT NULL 		DEFAULT 10, 	-- Default ensures at least 1 stack
    damage 				INT 			NOT NULL,		-- Damage value must be defined
    
    CONSTRAINT card_pk_effect FOREIGN KEY (effectID) REFERENCES Effect(effectID)
);

-- Table: NPCInventory
CREATE TABLE NPCInventory (
    npcInvID 			VARCHAR(8)	 	PRIMARY KEY,  	-- Primary key (inherently NOT NULL)
    npcID 				VARCHAR(8) 		NOT NULL,       -- Foreign key to NPC
    cardID 				VARCHAR(8)		NOT NULL,		-- Foreign key to Card
    cardCount 			INT				DEFAULT 0,		-- Count of cards in the inventory
    dropRarity			VARCHAR(32)		NOT NULL, 		-- Rarity must be specified
    canDrop				BOOLEAN 		NOT NULL		DEFAULT FALSE, -- Specifies whether a card can be dropped on NPC death
    
    CONSTRAINT NPCInventory_fk_card FOREIGN KEY (cardID) REFERENCES Card(cardID) ON DELETE CASCADE,
    CONSTRAINT NPCInventory_fk_npc FOREIGN KEY (npcID) REFERENCES NPC(npcID) ON DELETE CASCADE
);

-- Table: PlayerInventory
CREATE TABLE PlayerInventory (
    playerInvID 		VARCHAR(8) 		PRIMARY KEY,   	-- Primary key (inherently NOT NULL)
    playerID 			VARCHAR(8)		NOT NULL,		-- Nullable: Inventory can exist without a player
    cardID 				VARCHAR(8)		NOT NULL, 		-- Nullable: Inventory may not always contain a card
    cardCount 			INT 			NOT NULL		 DEFAULT 0,  -- Default ensures no nulls for item count
    
    CONSTRAINT playerInventory_fk_player FOREIGN KEY (playerID) REFERENCES Player(playerID) ON DELETE CASCADE,
    CONSTRAINT playerInventory_fk_card FOREIGN KEY (cardID) REFERENCES Card(cardID) ON DELETE CASCADE
);

-- _______________________________________________________________________________________________________________________________

-- DATA INSERTION

USE GameDataBase;

INSERT INTO Player (playerID, playerName, playerLevel, HP)
VALUES 
('A001', 'Alexander', 10, 47),
('A002', 'Emma', 20, 23),
('A003', 'Daniel', 15, 38),
('A004', 'Chloe', 25, 44),
('A005', 'Samuel', 30, 62),
('A006', 'Lucas', 32, 56),
('A007', 'Mason', 12, 29),
('A008', 'Amelia', 40, 75),
('A009', 'Harper', 41, 79),
('A010', 'Benjamin', 46, 50),
('A011', 'Christopher', 50, 86),
('A012', 'Andrew', 55, 67),
('A013', 'Michael', 56, 74),
('A014', 'Matthew', 60, 83),
('A015', 'Alexander', 65, 99),
('A016', 'William', 64, 91),
('A017', 'Futureplayer1', 0, 0), -- Default values for future players
('A018', 'Futureplayer2', 0, 0), -- Default values for future players
('A019', 'Futureplayer3', 0, 0), -- Default values for future players
('A020', 'Futureplayer4', 0, 0); -- Default values for future players


INSERT INTO Effect (effectID, effectName, effectDescription)
VALUES ('E001', 'Heal', 'Adds point to Health'),
	('E002', 'Healing Reduction', 'Adds points to Health'),
	('E003', 'Healing Over Time', 'Adds points slowly to Health'),
	('E004', 'Shield', 'Blocks Incoming Damage'),
	('E005', 'Buff', 'Enhances Player Damage'),
	('E006', 'True Shield', 'Blocks All Incoming Damage'),
	('E007', 'Stun', 'Freezes Enemy Abilities'),
	('E008', 'Slow', 'Lengthens Enemy Cooldown'),
	('E009', 'Detonate', 'Applies immediate damage of burn on enemy'),
	('E010', 'Extra Turn', 'Adds Stack of Durability For Player'),
	('E011', 'Sacrifice', 'Removes Player Turn but Buffs Next Turn'),
	('E012', 'Steal', 'Switches Player\'s Worst Card With Enemy\'s Best'),
	('E013', 'Cooldown Reduction', 'Makes Player\'s Abilities Faster'),
	('E014', 'Vampire', 'Takes Enemy Health for Self'),
	('E015', 'Burn', 'Remove Enemy Health Slowly'),
	('E016', 'Poison', 'Remove Enemy Health Based on Their Damage'),
	('E017', 'FutureEffect1', 'add here'),
	('E018', 'FutureEffect2', 'add here'),
	('E019', 'FutureEffect3', 'add here'),
	('E020', 'FutureEffect4', 'add here');

INSERT INTO Card (cardID, effectID, cardName, element, cooldown, durability, cardDescription, maxStackable, damage) 
VALUES 
    ('C0001', 'E005', 'Sky Portal', 'Air', 10, 1, 'Portal opens', 10, 25),
    ('C0002', 'E008', 'Bug Wings', 'Air', 20, 1, 'Dragonfly zaps around', 10, 50),
    ('C0003', 'E001', 'Cloud Burst', 'Air', 30, 1, 'Dark sky forms', 10, 75),
    ('C0004', 'E005', 'Vortex', 'Air', 40, 1, 'Airplane swoosh', 10, 100),
    ('C0005', 'E010', 'Robin', 'Air', 50, 1, 'Bird eats card', 10, 125),

    ('C0006', 'E006', 'Splasher', 'Water', 10, 1, 'Water hits other card', 10, 25),
    ('C0007', 'E007', 'Bubble Wand', 'Water', 20, 1, 'Bubble swallows card', 10, 50),
    ('C0008', 'E013', 'Flowing Staff', 'Water', 30, 1, 'Sparkle stream of water', 10, 75),
    ('C0009', 'E004', 'Mermaid Tear', 'Water', 40, 1, 'Purple Tear Drop', 10, 100),
    ('C0010', 'E006', 'Coral', 'Water', 50, 1, 'Coral thrown', 10, 100),
    
    ('C0011', 'E003', 'Cinnabar', 'Earth', 10, 1, 'Rocks fall down', 10, 25),
    ('C0012', 'E010', 'Rooted', 'Earth', 20, 1, 'Tree roots break from ground', 10, 50),
    ('C0013', 'E005', 'Tomb Secret', 'Earth', 30, 1, 'Big tomb guy appears', 10, 75),
    ('C0014', 'E004', 'Sapling Friend', 'Earth', 40, 1, 'Happy leaf guy', 10, 100),
    ('C0015', 'E011', 'Grape Vine', 'Earth', 50, 1, 'Vine splash', 10, 125),

    ('C0016', 'E002', 'Candle Melt', 'Fire', 10, 1, 'Candle burns card', 10, 25),
    ('C0017', 'E012', 'Baby Dragon', 'Fire', 20, 1, 'Baby dragon fire breath', 10, 50),
    ('C0018', 'E003', 'Phoenix', 'Fire', 30, 1, 'Bird swoops down and sets fire', 10, 75),
    ('C0019', 'E003', 'Agni', 'Fire', 40, 1, 'Fire summons', 10, 100),
    ('C0020', 'E002', 'Ember', 'Fire', 50, 1, 'Ground burns', 10, 125);
    
INSERT INTO NPC(npcID, npcName, HP, npcLevel, aggressive)
VALUES
('N0000000', 'Desert Walker', 5, 2, true),
('N0000001', 'Scorpion', 3, 1, true),
('N0000002', 'Vulture', 4, 2, false),
('N0000003', 'SandBug', 1, 1, false),
('N0000004', 'Cacti', 2, 1, false),
('N0000005', 'False Cacti', 4, 2, true),
('N0000006', 'Crystal Cacti', 5, 1, false),
('N0000007', 'False Crystal Cacti', 7, 2, true),
('N0000008', 'Breakable Wall', 3, 1, false),
('N0000009', 'Dune Gliders', 2, 2, true),
('N0000010', 'Dessert Scorpion Boss', 20, 5, true),
('N0000011', 'Mirror Beetle', 5, 1, false),
('N0000012', 'Cave Bats', 2, 1, true),
('N0000013', 'Crystal Breakers', 5, 2, true),
('N0000014', 'Mirror Walker', 6, 3, true),
('N0000015', 'Breakable CaveWall', 5, 1, false),
('N0000016', 'Mirror Shadow', 4, 2, true),
('N0000017', 'Reflective Bane', 7, 4, true),
('N0000018', 'Snake Shard', 3, 2, true),
('N0000019', 'Snake Reflection', 5, 3, true),
('N0000020', '???', 35, 8, true);

ALTER TABLE NPCInventory
MODIFY dropRarity VARCHAR(32);

INSERT INTO NPCInventory(npcInvID, npcID, cardID, cardCount, dropRarity, canDrop)
VALUES
('NI000001', 'N0000000', 'C0001', 5, 'common', true),
('NI000002', 'N0000001', 'C0002', 3, 'uncommon', true),
('NI000003', 'N0000002', 'C0003', 5, 'common', false),
('NI000004', 'N0000003', 'C0019', 5, 'common', true),
('NI000005', 'N0000004', 'C0015', 7, 'rare', false),
('NI000006', 'N0000005', 'C0004', 2, 'common', false),
('NI000007', 'N0000006', 'C0005', 1, 'legendary', true),
('NI000008', 'N0000007', 'C0006', 7, 'common', false),
('NI000009', 'N0000008', 'C0007', 4, 'uncommon', true),
('NI000010', 'N0000009', 'C0008', 6, 'rare', true),
('NI000011', 'N0000010', 'C0009', 5, 'common', false),
('NI000012', 'N0000011', 'C0013', 2, 'rare', true),
('NI000013', 'N0000012', 'C0010', 4, 'uncommon', false),
('NI000014', 'N0000013', 'C0011', 1, 'legendary', true),
('NI000015', 'N0000014', 'C0012', 7, 'common', true),
('NI000016', 'N0000015', 'C0014', 3, 'uncommon', false),
('NI000017', 'N0000016', 'C0015', 6, 'rare', true),
('NI000018', 'N0000017', 'C0016', 1, 'common', true),
('NI000019', 'N0000018', 'C0017', 7, 'uncommon', false),
('NI000020', 'N0000019', 'C0018', 1, 'legendary', true);


INSERT INTO PlayerInventory(playerInvID, playerID, cardID, cardCount) 
VALUES
('PI000001', 'A001', 'C0001', 6),
('PI000002', 'A002', 'C0002', 5),
('PI000003', 'A003', 'C0003', 3),
('PI000004', 'A004', 'C0004', 7),
('PI000005', 'A005', 'C0005', 1),
('PI000006', 'A006', 'C0006', 2),
('PI000007', 'A007', 'C0007', 7),
('PI000008', 'A008', 'C0008', 3),
('PI000009', 'A009', 'C0009', 5),
('PI000010', 'A010', 'C0010', 6),
('PI000011', 'A011', 'C0011', 2),
('PI000012', 'A012', 'C0012', 3),
('PI000013', 'A013', 'C0013', 4),
('PI000014', 'A014', 'C0014', 6),
('PI000015', 'A015', 'C0015', 2),
('PI000016', 'A016', 'C0016', 3),
('PI000017', 'A017', 'C0017', 1),
('PI000018', 'A018', 'C0018', 6),
('PI000019', 'A019', 'C0019', 5),
('PI000020', 'A020', 'C0020', 3);

-- _______________________________________________________________________________________________________________________________

-- DATA RETRIEVAL

SELECT *
FROM NPC
WHERE aggressive = true;

SELECT AVG(playerLevel) AS 'Average Player Lvl', MIN(playerLevel) AS 'Lowest Player Level', MAX(playerLevel) AS 'Highest Player Lvl'
FROM Player;

SELECT c.cardName, e.effectName
FROM Card c, Effect e
WHERE c.effectID = e.effectID;

SELECT playerID, cardID
FROM PlayerInventory;

SELECT p.playerID, p.playerName, cardCount
FROM PlayerInventory pi, Player p
WHERE p.playerID = pi.playerID;

-- _______________________________________________________________________________________________________________________________

-- VIEW CREATION

USE GameDataBase;

DROP VIEW IF EXISTS PlayerCardIDs;
DROP VIEW IF EXISTS PlayerItems;
DROP VIEW IF EXISTS RarityList;
DROP VIEW IF EXISTS NPCLoot;

-- shows players their card ids
CREATE VIEW PlayerCardIDs AS
SELECT playerID, cardID
FROM PlayerInventory;

-- shows players their cards
CREATE VIEW PlayerItems AS
SELECT p.playerName, c.cardName
FROM Player p
JOIN PlayerInventory pi ON p.playerID = pi.playerID
JOIN Card c ON c.cardID = pi.cardID;

-- shows a rarity table for items
CREATE VIEW RarityList AS
SELECT n.npcName, ni.dropRarity, c.cardName
FROM NPC n
JOIN npcInventory ni ON n.npcID = ni.npcID
JOIN Card c ON ni.cardID = c.cardID
WHERE ni.canDrop = TRUE
ORDER BY n.npcName;

-- shows npc inventories
CREATE VIEW NPCLoot AS
SELECT n.npcName, c.cardName
FROM NPCInventory ni
JOIN NPC n ON n.npcID = ni.npcID
JOIN Card c on ni.cardID = c.cardID;
