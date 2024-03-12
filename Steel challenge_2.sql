/*1.What are the names of the players whose salary is greater than 100,000?*/

select player_name, salary 
from players
where salary > 100000 ;

/*2. What is the team name of the player with player_id = 3?*/

SELECT teams.team_name
FROM teams
JOIN players ON players.team_id = teams.team_id
WHERE players.player_id = 3;


/*3.What is the total number of players in each team?*/

select teams.team_name , count(players.team_id) as Totalplayers
from teams
left join players on teams.team_id = players.team_id 
group by teams.team_name ;


/*4.What is the team name and captain name of the team with team_id = 2?*/

SELECT teams.team_name, players.player_name AS captain_name
FROM teams
JOIN players ON teams.captain_id = players.player_id
WHERE teams.team_id = 2;

/*5. What are the player names and their roles in the team with team_id = 1?*/

SELECT player_name, role
FROM players
WHERE team_id = 1;

/*6. What are the team names and the number of matches they have won?*/

SELECT teams.team_name, COUNT(matches.match_id) AS matches_won
FROM teams
LEFT JOIN matches ON teams.team_id = matches.winner_id
GROUP BY teams.team_name;

/*7.What is the average salary of players in the teams with country 'USA'?*/

SELECT round(AVG(players.salary)) AS average_salary
FROM players
JOIN teams ON players.team_id = teams.team_id
WHERE teams.country = 'USA';

/*8. Which team won the most matches?*/

SELECT teams.team_name, COUNT(matches.match_id) AS matches_won
FROM teams
JOIN matches ON teams.team_id = matches.winner_id
GROUP BY teams.team_name
ORDER BY matches_won DESC
LIMIT 1;


/*9. What are the team names and the number of players in each team whose salary is greater than 100,000?*/

SELECT teams.team_name, COUNT(players.player_id) AS num_players
FROM teams
JOIN players ON teams.team_id = players.team_id
WHERE players.salary > 100000
GROUP BY teams.team_name;


/*10.What is the date and the score of the match with match_id = 3?*/

SELECT match_date,score_team1,score_team2
FROM matches
WHERE match_id = 3 ;