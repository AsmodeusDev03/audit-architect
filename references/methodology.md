# 🔬 Methodology — Arsenal Científico del Audit Architect

Carga este reference cuando el agente opere en **Modo 1 (Forense Digital)** o **Modo 2 (Forense Comercial)**.

---

## 1. Ingeniería Inversa de Algoritmos

No trabajamos con "buenas prácticas" genéricas. Detectamos qué prioriza cada plataforma ahora mismo.

### Señales por plataforma

| Plataforma | Señal primaria | Señal secundaria | Cambios recientes |
|:---|:---|:---|:---|
| **TikTok** | Retención primeros 3s | Share rate | Prioriza contenido nativo sobre cross-post |
| **Instagram Reels** | Sends (compartidos por DM) | Watch time completo | Reels > Fotos en alcance 3:1 |
| **YouTube** | CTR + Watch time | Sesiones iniciadas | Shorts impulsan canales principales |
| **Twitter/X** | Replies + Bookmarks | Retweets con comentario | Prioriza hilos sobre tweets sueltos |
| **LinkedIn** | Dwell time (tiempo en post) | Comentarios de calidad | Penaliza links externos en cuerpo |
| **Google** | Core Web Vitals + Helpful Content | E-E-A-T señales | Penaliza AI-content sin valor humano |

### Método de detección de cambios

1. `web_search` → "[plataforma] algorithm update [mes] [año]"
2. `web_search` → "[plataforma] reach drop site:reddit.com"
3. `web_fetch` → perfiles del usuario + competidores, comparar métricas de engagement últimos 30 días
4. Correlacionar anomalías con fechas de updates reportados

### Señales de alerta temprana

- Engagement rate cae >30% sin cambio de contenido
- Impresiones estables pero interacciones caen → shadowban probable
- Reach se dispara en 1 post y muere en los siguientes → test algorítmico

---

## 2. Auditoría de Sentimiento Semántico

Va más allá del engagement rate. El número de interacciones no dice nada sin contexto emocional.

### Dimensiones de análisis

| Dimensión | Método | Herramienta |
|:---|:---|:---|
| **Tono general** | Clasificar comentarios en positivo/neutral/negativo | `web_fetch` + análisis manual de muestra |
| **Intención** | ¿Amor de marca, queja puntual, crisis, indiferencia? | Clasificación contextual |
| **Palabras clave** | Términos más repetidos en negativos | Frecuencia manual |
| **Pico anómalo** | ¿El pico de engagement es bueno o malo? | Correlacionar volumen con tono |

### Matriz de diagnóstico

| Engagement | Sentimiento | Diagnóstico |
|:---:|:---|:---|
| ⬆️ Alto | 😊 Positivo | ✅ Crecimiento sano |
| ⬆️ Alto | 😡 Negativo | 🔴 Crisis de reputación |
| ⬇️ Bajo | 😊 Positivo | 🟡 Comunidad leal pero pequeña |
| ⬇️ Bajo | 😡 Negativo | 🔴 Problema sistémico |
| ⬆️ Alto | 😐 Neutro | 🟡 Viralidad sin conexión de marca |

### Acción según diagnóstico

- **Crisis**: campaña de contención narrativa (ver `creative-playbook.md`)
- **Comunidad pequeña**: enfocarse en shares y UGC, no en ads
- **Viral sin conexión**: reforzar identidad de marca en siguientes posts
- **Problema sistémico**: auditoría completa de producto/atención

---

## 3. Análisis del Punto de Fuga

Rastreamos el viaje completo del usuario para encontrar dónde se rompe el interés.

### El viaje estándar

```
Impresión → Clic → Landing → Scroll → Carrito → Checkout → Pago → Post-compra
```

### Puntos de fuga comunes

| Etapa | Causa típica | Cómo detectarlo |
|:---|:---|:---|
| Impresión→Clic | Hook débil, thumbnail genérico | CTR < 1% |
| Clic→Landing | Landing lenta (>3s), no mobile | Tasa de rebote >60% |
| Landing→Scroll | Above the fold confuso | Scroll depth <25% |
| Scroll→Carrito | CTA escondido, objeciones no resueltas | Add-to-cart rate <5% |
| Carrito→Checkout | Costos ocultos, fricción | Abandon rate >70% |
| Checkout→Pago | Campos rotos, DNI no acepta formato local | Drop-off en paso específico |
| Pago→Post-compra | Sin onboarding, sin email | Repeat rate <10% |

### Método de rastreo

1. `web_fetch` → landing page, mapear estructura
2. `browser` → navegar el funnel completo, capturar cada paso
3. Identificar el paso con mayor drop-off
4. Calcular pérdida estimada: `tráfico_mensual × drop_off_% × ticket_promedio`
5. Entregar hallazgo con impacto en dinero real

---

## 4. Benchmarking de Guerrilla

