## install packages drugbank parser
install.packages("dbparser")
library(devtools)
devtools::install_github("ropensci/dbparser")


if(!require('devtools')) install.packages('devtools')
library(devtools)
install_github('briandconnelly/pushoverr')

library(pushoverr)


set_pushover_user('uxbc65s6gnfn7qhst2zhqok82x3y5p')
set_pushover_app('au1n1s27dg8vdtnp3j7e5p7suhbxm8')

pushover(message='done')


## load dbparser package
library(dbparser)
library(dplyr)
library(ggplot2)
library(XML)


## parse data from XML and save it to memory

dvobj <- parseDrugBank(db_path            = "C:\\Users\\sabya\\Downloads\\New folder\\full database.xml",
                       drug_options       = drug_node_options(),
                       parse_salts        = TRUE,
                       parse_products     = TRUE,
                       references_options = references_node_options(),
                       cett_options       = cett_nodes_options())

pushover(message='done loading')

## load drugs data
drugs <- dvobj$drugs$general_information
pushover(message='done loading drugs data')

## load drug groups data
drug_groups <- dvobj$drugs$groups
pushover(message='done group drugs data')

## load drug targets actions data
drug_targets_actions <- dvobj$cett$targets$actions

pushover(message='done target action drugs data')



## view proportions of the different drug types (biotech vs. small molecule)
drugs %>% 
  select(type) %>% 
  ggplot(aes(x = type, fill = type)) + 
  geom_bar() + 
  guides(fill = FALSE)     ## removes legend for the bar colors

pushover(message='done view proportions of the different drug types (biotech vs. small molecule)')

## view proportions of the different drug types for each drug group
drugs %>% 
  full_join(drug_groups, by = c('primary_key' = 'drugbank_id')) %>% 
  select(type, group) %>% 
  ggplot(aes(x = group, fill = type)) + 
  geom_bar() + 
  theme(legend.position = 'bottom') + 
  labs(x = 'Drug Group', 
       y = 'Quantity', 
       title = "Drug Type Distribution per Drug Group", 
       caption = "created by ggplot") + 
  coord_flip()
pushover(message='done view proportions of the different drug types for each drug group')



## get counts of the different target actions in the data
targetActionCounts <- 
  drug_targets_actions %>% 
  group_by(action) %>% 
  summarise(count = n()) %>% 
  arrange(desc(count))

pushover(message='get counts of the different target actions in the data')



## get bar chart of the 10 most occurring target actions in the data
p <- 
  ggplot(targetActionCounts[1:10,], 
         aes(x = reorder(action,count), y = count, fill = letters[1:10])) + 
  geom_bar(stat = 'identity') +
  labs(fill = 'action', 
       x = 'Target Action', 
       y = 'Quantity', 
       title = 'Target Actions Distribution', 
       subtitle = 'Distribution of Target Actions in the Data',
       caption = 'created by ggplot') + 
  guides(fill = FALSE) +    ## removes legend for the bar colors
  coord_flip()              ## switches the X and Y axes

## display plot
p


pushover(message='get bar chart of the 10 most occurring target actions in the data')

pushover(message='complete')



# Load drugs data
drugs <- dvobj$drugs$general_information

# Filter drugs related to the immune system based on their drug group information
immune_drugs <- drugs %>%
  filter(group == "approved") %>%  # Replace "approved" with the appropriate drug group related to the immune system
  select(primary_key, name, type, groups)

# View the list of immune-related drugs
print(immune_drugs)


# Save the current workspace to a file
save.image("my_workspace.RData")

# Later, load the saved workspace to continue
load("my_workspace.RData")

# Save specific objects to a file
save(object1, object2, file = "my_objects.RData")

# Later, load the specific objects to continue
load("my_objects.RData")

# Save the sessionInfo output to a text file
sessionInfo(file = "my_session_info.txt")

# Save the sessionInfo output to a text file
sessionInfo(file = "my_session_info.txt")



