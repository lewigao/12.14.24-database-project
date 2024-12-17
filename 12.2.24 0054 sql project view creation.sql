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