No solo miramos competencia directa. Analizamos industrias ajenas para extraer patrones transferibles.

### Método de 3 círculos

```
Círculo 1: Competencia directa (mismo nicho)
Círculo 2: Industria paralela (nichos adyacentes)
Círculo 3: Mejores del mundo (cualquier sector)
```

### Qué extraer de cada círculo

| Círculo | ¿Qué buscamos? |
|:---|:---|
| **Directa** | Qué hacen bien, qué copian mal, dónde son débiles |
| **Paralela** | Tácticas de engagement que podemos adaptar |
| **Mejores del mundo** | Patrones de storytelling, UX, funnel que trascienden industrias |

### Preguntas de guerrilla

- ¿Cómo captura emails el mejor ecommerce del mundo?
- ¿Qué estructura de hilo usa el creador más viral de otra industria?
- ¿Cómo onboardea usuarios la app #1 que no es de mi nicho?
- ¿Qué hace el líder de una industria ajena que nadie en mi nicho está copiando?

---

## 5. Forense Técnico Web

### Checklist rápido

- [ ] Core Web Vitals (LCP < 2.5s, INP < 200ms, CLS < 0.1)
- [ ] Mobile-first: ¿la web se ve bien en móvil?
- [ ] Schema markup presente y correcto
- [ ] Canonical tags sin conflictos
- [ ] SSL válido y sin mixed content
- [ ] Sitemap accesible
- [ ] Robots.txt no bloquea páginas importantes
- [ ] Meta titles/descriptions únicos por página
- [ ] Imágenes con alt text y compressed
- [ ] Sin broken links internos

### Comando rápido de auditoría

```bash
# Lighthouse desde CLI
npx lighthouse <URL> --output json --chrome-flags="--headless --no-sandbox"
# Core Web Vitals field data
curl "https://chromeuxreport.googleapis.com/v1/records:queryRecord?key=API_KEY" \
  -d '{"url":"<URL>"}'
```

---

## 6. Forense Comercial

### Fórmulas clave

```
CAC = Gasto total en marketing / Nuevos clientes
LTV = Ticket promedio × Compras por año × Años de retención
Ratio LTV:CAC = LTV / CAC (saludable > 3)
Payback = CAC / (Ticket promedio × Margen bruto)
ROAS = Ingresos de ads / Gasto en ads
```

### Señales de alerta

| Métrica | 🟢 Sano | 🟡 Precaución | 🔴 Emergencia |
|:---|:---:|:---:|:---:|
| LTV:CAC | > 3x | 2-3x | < 2x |
| Payback | < 6 meses | 6-12 meses | > 12 meses |
| Churn mensual | < 5% | 5-10% | > 10% |
| ROAS | > 2x | 1-2x | < 1x |
| Margen bruto | > 60% | 30-60% | < 30% |

---

## 7. Competitor Intelligence (Automático)

### Algoritmo de detección

```
1. web_search "[nicho] [país] top [año]"
2. web_search "mejores [producto/servicio] [categoría]"
3. web_search "[nicho] instagram/tiktok más seguidos"
4. Filtrar: descartar cuentas inactivas, priorizar engagement sobre seguidores
5. Triangulación: líder (más tráfico) + trendy (creciendo rápido) + alternativo (diferenciado)
```

### Dimensiones de análisis

| Dimensión | Método | Output |
|:---|:---|:---|
| Web/Técnica | `web_fetch` homepage + `web_search "site:competidor.com"` | Velocidad, SEO, schema |
| Contenido | `web_fetch` redes sociales, blog | Hooks, frecuencia, formato |
| Engagement | Análisis de comentarios, shares | Tono, calidad, volumen |
| Funnel | Navegar web → detectar lead magnets, CTAs, email | Mapa del viaje |
| Precios | `web_fetch` pricing page | Comparación directa |
| Debilidades | `web_search "competidor quejas/reseñas/reddit"` | Puntos ciegos |

### Gap Analysis Output

```markdown
| Dimensión | Ellos | Tú | Brecha | Quick Win |
|:---|:---|:---|:---:|:---|
| Hook videos | Retienen 8s | 3s intro logo | 🔴 | Eliminar intro |
| CTAs | CTA específico por post | "Link en bio" | 🟠 | Agregar CTA contextual |
| Funnel | Lead magnet → email → upsell | Venta directa | 🟠 | Crear lead magnet |
| Velocidad | LCP 1.1s | LCP 4.2s | 🔴 | Comprimir imágenes |
| Canales | 4 plataformas activas | Solo Instagram | 🟡 | Abrir TikTok |
| Comunidad | Discord 2K miembros | Sin comunidad | 🟡 | Grupo de Telegram |
```

---

> *"El auditor mediocre cuenta seguidores. El mejor auditor sabe por qué la gente se queda, por qué se va, y en qué momento exacto está perdiendo dinero. Y te dice cómo competir mejor que nadie."*
