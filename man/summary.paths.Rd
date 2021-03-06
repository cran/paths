% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/print.paths.R
\name{summary.paths}
\alias{summary.paths}
\alias{print.summary.paths}
\title{Summarizing Output from Causal Paths Analysis}
\usage{
\method{summary}{paths}(object, ...)

\method{print}{summary.paths}(x, ...)
}
\arguments{
\item{object}{an object of class \code{paths} returned by the
\code{\link{paths}} function.}

\item{...}{additional arguments to be passed to \code{printCoefmat} for the
\code{print} method}

\item{x}{an object of class \code{summary.paths}}
}
\value{
An object of class \code{summary.paths}, which is a list containing
  the \code{call}, \code{varnames}, \code{formulas}, \code{classes},
  \code{args}, \code{ps_formula}, \code{ps_class}, \code{ps_args},
  \code{nboot}, \code{conf_level} components from the \code{paths} object,
  plus \describe{ \item{nobs}{number of observations in \code{data}} \item{estimates}{a
  list containing four matrices, corresponding to effect estimates obtained
  using the pure imputation estimator and the imputation-based weighting
  estimator, each with Type I and Type II decompositions. Each matrix
  contains the point estimates, standard errors, and confidence intervals of
  the total effect, direct effect, and each individual indirect effect
  for the corresponding decomposition. The elements in each matrix
  are extracted from the \code{paths} object.}}
}
\description{
Function to report results from causal paths analysis. Report point estimates
and standard errors for the total effect, direct effect, and each individual
indirect effect, separately for Type I and Type II decompositions.
}
\details{
\code{print.summary.paths} tries to smartly format the point
  estimates and confidence intervals, and provides 'significance stars'
  through the \code{\link[stats]{printCoefmat}} function.

  It also prints out the names of the treatment, outcome, mediator variables as well
  as pretreatment covariates, which are extracted from the \code{formulas} argument of the
  call to \code{paths} so that users can verify if the model formulas have been
  correctly specified.
}
\examples{
# **For illustration purposes a small number of bootstrap replicates are used**

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
summary(paths_glm)

}
\seealso{
\code{\link{paths}}, \code{\link{print.paths}}, \code{\link{plot.paths}}
}
