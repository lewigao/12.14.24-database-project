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