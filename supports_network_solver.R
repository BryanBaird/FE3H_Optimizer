### Graph Analysis to Optimize Fire Emblem "Support" Pairings
### Bryan Baird, with support from Agnes Trenche Mora
### March 15, 2020

library(tidyverse)
library(igraph)

# Simplfying assumptions:
# 1. All character pairings develop by exactly one level per battle together
# 2. Support levels and level-ups are symmetrical: Byleth and Alois is the
#        same as Alois and Byleth.
# 3. To minimize set, olden Golden Deer path with Female Byleth will be used first.
# 4. Start from "naive" start state of all supports at minimal levels to start.
# 5. + and - versions of levels are simplified (for now): Just C, B, A, and S. 
#        + values are the same as rounded up grades in terms of terminal steps.
#        E.g., Both S and A+ are assumed to require 4 "steps", or 4 battles.
# 6. No DLC characters for now, since they aren't in our reference sheet

### Step 1: Load in spreadsheet of all possible characters and pairings
raw_df <- read_csv("FE_supports_network/supports_sheet.csv") %>%
  rename(name = X1)

# Characters to omit from this run:
characters_to_omit <- c("Byleth (M)", "Edelgard", "Hubert", 
                        "Dedue", "Dimitri")

# Remove irrelavant characters from our pairing set
max_levels <- raw_df %>%
  subset(!name %in% characters_to_omit) %>%
  select(-characters_to_omit) %>%
  # Replace letter grades with their numeric level equivalent (could be optimized)
  mutate_each(funs(replace(.,  . == 'S', 4))) %>%
  mutate_each(funs(replace(.,  . == 'A+', 4))) %>%
  mutate_each(funs(replace(.,  . == 'A', 3))) %>%
  mutate_each(funs(replace(.,  . == 'B+', 3))) %>%
  mutate_each(funs(replace(.,  . == 'B', 2))) %>%
  mutate_each(funs(replace(.,  . == 'C+', 2))) %>%
  mutate_each(funs(replace(.,  . == 'C', 1))) %>%
  mutate_each(funs(replace(.,  is.na(.), 0))) %>%
  mutate_each(as.numeric, -name)

# Great, we have a simplified df! But it is in fact a mirrored matrix, 
#  which we will want to simplify for the math. What we want is a two-column
#  list of each pairing, with each pairing duplicated by the number of values shown.
#  E.g. Byleth (F) and Claude should be represented as four duplicate rows of
#  "Byleth (F)" | "Claude", to represent the four different level-ups it will
#  take to get them up to their max S support rank.

# Without worrying about the bidirectionality first, let's make our DF tall.
max_levels_tall <- max_levels %>%
  pivot_longer(-name, names_to = 'partner', values_to = 'levels_needed')

# Making duplicate rows will be weird, but let's brute force it with some loops?
for(x in max_levels_tall){
  print(x)
}

# Alternate, more manual approach. Also avoids double-counting relationships that are
#  bi-directional! Nice!
edges_df <- tibble()

for(x in 1:nrow(max_levels)){
  # print((paste0('x: ', x)))
  for(y in 1:x){ # first column is name, to be ignored for indexing
    #print(paste0('y: ', y))
    # print(paste0('contents: ', max_levels[x, y + 1]))
    count <- max_levels[x, y + 1]
    while(count > 0){
      edges_df <- bind_rows(edges_df, c(a = max_levels$name[x], b = colnames(max_levels[x,y+1])))
      count <- count - 1
    }
  }
}

# Let's try making a graph! It is un-directed because relationships are recipricol.
network_graph <- graph_from_data_frame(max_levels_tall, directed = FALSE)
