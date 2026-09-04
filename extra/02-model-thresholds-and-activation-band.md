# Model tutorial 1: thresholds and the activation band

## Scope of this block

This tutorial reconstructs Sections 4.1–4.2 and Appendix A.1–A.4 of Quispe and Xu (2026). Its purpose is to make every step from the primitive uncertainty to Proposition 2 explicit. Proposition 3 and the stock-flow dynamics are deliberately reserved for the next block.

The central idea is simple: an opportunity becomes feasible when its value is high enough to cover the relevant entry threshold. Agentic AI matters only when delegation creates a lower threshold than the best pre-agent option.

## 1. The economic objects

Fix one developer $i$, programming language $k$, and month $t$. We suppress these subscripts until they are needed.

| Object | Economic meaning |
|---|---|
| $\omega$ | Value of the current opportunity in this language |
| $b$ | Activation or entry cost |
| $s\in[0,1]$ | Language-specific execution skill |
| $\theta\sim\mathcal N(\mu,1/\pi)$ | Uncertain developer-language productivity match |
| $\mu$ | Expected match quality |
| $\pi$ | Precision of the belief; larger $\pi$ means less uncertainty |
| $a\ge0$ | General ability to specify, decompose, and verify work |
| $A$ | Agent capability |
| $z(A)$ | Agent competence produced by capability $A$ |
| $\rho>0$ | CARA risk-aversion coefficient |
| $\lambda\in(0,1]$ | Share of execution delegated to the agent |
| $\kappa(a,s)$ | Human verification cost |
| $r_C,r_D$ | Interaction or compute costs of conversational and delegated modes |
| $\sigma_D^2(a,s,A)$ | Residual variance of agent error |

The distinction between $s$ and $a$ is the model’s key modelling choice. A conversational assistant produces suggestions that the developer must implement, so its usefulness scales with language-specific skill $s$. A coding agent executes part of the task, so its expected contribution scales with the developer’s language-invariant ability $a$ to specify and verify.

## 2. Why the model uses certainty-equivalent surplus

With CARA utility $u(y)=-\exp(-\rho y)$ and a Normally distributed payoff $Y\sim\mathcal N(m,\sigma^2)$, expected utility is

$$
\mathbb E[-\exp(-\rho Y)]
=-\exp\left(-\rho m+\frac{\rho^2\sigma^2}{2}\right).
$$

The certainty equivalent $CE$ is the sure payoff that gives the same utility:

$$
-\exp(-\rho CE)
=-\exp\left(-\rho m+\frac{\rho^2\sigma^2}{2}\right).
$$

Because the exponential function is one-to-one, equate the exponents:

$$
-\rho CE=-\rho m+\frac{\rho^2\sigma^2}{2}.
$$

Divide by $-\rho$:

$$
CE=m-\frac{\rho\sigma^2}{2}.
$$

The developer therefore evaluates each production mode as expected payoff minus a risk penalty. Higher variance, holding the mean fixed, makes activation less attractive.

## 3. The three production modes

### 3.1 Solo production

The uncertain language-specific output is $s\theta$. Since $\theta$ has mean $\mu$ and variance $1/\pi$,

$$
\mathbb E[s\theta]=s\mu,
\qquad
\operatorname{Var}(s\theta)=s^2\operatorname{Var}(\theta)=\frac{s^2}{\pi}.
$$

Add opportunity value $\omega$, subtract activation cost $b$, and apply the certainty-equivalent formula:

$$
V^S
=\omega+s\mu-b-\frac{\rho}{2}\frac{s^2}{\pi}
=\omega+s\mu-\frac{\rho s^2}{2\pi}-b.
$$

**Intuition.** Skill raises expected output, but uncertain skill also exposes a risk-averse developer to match risk. Precision $\pi$ reduces that risk penalty.

### 3.2 Conversational or copilot assistance

Generation-1 assistance adds the deterministic benefit $\gamma s$ and costs $r_C$:

$$
V^C=V^S+\gamma s-r_C.
$$

There is no new execution technology in this expression. The developer still has to read, adapt, place, run, and verify the suggestion, so the benefit is proportional to existing skill.

Assumption 1 imposes

$$
\gamma\underline s-r_C\le0
\quad\text{for unfamiliar languages},
$$

and

$$
\gamma\bar s-r_C>0
\quad\text{for familiar languages}.
$$

This is not derived from deeper primitives. It is the assumption that prevents conversational AI from opening an unfamiliar language on impact.

### 3.3 Delegated production

