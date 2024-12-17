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
