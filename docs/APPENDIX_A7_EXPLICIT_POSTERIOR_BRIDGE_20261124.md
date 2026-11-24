# Appendix A.7 — Gaussian joint-density bridge: reproducible diagnostic

**Status: NUMERICAL / ANALYTICALLY DERIVED, NOT YET KERNEL-VERIFIED IN LEAN.** This note targets the remaining equality between the explicit precision-weighted candidate and the regular posterior obtained in [the Lean disintegration module](../extensions/AppendixA7PosteriorDisintegration.lean).

Take prior θ ~ N(μ₀, π⁻¹), π>0, and independent Gaussian errors εₖ ~ N(0,vₖ), vₖ>0. Conditional on θ, observe xₖ=θ+εₖ. For a finite vector x, set:

- τ = π + Σₖ vₖ⁻¹, posterior precision.
- m(x) = (πμ₀ + Σₖ xₖ/vₖ)/τ, posterior mean.
- Σₓ = diag(vₖ) + π⁻¹ 11ᵀ, marginal signal covariance.

The missing disintegration reduces, using Lebesgue densities, to proving for all θ and x:

```text
 normal_pdf(theta; mu0, 1/pi) * product_k normal_pdf(x_k; theta, v_k)
   = multivariate_normal_pdf(x; mu0*ones, Sigma_x)
       * normal_pdf(theta; m(x), 1/tau).
```

By the determinant lemma,

```text
 det(Sigma_x) = (product_k v_k) * (1 + (sum_k 1/v_k)/pi).
```

By Sherman–Morrison the marginal quadratic form is

```text
 q(x) = sum_k (x_k-mu0)^2 / v_k
      - (sum_k (x_k-mu0)/v_k)^2 / tau.
```

Complete the square in θ to obtain the exponent identity; compare Gaussian normalizers using the determinant formula. The equality for `n=0` is the prior-only identity with the empty observation vector. The equality of *Lebesgue densities* must then be integrated over measurable product sets to prove that the candidate posterior kernel has the same joint `compProd` measure as `prior ⊗ₘ signalKernel`. **Only after proving that measure identity** may one invoke `bayesA7_posterior_unique_ae` to conclude almost-everywhere equality with the Mathlib posterior.

## Numerical stress test (not a formal proof)

Run:

```bash
python3 scripts/check_gaussian_bayes_identity.py
```

A deterministic seed covers 1,003 cases, including no signals, one signal, heteroskedastic signals and randomized positive precisions and variances. The numerical check compares both sides in log density to avoid underflow; it requires tolerance 1e-10 absolute/1e-11 relative. The locally executed test on 24 Nov 2026 passed all 1,003 cases with maximum log-discrepancy `6.821e-13`.

**Remaining work in Lean:** formalize finite-dimensional multivariate Gaussian predictive density or integrate the product of the univariate conditional Gaussian densities using Mathlib measure machinery; prove its covariance/determinant identity and thereby the required equality of joint measures. Also prove the correspondence to the Option-indexed prior/noise sampling law. This script does not prove any of these results, does not replace an EconCSLib semantic v11 receipt, and does not establish the mandated agent model provenance.
