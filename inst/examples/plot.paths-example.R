data(tatar)

m1 <- c("trust_g1", "victim_g1", "fear_g1")
m2 <- c("trust_g2", "victim_g2", "fear_g2")
m3 <- c("trust_g3", "victim_g3", "fear_g3")
mediators <- list(m1, m2, m3)

formula_m0 <- annex ~ kulak + prosoviet_pre + religiosity_pre + land_pre +
  orchard_pre + animals_pre + carriage_pre + otherprop_pre + violence
formula_m1 <- update(formula_m0,    ~ . + trust_g1 + victim_g1 + fear_g1)
formula_m2 <- update(formula_m1,    ~ . + trust_g2 + victim_g2 + fear_g2)
formula_m3 <- update(formula_m2,    ~ . + trust_g3 + victim_g3 + fear_g3)
formula_ps <- violence ~ kulak + prosoviet_pre + religiosity_pre +
  land_pre + orchard_pre + animals_pre + carriage_pre + otherprop_pre

####################################################
# Causal Paths Analysis using GLM
####################################################

# outcome models
glm_m0 <- glm(formula_m0, family = binomial("logit"), data = tatar)
glm_m1 <- glm(formula_m1, family = binomial("logit"), data = tatar)
glm_m2 <- glm(formula_m2, family = binomial("logit"), data = tatar)
glm_m3 <- glm(formula_m3, family = binomial("logit"), data = tatar)
glm_ymodels <- list(glm_m0, glm_m1, glm_m2, glm_m3)

# propensity score model
glm_ps <- glm(formula_ps, family = binomial("logit"), data = tatar)

# causal paths analysis using glm
# note: For illustration purposes only a small number of bootstrap replicates are used
paths_glm <- paths(a = "violence", y = "annex", m = mediators,
  glm_ymodels, ps_model = glm_ps, data = tatar, nboot = 3)


# plot total, direct, and path-specific effects
plot(paths_glm, mediator_names = c("G1 identity", "G2 identity", "G3 identity"),
     estimator = "both")

