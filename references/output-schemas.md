# 📤 Output Schemas — Audit Architect

JSON schemas de output para cada uno de los 4 modos. Usa estas estructuras como referencia al generar reportes.

---

## Modo 1 — Forense Digital

```json
{
  "mode": 1,
  "audit_type": "forense_digital",
  "executive_summary": "string (1 párrafo sin jargon, para el dueño)",
  "competitors": [
    {
      "name": "string",
      "url": "string",
      "type": "leader|trendy|alternative",
      "why_matters": "string"
    }
  ],
  "gap_analysis": [
    {
      "dimension": "string",
      "them": "string",
      "you": "string",
      "gap_severity": "critical|high|medium|low",
      "quick_win": "string"
    }
  ],
  "algorithm_analysis": {
    "platform": "string",
    "detected_signals": ["string"],
    "anomalies": ["string"]
  },
  "semantic_sentiment": {
    "overall_tone": "positive|neutral|negative|crisis",
    "engagement_quality": "love|crisis|indifference",
    "sample_insights": ["string"]
  },
  "funnel_leaks": [
    {
      "stage": "string",
      "drop_off_pct": "number",
      "estimated_loss": "string (currency)",
      "cause": "string"
    }
  ],
  "technical_findings": [
    {
      "severity": "critical|high|medium|low",
      "problem": "string",
      "evidence": "string (URL|metric|screenshot)",
      "business_impact": "string",
      "solution": "string"
    }
  ],
  "guerrilla_benchmark": {
    "cross_industry_insight": "string",
    "adaptable_pattern": "string"
  },
  "action_plan": [
    {
      "timeframe": "quick_win|strategy|moonshot",
      "week": "number",
      "action": "string",
      "expected_result": "string"
    }
  ]
}
```

---

## Modo 2 — Forense Comercial

```json
{
  "mode": 2,
  "audit_type": "forense_comercial",
  "executive_summary": "string",
  "competitors": [
    {
      "name": "string",
      "url": "string",
      "price_comparison": "string",
      "offer_comparison": "string"
    }
  ],
  "unit_economics": {
    "cac": "number",
    "ltv": "number",
    "ltv_cac_ratio": "number",
    "payback_months": "number",
    "margin_pct": "number",
    "health": "healthy|warning|critical"
  },
  "roas_by_channel": [
    {
      "channel": "string",
      "roas": "number",
      "budget": "string (currency)",
      "efficiency": "excellent|good|break_even|loss"
    }
  ],
  "attribution_model": "string",
  "cash_flow_health": "healthy|warning|critical",
  "money_leaks": [
    {
      "leak": "string",
      "monthly_impact": "string (currency)",
      "solution": "string"
    }
  ],
  "findings": [
    {
      "severity": "critical|high|medium|low",
      "problem": "string",
      "evidence": "string",
      "financial_impact": "string (currency)",
      "solution": "string"
    }
  ]
}
```

---

## Modo 3 — Arquitecto Creativo

```json
{
  "mode": 3,
  "audit_type": "arquitecto_creativo",
  "campaign_name": "string",
  "executive_summary": "string",
  "competitor_content_analysis": [
    {
      "competitor": "string",
      "content_strength": "string",
      "content_weakness": "string",
      "differentiation_angle": "string"
    }
  ],
  "narrative_architecture": {
    "hook": "string (primeros 3s exactos)",
    "hook_type": "question|controversy|result|mistake|story|list",
    "archetype": "hero|sage|rebel|everyman|jester|creator|caregiver",
    "tension_curve": "string (estructura narrativa)",
    "cta": "string"
  },
  "psychological_triggers": [
    {
      "trigger": "scarcity|social_proof|fomo|authority|reciprocity|polarization|anchoring",
      "application": "string"
    }
  ],
  "channel_ecosystem": [
    {
      "channel": "string",
      "role": "discovery|debate|trust|depth|conversion|retention",
      "format": "short|medium|long",
      "content_blueprint": "string"
    }
  ],
  "real_time_opportunities": [
    {
      "trend": "string",
      "angle": "string",
      "risk_level": "low|medium|high"
    }
  ],
  "copy_variants": [
    {
      "variant": "A|B|C",
      "headline": "string",
      "body": "string",
      "cta": "string"
    }
  ],
  "safety_check": {
    "polarization_risk": "low|medium|high",
    "brand_alignment": "pass|review|fail",
    "notes": "string"
  },
  "pricing_strategy": {
    "technique": "string",
    "recommended_price": "string (currency)",
    "justification": "string"
  }
}
```

---

## Modo 4 — Fusión Completa

```json
{
  "mode": 4,
  "audit_type": "fusion_completa",
  "executive_summary": "string",
  "competitors": [
    {
      "name": "string",
      "type": "leader|trendy|alternative",
      "strengths": ["string"],
      "weaknesses": ["string"],
      "how_to_beat": "string"
    }
  ],
  "data_to_creative_map": [
    {
      "diagnosis": "string (hallazgo del auditor)",
      "creative_injection": "string (acción del creador)",
      "expected_impact": "string",
      "measurement_kpi": "string",
      "pivot_trigger": "string (condición para matar)"
    }
  ],
  "campaign_blueprint": {
    "objective": "string",
    "duration_days": "number",
    "channels": ["string"],
    "budget_allocation": [
      {"channel": "string", "pct": "number"}
    ],
    "kill_criteria": "string (ej: ROAS < 1.5 en 48h)",
    "scale_criteria": "string (ej: ROAS > 3x → duplicar presupuesto)"
  },
  "action_plan": [
    {
      "day": "number",
      "phase": "audit|diagnose|create|distribute|measure|pivot",
      "action": "string",
      "channel": "string",
      "expected_result": "string",
      "pivot_if_fails": "string"
    }
  ],
  "quick_wins": [
    {
      "timeframe": "this_week",
      "action": "string",
      "impact": "string"
    }
  ],
  "strategy": [
    {
      "timeframe": "this_month",
      "action": "string",
      "impact": "string"
    }
  ],
  "moonshot": [
    {
      "timeframe": "this_quarter",
      "action": "string",
      "impact": "string"
    }
  ]
}
```

---

## Niveles de Severidad

| Emoji | Nivel | Significado | Acción requerida |
|:---:|:---|:---|:---|
| 🔴 | Critical | Pérdida de dinero activa o riesgo de marca | Arreglar HOY |
| 🟠 | High | Problema significativo, perderá dinero pronto | Arreglar esta semana |
| 🟡 | Medium | Oportunidad de mejora clara | Arreglar este mes |
| 🟢 | Low | Nice-to-have, sin urgencia | Backlog |

---

## Formato Markdown de Output

Todo output visible debe seguir estas reglas:

- **Encabezado obligatorio**: `🧬 MODO X — Nombre del Modo`
- Tablas con `|:---|:---:|`
- Emojis de severidad en hallazgos
- **Negritas** para insights clave
- `source_url` para todo dato numérico
- ESPAÑOL para output, inglés solo para código
- Plan de acción con timeframes: Quick Wins → Estrategia → Moonshot
- Gap Analysis con competidores en tabla comparativa