Delegation leaves the human executing share $1-\lambda$ and gives share $\lambda$ to the agent. The expected human component is $(1-\lambda)s\mu$. The expected agent component is $\lambda az(A)$.

The human-match variance becomes

$$
\operatorname{Var}((1-\lambda)s\theta)
=\frac{(1-\lambda)^2s^2}{\pi}.
$$

The model adds residual agent-error variance $\sigma_D^2(a,s,A)$. Verification costs $\kappa(a,s)$ and compute costs $r_D$ are also subtracted. Thus

$$
\begin{aligned}
V^D={}&\omega+(1-\lambda)s\mu+\lambda az(A)-\kappa(a,s)-r_D-b\\
&-\frac{\rho}{2}\left[
\frac{(1-\lambda)^2s^2}{\pi}+\sigma_D^2(a,s,A)
\right].
\end{aligned}
$$

Assumption 2 requires verification costs and residual error to be weakly lower for stronger developers, more familiar languages, and more capable agents:

$$
\kappa_a<0,\qquad \kappa_s\le0,
$$

$$
\frac{\partial\sigma_D^2}{\partial a}\le0,
\qquad
\frac{\partial\sigma_D^2}{\partial s}\le0,
\qquad
\frac{\partial\sigma_D^2}{\partial A}\le0.
$$

## 4. Turning surpluses into activation thresholds

Every surplus is affine in $\omega$: it has the form $V^m=\omega-T^m$. A mode is viable exactly when $V^m\ge0$, or equivalently when $\omega\ge T^m$.

### 4.1 Solo threshold

Start from

$$
\omega+s\mu-\frac{\rho s^2}{2\pi}-b\ge0.
$$

Move every term except $\omega$ to the right-hand side:

$$
\omega\ge b-s\mu+\frac{\rho s^2}{2\pi}.
$$

Therefore

$$
T^S=b-s\mu+\frac{\rho s^2}{2\pi}.
$$

Higher entry cost raises the threshold; higher expected productivity lowers it; greater uncertainty or risk aversion raises it.

### 4.2 Conversational threshold and the pre-agent menu

Because $V^C=V^S+\gamma s-r_C$,

$$
T^C=T^S-(\gamma s-r_C).
$$

Before agentic adoption the developer can choose either solo or conversational production. The first mode to become viable is the one with the smaller threshold:

$$
\begin{aligned}
T^1
&=\min\{T^S,T^C\}\\
&=\min\{T^S,T^S-(\gamma s-r_C)\}\\
&=T^S-\max\{0,\gamma s-r_C\}.
\end{aligned}
$$

For an unfamiliar language, Assumption 1 gives $\gamma s-r_C\le0$. Hence

$$
T^1=T^S.
$$

This equality is the foothold mechanism: conversational assistance does not change the unfamiliar-language entry margin.

### 4.3 Delegation threshold

Set $V^D\ge0$ and isolate $\omega$:

$$
\begin{aligned}
T^D={}&b-(1-\lambda)s\mu-\lambda az(A)+\kappa(a,s)+r_D\\
&+\frac{\rho}{2}\left[
\frac{(1-\lambda)^2s^2}{\pi}+\sigma_D^2(a,s,A)
\right].
\end{aligned}
$$

After adoption the developer keeps both old modes and gains delegation, so

$$
T^2=\min\{T^1,T^D\}\le T^1.
$$

The weak inequality follows from menu expansion alone. It does not yet say that delegation is ever chosen.

## 5. Deriving the delegation advantage line by line

For an unfamiliar language, $T^1=T^S$. Define

$$
B\equiv T^1-T^D=T^S-T^D.
$$

Substitute the two thresholds:

$$
\begin{aligned}
B={}&\left(b-s\mu+\frac{\rho s^2}{2\pi}\right)\\
&-\left\{
b-(1-\lambda)s\mu-\lambda az(A)+\kappa(a,s)+r_D
+\frac{\rho}{2}\left[
\frac{(1-\lambda)^2s^2}{\pi}+\sigma_D^2
\right]
\right\}.
\end{aligned}
$$

First, $b-b=0$. Group the expected-output terms:

$$
-s\mu+(1-\lambda)s\mu+\lambda az(A)
=\lambda[az(A)-s\mu].
$$

The verification and compute costs enter with negative signs:

$$
-\kappa(a,s)-r_D.
$$

For the risk terms,

$$
\begin{aligned}
&\frac{\rho}{2}\left[
\frac{s^2}{\pi}-\frac{(1-\lambda)^2s^2}{\pi}-\sigma_D^2
\right]\\
&=\frac{\rho}{2}\left[
\frac{[1-(1-\lambda)^2]s^2}{\pi}-\sigma_D^2
\right].
\end{aligned}
$$

