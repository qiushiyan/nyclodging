library(tidymodels)
library(textrecipes)

df <- listings %>% 
  select(price, list_description, neighbourhood_group, lat, lon) %>% 
  mutate(price = case_when(
    price <= 100 ~ "< 100", 
    price <= 200 ~ "100 to 200", 
    price <= 300 ~ "200 to 300", 
    price <= 400 ~ "300 to 400",
    price <= 500 ~ "400 to 500", 
    price <= 1000 ~ "500 to 1000", 
    price > 1000 ~ "> 1000"
  ) %>% factor(levels = c("< 100", "100 to 200", "200 to 300", "300 to 400", "400 to 500", "500 to 1000", "> 1000")))

df_split <- initial_split(df)
df_training <- training(df_split)
df_testing <- testing(df_split)
df_folds <- vfold_cv(df_training)

model_spec <- multinom_reg(mixture = 1, penalty = tune()) %>% 
  set_mode("classification") %>% 
  set_engine("glmnet")

model_rec <- recipe(price ~ ., 
                    data = df) %>% 
  step_tokenize(list_description) %>% 
  step_stopwords(list_description) %>% 
  step_tokenfilter(list_description, max_tokens = 200) %>% 
  step_tf(list_description) %>% 
  step_normalize(all_numeric()) %>% 
  step_dummy(neighbourhood_group)

# model_rec %>% 
#   prep() %>% 
#   bake(new_data = NULL)


model_wf <- workflow() %>% 
  add_model(model_spec) %>% 
  add_recipe(model_rec)


tune_res <- model_wf %>% 
  tune_grid(
    df_folds, 
    grid = 50, 
    control = control_grid(save_pred = TRUE), 
    metrics = metric_set(roc_auc)
  )

model_best <- tune_res %>% 
  select_best()

model_wf_final <- finalize_workflow(model_wf, model_best)

model_fit <- fit(model_wf_final, df)

model_fit2 <- butcher::butcher(model_fit)

readr::write_rds(model_fit2, "inst/app/www/classification_model.rds")
