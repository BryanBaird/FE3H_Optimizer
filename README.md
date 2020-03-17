# FE3H_Optimizer
A silly side project to see how to best make Fire Emblem: Three Houses characters like each other faster.

## Objective
Given a large party of playable characters, and a limit on the number that can be brought along at any given time, can we pick the right subset of participants for each battle to reach the maximum potential of each character pairing in as few battles as possible? 

## Assumptions
1. "Support Levels" are a sequentially ranked grade of the strength of the relationship between any two characters. The levels go C - B - A - S. (There are sometimes "+" grades at the various levels for special circumstances, but those will be ignored and/or simplified as much as possible.) Each given pairing of characters has a maximum possible support level: some can reach level S with each other, while others will only ever rise to B, no matter what.
2. Support levels and level-ups are symmetrical: Byleth and Alois is the same as Alois and Byleth.
3. Although there are 37 total playable characters in the base game (ignoring DLC characters), at most 32 are available in any given run. The player must choose between Male and Female versions of the protagonist, and depending on their choices certain other characters will not be available to recruit. In the base case here, we will use a campaign with a Female Byleth (protagonist) on the "Golden Deer" route.
4. No matter how big the overall party grows, at most 10 characters can be selected to participate in any given battle.
5. Support levels cannot increase by more than 1 level for any given battle. 

## Further Simplifying Assumptions for Initial Analysis
6. Fighting alongside each other in battle is the *only* way for characters to increase their support level with each other. Other approaches in the game exist, but these will be ignored for the moment.
7. While you cannot get *more* than 1 support level up per battle, we will assume that the player positions characters perfectly *in* each battle, so that every battle together always results in a support level up if one is available.
8. "+" versions of levels are purely terminal. E.g. A+ is one level higher than A, in lieu of S being a possible level for that pairing. They are otherwise equivalent for our analysis.

## Included files
`supports_network_solver.R`: Iniital R script to load data, clean and transform it, and ultimately perform the optimization algorithm for a given party set.
`supports_sheet.csv`: A spreadsheet representation of the highest possible support level availabe to each character pairing. Sourced from [this Google Sheet](https://docs.google.com/spreadsheets/d/1nxDUkeL09uBUwFfumOGBsFYaCcqP8v3lRQqK31bqL_o/edit#gid=0). Credit to [Reddit user G-Dragonite for creating this](https://www.reddit.com/r/FireEmblemThreeHouses/comments/cx2ft0/i_made_a_spreadsheet_for_support_conversations/)!