Expand the square:

$$
1-(1-\lambda)^2
=1-(1-2\lambda+\lambda^2)
=2\lambda-\lambda^2.
$$

Combining the pieces yields

$$
\boxed{
B=\lambda[az(A)-s\mu]-\kappa(a,s)-r_D
+\frac{\rho}{2}\left[
\frac{(2\lambda-\lambda^2)s^2}{\pi}-\sigma_D^2(a,s,A)
\right]
}.
$$

### Economic decomposition

1. **Expected execution substitution:** $\lambda[az(A)-s\mu]$. Delegation is attractive when agent execution, scaled by general ability, replaces weak expected human execution in the unfamiliar language.
2. **Verification and compute costs:** $-\kappa-r_D$. Even a capable agent does not help if steering, checking, and compute are too costly.
3. **Risk substitution:** the bracketed term. Delegation removes part of the uncertain human-match exposure but introduces residual agent-error risk.

The condition $B>0$ is equivalent to $T^D<T^S$. It is a condition, not an automatic consequence of having an agent.

## 6. Proposition 1: weak frontier expansion

The pre-agent menu is a subset of the post-agent menu:

$$
\mathcal M_1=\{S,C\}\subset\{S,C,D\}=\mathcal M_2.
$$

Therefore

$$
V^2=\max\{V^S,V^C,V^D\}
\ge\max\{V^S,V^C\}=V^1.
$$

If a language was active before adoption, $V^1\ge0$, then $V^2\ge V^1\ge0$, so it remains active. If it was inactive, its indicator was zero and cannot become negative. Hence

$$
Z^2_{ik,t}\ge Z^1_{ik,t}
$$

for every realization, and summing over languages gives

$$
N^2_{it}\ge N^1_{it}.
$$

**Verdict.** The proposition is correct but nearly mechanical. It follows because old options remain available. It would fail if adopting the agent removed an old option, imposed a fixed portfolio-level cost, or changed the opportunity itself; those possibilities are outside this model.

## 7. Proposition 2: the activation band

Take an unfamiliar language satisfying Assumption 1 and suppose $B>0$. Then

$$
T^1=T^S,
\qquad
T^D<T^S,
\qquad
T^2=T^D.
$$

The two activity indicators are

$$
Z^1=\mathbf 1[\omega\ge T^S],
\qquad
Z^2=\mathbf 1[\omega\ge T^D].
$$

Now split the opportunity line into three regions:

| Opportunity value | Before adoption | After adoption | Change |
|---|---:|---:|---:|
| $\omega<T^D$ | 0 | 0 | 0 |
| $T^D\le\omega<T^S$ | 0 | 1 | 1 |
| $\omega\ge T^S$ | 1 | 1 | 0 |

Only the middle region changes behavior. Therefore

$$
\boxed{
Z^2_{ik,t}-Z^1_{ik,t}
=\mathbf 1[T^D_{ik,t}\le\omega_{ik,t}<T^S_{ik,t}]
}.
$$

This half-open interval is the **activation band**. The lower endpoint is included because delegation is viable when its surplus equals zero. The upper endpoint is excluded because at $\omega=T^S$ solo production is already viable, so the language is not newly activated by delegation.

If the conditional CDF $F$ of $\omega$ is continuous,

$$
\Pr(T^D\le\omega<T^S)=F(T^S)-F(T^D).
$$

Continuity is not needed for the path-by-path indicator result. It is used for this clean probability expression without mass-point corrections.

## 8. Numerical example

This example is illustrative, not calibrated. Let

$$
s=0.2,\quad \mu=2,\quad \pi=4,\quad \rho=1,\quad b=1.2,
$$

and let

$$
\lambda=0.6,\quad az(A)=1.44,\quad \kappa=0.15,
\quad r_D=0.10,\quad \sigma_D^2=0.02.
$$

The solo threshold is

$$
T^S
=1.2-(0.2)(2)+\frac{(1)(0.2)^2}{2(4)}
=0.805.
$$

The expected-execution part of $B$ is

$$
0.6[1.44-0.4]=0.624.
$$

The cost part is $-0.15-0.10=-0.25$, and the risk part is

$$
\frac12\left[
\frac{(1.2-0.36)(0.04)}{4}-0.02
\right]
=-0.0058.
$$

Thus

$$
B=0.624-0.25-0.0058=0.3682,
$$

and

$$
T^D=T^S-B=0.4368.
$$

