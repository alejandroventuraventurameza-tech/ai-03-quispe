# Auditoría parcial, fuente → Lean — Proposición 2 (Quispe y Xu, 2026)

**Fecha de revisión:** 2026-11-23. **Fuente primaria:** [arXiv:2605.25438v2, sección 4.2 y apéndices A.2–A.4](https://arxiv.org/html/2605.25438v2). **Estado:** extensión de equivalencias algebraicas, **no** cierre semántico de toda la formalización. **Artefacto Lean independiente:** [extensions/Prop2ThresholdBridge.lean](../extensions/Prop2ThresholdBridge.lean).

## 1. Átomos económicos de la fuente

El autor distingue tres valores de producción, afines en la oportunidad \(\omega\):

\[
\begin{aligned}
V^S &= \omega+s\mu-\frac{\rho s^2}{2\pi}-b,\\
V^C &= V^S+\gamma s-r_C,\\
V^D &= \omega+(1-\lambda)s\mu+\lambda az(A)-\kappa-r_D-b\\
&\quad-\frac{\rho}{2}\left[\frac{(1-\lambda)^2s^2}{\pi}+\sigma_D^2\right].
\end{aligned}
\]

En las ecuaciones **(16)–(19)** el paper define \(V^m=\omega-T^m\), de modo que

\[
T^S=b-s\mu+\frac{\rho s^2}{2\pi},\qquad
T^C=T^S-(\gamma s-r_C),\qquad
T^1=\min\{T^S,T^C\}.
\]

**Hipótesis de apoyo (foothold).** Para un lenguaje desconocido, el supuesto 1 exige \(\gamma s-r_C\le 0\). No se deduce de la maximización: **se asume**. Entonces \(T^1=T^S\).

La ecuación **(20)** calcula explícitamente el beneficio de delegar:

\[
\begin{split}
B\equiv T^S-T^D={}&\lambda[az(A)-s\mu]-\kappa-r_D\\
&+\frac{\rho}{2}\left[
\frac{(2\lambda-\lambda^2)s^2}{\pi}-\sigma_D^2
\right].
\end{split}
\]

**Proposición 2.** Si foothold y \(B>0\), entonces \(T^D<T^S\), \(T^2=T^D\) y

\[
Z^2-Z^1=\mathbf1[T^D\leq\omega<T^S].
\]

La identidad de indicadores es *puntual*; la probabilidad \(F(T^S)-F(T^D)\) necesita, además, una CDF condicional continua, que no forma parte de este bridge.

## 2. Qué fue insuficiente en el módulo original

La declaración existente [`activation_bandSpec`](../lean/PaperInterface.lean) y su prueba en [`ProofInterface.lean`](../lean/ProofInterface.lean) reciben directamente \(T^D\), \(T^S\) y la premisa \(T^D\le T^S\). La igualdad es correcta como álgebra de indicadores, pero **no explicita** los tres valores de producción, la minimización del menú, el supuesto foothold, la expresión de \(B\) ni la prueba de que \(B>0\) produce el orden económico de umbrales.

## 3. La extensión adicional y sus límites

La nueva estructura `DelegationPrimitives` contiene los once insumos reales de la comparación (con \(az(A)\) ya multiplicado), sin hacer pasar sus signos económicos por teoremas deducidos.

| Teorema Lean nuevo | Resultado verificado que se pretende compilar | Origen económico |
| --- | --- | --- |
| `soloValue_eq_opportunity_sub_threshold` | \(V^S=\omega-T^S\) | (16) |
| `copilotValue_eq_opportunity_sub_threshold` | \(V^C=\omega-T^C\) | (17) |
| `delegationValue_eq_opportunity_sub_threshold` | \(V^D=\omega-T^D\) | (19) |
| `delegationAdvantage_eq_threshold_difference` | Identidad completa \(B=T^S-T^D\) | (20) |
| `preThreshold_eq_solo_of_foothold` | \(\gamma s-r_C\le0\Rightarrow T^1=T^S\) | (18) + supuesto 1 |
| `postThreshold_eq_delegation_of_advantage` | \(\gamma s-r_C\le0,\ B>0\Rightarrow T^2=T^D\) | A.4 |
| `postThreshold_eq_pre_of_nonpositive_advantage` | \(\gamma s-r_C\le0,\ B\le0\Rightarrow T^2=T^1\) | Diagnóstico del extremo y caso no favorable |
| `activation_band_from_economic_primitives` | Banda completa desde los insumos, usando la prueba de indicadores original | Proposición 2 |
| `menu_surplus_weak_expansion` | \(\max(V^S,V^C)\le\max(V^S,V^C,V^D)\) | Proposición 1, apéndice A.3 |

**Restricciones no derivadas ni representadas como distribuciones:** \(\pi>0\), \(\rho>0\), \(s\in[0,1]\), \(\lambda\in(0,1]\), varianzas no negativas, supuestos de derivadas de \(\kappa\) y \(\sigma_D^2\), normalidad/CARA y el origen estocástico de \(\omega\). Las identidades son polinomiales/racionales y pueden verificarse para entradas reales generales; la interpretación económica únicamente es válida bajo el dominio correcto de la fuente.

**Estado de verificación — DEMOSTRADO EN LEAN (alcance algebraico):** [GitHub Actions #45245835608](https://github.com/alejandroventuraventurameza-tech/ai-03-quispe/actions/runs/45245835608) informó **success**. Compiló `Prop2ThresholdBridge.lean` junto con ambos módulos previos (**8,318 jobs**) y verificó mediante `#print axioms` los **20 endpoints** (9 originales + 2 de Prop. 3 + 9 de este puente), sin `sorryAx`. El comando EconCSLib `paper_contribution.py check ... --fast` también aprobó (**8,315 jobs**). Esta verificación *no certifica* CARA-normal, expectativa condicional ni comparación fuente–Spec exhaustiva.

**Próximo paso después de compilar:** ampliar la auditoría desde el artículo hacia Proposiciones 1, 4 y 5, sobre todo la expectativa condicional y las hipótesis de simetría que el `Spec` de Proposición 4 abstrae.
