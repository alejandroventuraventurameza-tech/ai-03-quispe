# Handwritten derivation plan for Proposition 3

The submission still requires photographs of work genuinely written by hand. This file is a guide, not a substitute for those photographs.

## Recommended output

Write two notebook pages and photograph each page clearly:

- `prop-3-page-1.jpg`: survival probability, cumulative probability, Equation (10), and nonnegativity.
- `prop-3-page-2.jpg`: first difference, closed-frontier growth and concavity, and the $p^2=1$ endpoint correction.

Keep crossings-out and intermediate algebra visible. The point is to show the step that was independently checked, not to typeset a second copy of the paper.

## Page 1: derive the cumulative effect

1. Write the domain:

   $$
   s\in\mathbb N_0,
   \qquad
   0\le p^1_{ik}\le p^2_{ik}\le1.
   $$

2. Explain in one sentence why horizon $s$ contains $s+1$ periods: $0,1,\ldots,s$.

3. Derive the no-first-use probability:

   $$
   \Pr(\mathcal T^g_{ik}>s)
   =(1-p^g_{ik})\cdots(1-p^g_{ik})
   =(1-p^g_{ik})^{s+1}.
   $$

4. Take the complement:

   $$
   \Pr(\mathcal T^g_{ik}\le s)
   =1-(1-p^g_{ik})^{s+1}.
   $$

5. Sum over $k\in\mathcal U_i$ and subtract Generation 1 from Generation 2. Show the cancellation of the two ones:

   $$
   \Delta C_i(s)
   =\sum_{k\in\mathcal U_i}
   \left[(1-p^1_{ik})^{s+1}-(1-p^2_{ik})^{s+1}\right].
   $$

6. Prove nonnegativity by writing

   $$
   p^2_{ik}\ge p^1_{ik}
   \Rightarrow
   0\le1-p^2_{ik}\le1-p^1_{ik}
   $$

   and then raising both nonnegative bases to the positive integer $s+1$.

## Page 2: check growth, concavity, and the endpoint

1. For one language define

   $$
   d(s)=(1-p^1)^{s+1}-(1-p^2)^{s+1}.
   $$

2. Derive the first difference without skipping the factoring step:

   $$
   d(s+1)-d(s)
   =p^2(1-p^2)^{s+1}-p^1(1-p^1)^{s+1}.
   $$

3. Impose the closed frontier $p^1=0$ and simplify:

   $$
   d(s)=1-(1-p^2)^{s+1},
   $$

   $$
   d(s+1)-d(s)=p^2(1-p^2)^{s+1}.
   $$

4. State why this is strictly positive only when

   $$
   0<p^2<1.
   $$

5. Derive the second difference:

   $$
   [d(s+2)-d(s+1)]-[d(s+1)-d(s)]
   =-(p^2)^2(1-p^2)^{s+1}<0.
   $$

6. Test the omitted endpoint explicitly:

   $$
   p^2=1
   \Rightarrow
   d(s)=1-0^{s+1}=1.
   $$

   Write the verdict: the effect jumps immediately and is constant afterward, so strict increase and strict concavity fail at $p^2=1$.

7. Finish with a boxed corrected statement:

   $$
   \boxed{p^1=0,\ 0<p^2<1
   \Rightarrow d(s)\text{ is strictly increasing and strictly concave}.}
   $$

## What to say when the photo appears in the presentation

“I trusted the nonnegativity result, but I checked the strict endpoint claim. The proof multiplies by $(1-p^2)^{s+1}$ and calls the result strictly positive. That requires $p^2<1$. At $p^2=1$, the language is used with certainty immediately, so the cumulative effect is already one and remains flat. The corrected proposition excludes that endpoint for strictness.”

