library(tidymodels)
library(textrecipes)

model_spec <- multinom_reg(mixture = 1, penalty = tune()) %>% 
  set_mode("classification") %>% 
  set_engine("glmnet")

model_rec <- recipe(price ~ ., 
                    listings %>% 
                      select(price, list_description, neighbourhood_group, lat, lon)) %>% 
  step_tokenize(list_description) %>% 
  step_stopwords(list_description) %>% 
  step_tokenfilter(list_description, max_tokens = 200) %>% 
  step_tf(list_description) %>% 
  step_normalize(all_numeric()) %>% 
  step_dummy(neighbourhood_group)



model_rec %>% 
  prep() %>% 
  bake(new_data = NULL)


