#!/usr/bin/env python3
"""Reproducible numerical diagnostic of the finite Gaussian Bayes identity.

Not a Lean proof and not a coding-agent provenance record.
"""
import math
import random

LOG2PI = math.log(2.0 * math.pi)


def log_normal(y, mu, var):
    if not var > 0 or not math.isfinite(var):
        raise ValueError("Variance must be positive and finite")
    return -0.5 * (LOG2PI + math.log(var) + (y - mu) ** 2 / var)


def posterior_parameters(prior_mu, prior_precision, observations, variances):
    if not prior_precision > 0 or len(observations) != len(variances):
        raise ValueError("Invalid prior precision or observations")
    if not all(v > 0 for v in variances):
        raise ValueError("Signal variances must be strictly positive")
    precision = prior_precision + sum(1.0 / v for v in variances)
    mean = (prior_precision * prior_mu + sum(
        x / v for x, v in zip(observations, variances))) / precision
    return mean, 1.0 / precision


def log_predictive(observations, prior_mu, prior_precision, variances):
    """N(mu*ones, diag(v) + 1/prior_precision * ones*ones')."""
    inv_sum = sum(1.0 / v for v in variances)
    residual = [x - prior_mu for x in observations]
    weighted = sum(d / v for d, v in zip(residual, variances))
    quadratic = sum(d * d / v for d, v in zip(residual, variances))
    quadratic -= weighted ** 2 / (prior_precision + inv_sum)
    log_det = sum(math.log(v) for v in variances)
    log_det += math.log1p(inv_sum / prior_precision)
    return -0.5 * (len(observations) * LOG2PI + log_det + quadratic)


def check_case(theta, prior_mu, prior_precision, observations, variances):
    pm, pv = posterior_parameters(prior_mu, prior_precision, observations, variances)
    left = log_normal(theta, prior_mu, 1.0 / prior_precision) + sum(
        log_normal(x, theta, v) for x, v in zip(observations, variances))
    right = log_predictive(observations, prior_mu, prior_precision, variances)
    right += log_normal(theta, pm, pv)
    if not math.isclose(left, right, rel_tol=1e-11, abs_tol=1e-10):
        raise AssertionError(f"Joint factorization mismatch: {left} vs {right}")
    return abs(left - right)


def main():
    rng = random.Random(260525438)
    cases = [
        (0.0, 0.0, 1.0, [], []),
        (0.7, -1.0, 0.25, [3.0], [0.1]),
        (-2.4, 0.9, 3.0, [-3.2, 0.4, 2.1], [0.2, 1.5, 9.0]),
    ]
    for n in (1, 2, 3, 5, 10):
        for _ in range(200):
            precision = math.exp(rng.uniform(-3, 3))
            mu = rng.uniform(-5, 5)
            theta = rng.uniform(-6, 6)
            observations = [rng.uniform(-8, 8) for _ in range(n)]
            variances = [math.exp(rng.uniform(-3, 3)) for _ in range(n)]
            cases.append((theta, mu, precision, observations, variances))
    max_error = max(check_case(*case) for case in cases)
    print(f"PASS: {len(cases)} cases; maximum absolute log-density discrepancy {max_error:.3e}")
    print("Scope: numerical Gaussian factorization; not a Lean or agent-model certificate.")


if __name__ == "__main__":
    main()
