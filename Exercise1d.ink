VAR shot_inside = 0
VAR shot_outside = 0
VAR defense = 0
VAR rebounding = 0
VAR availpoints = 5

VAR has_basketball = 0

VAR points = 0
VAR shots = 0
VAR makes = 0
VAR rebounds = 0

VAR quarter = 1
VAR time = 0
VAR quarter_adv = 0

-> start

== start ==
Welcome to Basketball Simulator
 * [Start] -> character_creation
 
== character_creation ==
Available Points = {availpoints}
 + {availpoints > 0} [Upgrade Inside Shot: {shot_inside}] {increase_shot_inside()} -> character_creation
 + {availpoints > 0} [Upgrade Outside Shot: {shot_outside}] {increase_shot_outside()} -> character_creation
 + {availpoints > 0} [Upgrade Defense: {defense}] {increase_defense()} -> character_creation
 + {availpoints > 0} [Upgrade Rebounding: {rebounding}] {increase_rebounding()} -> character_creation
 * {availpoints == 0} [Done] -> court_back
 
=== function increase_shot_inside
 ~ shot_inside += 1
 ~ availpoints -= 1
 === function increase_shot_outside
 ~ shot_outside += 1
 ~ availpoints -= 1
 === function increase_defense
 ~ defense += 1
 ~ availpoints -= 1
 === function increase_rebounding
 ~ rebounding += 1
 ~ availpoints -= 1

== court_back ==
~ quarter_adv = time_advance()
{ quarter_adv == 1:
 -> court_back
 }
 { quarter_adv == 2:
  -> end_game_screen
 }
 
You're at the back of the court. {has_basketball: In your hands is the basketball.} What will you do?
 + [Move Up] -> court_back_mid
 + {not has_basketball} [Call for basketball] -> basketball_called_for(-> court_back)
 + [Stats] -> view_stats(->court_back)

== court_back_mid ==
~ quarter_adv = time_advance()
{ quarter_adv == 1:
 -> court_back
 }
 { quarter_adv == 2:
  -> end_game_screen
 }
You're at the back-middle of the court. {has_basketball: In your hands is the basketball.} What will you do?
 + [Move Up] -> court_front_mid
 + {not has_basketball} [Call for basketball] -> basketball_called_for(-> court_back_mid)
 + [Stats] -> view_stats(->court_back_mid)

== court_front_mid ==
~ quarter_adv = time_advance()
{ quarter_adv == 1:
 -> court_back
 }
 { quarter_adv == 2:
  -> end_game_screen
 }
You're at the front-middle of the court. {has_basketball: In your hands is the basketball.} What will you do?
 + [Move Up] -> court_front
 + {not has_basketball} [Call for basketball] -> basketball_called_for(-> court_front_mid)
 + {has_basketball} [Attempt 3-Point Shot] -> basketball_shot(1)
 + [Stats] -> view_stats(->court_front_mid)

== court_front ==
~ quarter_adv = time_advance()
{ quarter_adv == 1:
 -> court_back
 }
 { quarter_adv == 2:
  -> end_game_screen
 }
You're at the back-middle of the court. {has_basketball: In your hands is the basketball.} What will you do?
 + [Move Back] -> court_front_mid
 + {not has_basketball} [Call for basketball] -> basketball_called_for(-> court_front)
 + {has_basketball} [Attempt 2-Point Shot] -> basketball_shot(0)
 + [Stats] -> view_stats(->court_front)
 
 == end_game_screen == 
 Your final stats: 
 Points: {points}
 Rebounds: {rebounds}
 Shots: {shots}
 
 -> END
 
 == view_stats(->x) ==
 Points: {points}
 Rebounds: {rebounds}
 Shots: {shots}
 
 + [Return] -> x
 
 == basketball_called_for(->x) ==
 ~ temp chance = RANDOM(1, 10)
 {  chance > 3:
        The basketball is passed to you.
        ~ has_basketball = 1
        + [Catch the basketball] -> x
        
    - else:
        You're ignored by your teammate.
        + [Resume playing] -> x
 }
 
 == basketball_shot(inout) ==
 ~ temp chance = RANDOM(0, 10)
 ~ shots += 1
 { inout == 0:
    { chance < shot_inside + 1:
        You make the shot.
        ~ points += 2
        ~ makes += 1
        ~ has_basketball = 0
        + [Move back to defense] -> court_back
    - else:
        You miss the shot
        + [Attempt Rebound] -> rebound_attempt
    }
  - else:
    { chance < shot_outside + 1:
        You make the shot.
        ~ points += 3
        ~ makes += 1
        ~ has_basketball = 0
        + [Move back to defense] -> court_back
    - else:
        You miss the shot
        ~ has_basketball = 0
        + [Move back to defense] -> court_back
    }
}

== rebound_attempt ==
 ~ temp chance = RANDOM(0, 10)
 { chance < rebounding + 1:
    You get the rebound.
    ~ rebounds += 1
    + [Continue] -> court_front
   - else:
    You don't get the rebound.
    ~ has_basketball = 0
    + [Move back to defense] -> court_back
  }
    
== function time_advance ==
 ~ time += 1
 { time > 10:
  ~ time = 0
  ~ quarter += 1
  ~ quarter_adv = 1
  { quarter > 4:
   The final buzzer sounds.
   ~ return 2
   - else:
   The buzzer sounds, the quarter has ended.
   ~ return 1
   }
  - else:
    It is Quarter {quarter} with {11-time} minutes remaining.
    ~ return 0
  }
   
    
    
            
        
    
 