The activation band is approximately $[0.437,0.805)$. If an opportunity has value $\omega=0.60$, solo surplus is $0.60-0.805=-0.205$, while delegated surplus is $0.60-0.4368=0.1632$. The project is undertaken only after the delegation option becomes available.

## 9. Does the mechanism really require an agent?

This is the first mandatory trap from the course issue.

The mathematical answer is **no, not by itself**. Any intervention that adds an option with a lower entry threshold creates an interval of opportunities that become active. A subsidy, a fall in fixed cost $b$, better documentation, a collaborator, or a sufficiently large generic productivity shock could generate the same threshold geometry.

What makes the model specifically agentic is the proposed structure of the threshold reduction:

- conversational value scales with language-specific skill $s$;
- delegated output scales with general ability $a$ and agent capability $A$;
- delegation carries verification cost and residual-error risk;
- the strongest extensive-margin gains should occur among developers with high general ability and many unfamiliar-language candidates.

Therefore Proposition 2 proves that **this specified delegation technology** can expand the production frontier. It does not prove that an observed activation band uniquely identifies delegation. Empirically distinguishing the mechanism requires heterogeneity and robustness patterns that a generic activity or productivity shock would not reproduce.

## 10. Endpoint and domain audit

| Case | What the equations imply | Interpretation |
|---|---|---|
| $B=0$ | $T^D=T^S$ and $[T^D,T^S)$ is empty | Weak frontier expansion remains, but delegation creates no new language |
| $B<0$ | Delegation has a higher threshold than solo production | The new option is ignored; Proposition 2’s strict-expansion premise fails |
| $\lambda\to0$ | $B\to-\kappa-r_D-\rho\sigma_D^2/2$ if costs and residual risk remain | A mode that delegates no execution should not create an activation band |
| $\lambda=1$ | Human match risk disappears; agent residual risk remains | Full delegation can help only if expected agent execution and risk reduction cover verification, compute, and residual risk |
| $s=0$ | $B=\lambda az(A)-\kappa(a,0)-r_D-\rho\sigma_D^2/2$ | A truly unfamiliar language can still be activated if specification and agent execution are strong enough |
| $a=0$ | Expected agent execution is zero, but risk substitution may still affect $B$ | The text’s “no ability, no value” intuition is exact for mean output, not automatically for total certainty-equivalent value |
| $\rho=0$ | The entire risk-substitution term vanishes | A risk-neutral developer compares expected execution gains with verification and compute costs |
| $\pi\to\infty$ | Human match uncertainty vanishes | Delegation can no longer create value by removing human-match risk; residual agent risk works against it |

Two points deserve further checking later. First, at $a=0$ the mean contribution $\lambda az(A)$ is zero, but a risk-averse developer might still value a reduction in human-match variance if residual agent risk and costs are sufficiently small. Second, the paper states $\lambda\in(0,1]$, so $\lambda=0$ is a limiting diagnostic rather than an included parameter value.

## 11. What has been established

The logic from the three surplus functions to Proposition 2 is valid. The threshold algebra is exact, the half-open activation band follows from a complete case split, and the path-by-path weak expansion follows from menu inclusion.

The substantive conclusions require more care:

- Assumption 1 rules out conversational activation of unfamiliar languages rather than deriving that exclusion.
- $B>0$ must hold for a given developer-language opportunity; agent access alone does not guarantee it.
- The threshold geometry is not unique to agents.
- The model concerns production with an agent, not unassisted skill acquisition.
- The model can organize the empirical patterns, but it cannot by itself resolve selection into adoption.

## 12. Questions to answer before moving on

1. Which term in $B$ is doing the most economic work: expected execution substitution or risk substitution?
2. Is Assumption 1 empirically plausible for modern conversational models that can explain unfamiliar code line by line?
3. At $a=0$, should the model impose additional restrictions so that delegation cannot be valuable purely as a reduction in human-match risk?
4. What empirical pattern would distinguish an agentic threshold reduction from a generic project-level productivity shock?
5. Why can a flow of newly used languages spike and then fall while the cumulative language stock continues rising? This is the bridge to Proposition 3.

## Source map

- [Version 2 PDF](https://arxiv.org/pdf/2605.25438v2): model and activation band on PDF-reader pages 12–16; certainty equivalent and threshold proofs on pages 60–62.
- [Version 2 arXiv record](https://arxiv.org/abs/2605.25438v2): version history and abstract.
- [Course issue](https://github.com/alexanderquispe/AI-Econ-Modeling/issues/2): required submission components and mandatory stress tests.

