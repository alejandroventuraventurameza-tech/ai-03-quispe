# Recepción y revisión de evidencia manuscrita — Proposición 3

**Recepción en esta conversación:** 2026-11-23. **Archivo recibido:** `ai-03.pdf`, PDF de 7 páginas, con anotaciones y demostraciones manuscritas. **SHA-256 del PDF original:** `ad27585154d41a63e85b46342a62fd722f60705d5ade9dfc14935dfcb4c233a6`.

**Estado de la transferencia a GitHub:** el autor ya entregó el PDF en la conversación y sus páginas fueron revisadas, pero **los archivos binarios aún no están comprometidos en este repositorio**. No confundir *evidencia recibida y validada* con *evidencia integrada en la rama*. El ZIP de entrega preparado contiene los tres archivos originales/derivados para subir al directorio `hand/`.

## Auditoría de las siete páginas

| Página del PDF | Comprobación |
| --- | --- |
| 1 | Define `0≤p1≤p2≤1`, un hazard condicional constante de primer uso, y deriva `Pr(T>s)=(1-p)^(s+1)` para los períodos `0,…,s` |
| 2 | Complemento, esperanza del número de lenguajes activados y suma que define `ΔC_i(s)` |
| 3 | Demuestra `ΔC_i(s)≥0` mediante monotonía de potencias de bases no negativas |
| 4 | Primera diferencia de `d(s)`: `p2(1-p2)^(s+1)-p1(1-p1)^(s+1)` |
| 5 | Para `p1=0`, demuestra que `d(s+1)-d(s)=p(1-p)^(s+1)>0` si `0<p<1` |
| 6 | Demuestra `Δ² d(s)=-p²(1-p)^(s+1)<0` en el interior y muestra `d(s)=1` cuando `p1=0,p2=1`, con ambas diferencias cero |
| 7 | Conclusión y condiciones corregidas, con un recuadro manuscrito |

**Resultado matemático:** no se detectaron errores algebraicos en estas siete páginas dentro del modelo con hazard condicional constante. La interpretación correcta de la página 7 es que *las propiedades estrictas* no se sostienen en `p2=1`; la no negatividad y la concavidad débil sí se conservan. Estas pruebas no demuestran por sí mismas toda la interpretación probabilística/causal ni equivalencia semántica con Lean.

## Archivos destinados al repositorio

- `hand/Prop_3_manoscrito_original.pdf` — copia binaria intacta del PDF del autor, 7 páginas, SHA-256 anterior.
- `hand/prop-3-page-1.jpg` — derivado visual de la **página 3** (no negatividad), usado por la diapositiva 8; SHA-256: `dcbd1d0344e76fd3ccb8438ef609593caa7cc8cbc01983b20129529211a89cb0`.
- `hand/prop-3-page-2.jpg` — derivado visual de la **página 6** (segunda diferencia y contraejemplo), usado por la diapositiva 9; SHA-256: `4128f5dc2a471e16c30d65b56ffbc24a34abfb4a57ed72c34bf891265b4ad999`.

**Siguiente paso material:** incorporar los tres binarios anteriores (sin modificar el PDF original) en esta rama, verificar que el nuevo `presentation.pdf` muestra las imágenes y volver a revisar las 13 páginas de Beamer. El PR #2 permanece en borrador hasta realizarlo y autenticar los logs reales del agente exigido por el curso.
