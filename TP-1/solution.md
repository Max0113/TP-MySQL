# Exercice 3 — Interrogation de la base

## A. Sélections simples

### 3.1 — Véhicules hybrides ou électriques

```sql
-- 3.1
SELECT immatriculation, marque, modele
FROM Vehicule
WHERE carburant IN ('Hybride', 'Electrique')
ORDER BY marque, modele;
```

**شرح:** نعرض السيارات التي تعمل بـ `Hybride` أو `Electrique`، ثم نرتب حسب الماركة والموديل.

---

### 3.2 — Clients dont le nom commence par A

```sql
-- 3.2
SELECT *
FROM Client
WHERE nom LIKE 'A%';
```

**شرح:** `%` تعني أي عدد من الأحرف بعد `A`.

مثلاً:

- Alaoui ✅
- Amrani ✅
- Benali ❌

---

### 3.3 — Véhicules 2023–2025 avec moins de 30 000 km

```sql
-- 3.3
SELECT *
FROM Vehicule
WHERE annee BETWEEN 2023 AND 2025
  AND kilometrage < 30000;
```

`BETWEEN` هنا يشمل **2023 و2025**.

---

### 3.4 — Locations en cours

```sql
-- 3.4
SELECT *
FROM Location
WHERE date_fin IS NULL;
```

### Pourquoi `date_fin = NULL` ne fonctionne pas ?

En SQL, `NULL` signifie **absence de valeur**, لذلك لا نستعمل:

```sql
date_fin = NULL
```

بل:

```sql
date_fin IS NULL
```

Et pour vérifier qu'elle n'est pas NULL:

```sql
date_fin IS NOT NULL
```

---

### 3.5 — Villes des clients sans doublons

```sql
-- 3.5
SELECT DISTINCT ville
FROM Client
ORDER BY ville;
```

**شرح:**

`DISTINCT` تحذف التكرار.

---

# B. Jointures

### 3.6 — Véhicule + catégorie + agence

```sql
-- 3.6
SELECT
    v.immatriculation,
    v.marque,
    v.modele,
    c.libelle,
    c.tarif_jour,
    a.nom_agence
FROM Vehicule v
JOIN Categorie c
    ON v.code_cat = c.code_cat
JOIN Agence a
    ON v.id_agence = a.id_agence;
```

**الفكرة:**

```text
Vehicule
   │
   ├── code_cat → Categorie
   │
   └── id_agence → Agence
```

---

### 3.7 — Locations commencées en 2026

```sql
-- 3.7
SELECT
    l.date_debut,
    c.nom,
    c.prenom,
    v.marque,
    v.modele
FROM Location l
JOIN Client c
    ON l.id_client = c.id_client
JOIN Vehicule v
    ON l.immatriculation = v.immatriculation
WHERE l.date_debut >= '2026-01-01'
  AND l.date_debut < '2027-01-01'
ORDER BY l.date_debut;
```

يمكن أيضاً استعمال:

```sql
YEAR(l.date_debut) = 2026
```

لكن المقارنة بالتواريخ جيدة لأنها تستفيد عادةً بشكل أفضل من index على `date_debut`.

---

### 3.8 — Locations terminées + durée + tarif + montant

```sql
-- 3.8
SELECT
    l.id_location,
    DATEDIFF(l.date_fin, l.date_debut) AS nombre_jours,
    c.tarif_jour,
    DATEDIFF(l.date_fin, l.date_debut) * c.tarif_jour AS montant_base
FROM Location l
JOIN Vehicule v
    ON l.immatriculation = v.immatriculation
JOIN Categorie c
    ON v.code_cat = c.code_cat
WHERE l.date_fin IS NOT NULL
ORDER BY montant_base DESC;
```

**الفكرة:**

```text
nombre_jours = DATEDIFF(date_fin, date_debut)

montant_base = nombre_jours × tarif_jour
```

---

### 3.9 — Toutes les agences, même sans véhicule

```sql
-- 3.9
SELECT
    a.id_agence,
    a.nom_agence,
    v.immatriculation,
    v.marque,
    v.modele
FROM Agence a
LEFT JOIN Vehicule v
    ON a.id_agence = v.id_agence
ORDER BY a.id_agence;
```

**لماذا `LEFT JOIN`؟**

لأننا نريد **كل الوكالات** حتى لو لم يكن لديها véhicule.

إذا كانت الوكالة بدون véhicule، ستكون معلومات السيارة:

```text
NULL
```

---

### 3.10 — Clients qui n'ont jamais loué

```sql
-- 3.10
SELECT
    c.id_client,
    c.nom,
    c.prenom
FROM Client c
LEFT JOIN Location l
    ON c.id_client = l.id_client
WHERE l.id_location IS NULL;
```

**الفكرة المهمة:**

```text
Client
   LEFT JOIN
Location
```

ثم نبحث عن:

```sql
WHERE l.id_location IS NULL
```

يعني العميل لم نجد له أي location.

---

# C. Fonctions de groupe

### 3.11 — Nombre de véhicules par agence

```sql
-- 3.11
SELECT
    a.id_agence,
    a.nom_agence,
    COUNT(v.immatriculation) AS nombre_vehicules
FROM Agence a
LEFT JOIN Vehicule v
    ON a.id_agence = v.id_agence
GROUP BY a.id_agence, a.nom_agence;
```

### لماذا `COUNT(v.immatriculation)` وليس `COUNT(*)`؟

مع `LEFT JOIN`، الوكالة التي لا تملك سيارة سيكون عندها صف واحد بسبب الـ JOIN.

لذلك:

```sql
COUNT(*)
```

يمكن أن يعطي `1`.

لكن:

```sql
COUNT(v.immatriculation)
```

لا يحسب `NULL`، وبالتالي يعطي:

```text
0
```

وهذا بالضبط ما يطلبه السؤال. TP1_SQL_AtlasCar

---

### 3.12 — Locations terminées + kilomètres par catégorie

```sql
-- 3.12
SELECT
    c.code_cat,
    c.libelle,
    COUNT(l.id_location) AS nombre_locations,
    SUM(l.km_retour - l.km_depart) AS total_km
FROM Categorie c
JOIN Vehicule v
    ON c.code_cat = v.code_cat
JOIN Location l
    ON v.immatriculation = l.immatriculation
WHERE l.date_fin IS NOT NULL
GROUP BY c.code_cat, c.libelle;
```

**Kilomètres parcourus:**

```sql
km_retour - km_depart
```

---

### 3.13 — Chiffre d'affaires par client

```sql
-- 3.13
SELECT
    c.id_client,
    c.nom,
    c.prenom,
    SUM(
        DATEDIFF(l.date_fin, l.date_debut) * cat.tarif_jour
    ) AS chiffre_affaires
FROM Client c
JOIN Location l
    ON c.id_client = l.id_client
JOIN Vehicule v
    ON l.immatriculation = v.immatriculation
JOIN Categorie cat
    ON v.code_cat = cat.code_cat
WHERE l.date_fin IS NOT NULL
GROUP BY c.id_client, c.nom, c.prenom
ORDER BY chiffre_affaires DESC;
```

**مهم:** السؤال يطلب CA **hors équipements**، لذلك لا نستعمل `Equipement` هنا. TP1_SQL_AtlasCar

---

### 3.14 — Clients avec au moins 3 locations

```sql
-- 3.14
SELECT
    c.id_client,
    c.nom,
    c.prenom,
    COUNT(l.id_location) AS nombre_locations
FROM Client c
JOIN Location l
    ON c.id_client = l.id_client
GROUP BY c.id_client, c.nom, c.prenom
HAVING COUNT(l.id_location) >= 3;
```

**فرق مهم:**

```sql
WHERE
```

يأتي قبل `GROUP BY`.

أما:

```sql
HAVING
```

فيستعمل لتصفية **المجموعات** بعد `GROUP BY`.

---

### 3.15 — Moyenne/min/max par carburant

```sql
-- 3.15
SELECT
    carburant,
    AVG(kilometrage) AS moyenne_km,
    MIN(kilometrage) AS minimum_km,
    MAX(kilometrage) AS maximum_km
FROM Vehicule
GROUP BY carburant
HAVING AVG(kilometrage) > 20000;
```

### لماذا `HAVING` وليس `WHERE`؟

لأن:

```sql
AVG(kilometrage)
```

هي **fonction d'agrégation**.

`WHERE` يتم تطبيقه قبل `GROUP BY`، بينما `HAVING` يتم تطبيقه بعد تكوين المجموعات.

---

# D. Sous-requêtes

### 3.16 — Véhicules au-dessus de la moyenne

```sql
-- 3.16
SELECT
    immatriculation,
    marque,
    modele,
    kilometrage
FROM Vehicule
WHERE kilometrage > (
    SELECT AVG(kilometrage)
    FROM Vehicule
);
```

الـ sous-requête:

```sql
SELECT AVG(kilometrage)
FROM Vehicule
```

تعطي moyenne générale، ثم نأخذ السيارات التي تتجاوزها.

---

### 3.17 — Véhicules jamais loués avec NOT IN

```sql
-- 3.17
SELECT
    immatriculation,
    marque,
    modele
FROM Vehicule
WHERE immatriculation NOT IN (
    SELECT immatriculation
    FROM Location
);
```

**الفكرة:**

```text
Toutes les voitures
        -
Voitures présentes dans Location
        =
Voitures jamais louées
```

---

### 3.18 — Clients ayant loué au moins un SUV

السؤال يطلب **uniquement des `IN` imbriqués**, sans jointure. TP1_SQL_AtlasCar

```sql
-- 3.18
SELECT
    id_client,
    nom,
    prenom
FROM Client
WHERE id_client IN (
    SELECT id_client
    FROM Location
    WHERE immatriculation IN (
        SELECT immatriculation
        FROM Vehicule
        WHERE code_cat IN (
            SELECT code_cat
            FROM Categorie
            WHERE libelle = 'SUV'
        )
    )
);
```

**التسلسل:**

```text
Categorie
   ↓
Vehicule
   ↓
Location
   ↓
Client
```

---

### 3.19 — Véhicules moins kilométrés que TOUS ceux d'Agadir Centre

السؤال يطلب `ALL`. TP1_SQL_AtlasCar

```sql
-- 3.19
SELECT
    v.immatriculation,
    v.marque,
    v.modele,
    v.kilometrage
FROM Vehicule v
WHERE v.kilometrage < ALL (
    SELECT v2.kilometrage
    FROM Vehicule v2
    JOIN Agence a
        ON v2.id_agence = a.id_agence
    WHERE a.nom_agence = 'Agadir Centre'
);
```

### معنى `ALL`

إذا كانت قيم Agadir Centre مثلاً:

```text
10000
20000
30000
```

فإن:

```sql
kilometrage < ALL (...)
```

يعني:

```text
kilometrage < 10000
AND
kilometrage < 20000
AND
kilometrage < 30000
```

---

### 3.20 — Clients qui n'ont jamais loué de véhicule hybride

السؤال يطلب `NOT EXISTS`. TP1_SQL_AtlasCar

```sql
-- 3.20
SELECT
    c.id_client,
    c.nom,
    c.prenom
FROM Client c
WHERE NOT EXISTS (
    SELECT 1
    FROM Location l
    JOIN Vehicule v
        ON l.immatriculation = v.immatriculation
    WHERE l.id_client = c.id_client
      AND v.carburant = 'Hybride'
);
```

**الفكرة:**

لكل client نسأل:

> هل توجد location لهذا العميل بسيارة Hybride؟

إذا **لا توجد** → يظهر العميل.

---

# E. Opérateurs ensemblistes

### 3.21 — Villes avec agence OU client

```sql
-- 3.21
SELECT ville
FROM Agence

UNION

SELECT ville
FROM Client;
```

`UNION` supprime les doublons.

---

### `UNION ALL`

```sql
-- 3.21 - UNION ALL
SELECT ville
FROM Agence

UNION ALL

SELECT ville
FROM Client;
```

`UNION ALL` **ne supprime pas les doublons**.

مثلاً إذا كانت:

```text
Agence:
Agadir
Inezgane

Client:
Agadir
Agadir
Taroudant
```

`UNION`:

```text
Agadir
Inezgane
Taroudant
```

أما `UNION ALL`:

```text
Agadir
Inezgane
Agadir
Agadir
Taroudant
```

إذن عدد السطور مع `UNION ALL` يعتمد على عدد السطور الموجودة فعلياً في `Agence` و`Client`. السؤال يطلب حسابه من البيانات. TP1_SQL_AtlasCar

---

### 3.22 — Villes ayant une agence ET des clients

#### Solution avec `INTERSECT`

Le sujet précise que cette solution nécessite **MySQL 8.0.31 ou plus**. TP1_SQL_AtlasCar

```sql
-- 3.22 - INTERSECT
SELECT ville
FROM Agence

INTERSECT

SELECT ville
FROM Client;
```

يعني:

```text
Agence
  ∩
Client
```

أي المدن الموجودة في الجدولين معاً.

---

### Solution avec sous-requête `IN`

```sql
-- 3.22 - IN
SELECT DISTINCT ville
FROM Agence
WHERE ville IN (
    SELECT ville
    FROM Client
);
```

هذه تعطي نفس الفكرة بدون `INTERSECT`.

---

# Exercice 4 — Bonus

الأسئلة 4.1–4.3 هي أسئلة إضافية حسب الورقة. TP1_SQL_AtlasCar

## 4.1 — Montant total avec équipements

المطلوب:

```text
nombre de jours
×
(tarif catégorie
 + somme(prix équipement × quantité))
```

مع الاحتفاظ أيضاً بالـ locations التي ليس لديها équipement. TP1_SQL_AtlasCar

```sql
-- 4.1
SELECT
    l.id_location,
    DATEDIFF(l.date_fin, l.date_debut) AS nombre_jours,
    cat.tarif_jour,
    COALESCE(
        SUM(e.prix_jour * le.quantite),
        0
    ) AS total_equipements,
    DATEDIFF(l.date_fin, l.date_debut) *
    (
        cat.tarif_jour +
        COALESCE(SUM(e.prix_jour * le.quantite), 0)
    ) AS montant_total
FROM Location l
JOIN Vehicule v
    ON l.immatriculation = v.immatriculation
JOIN Categorie cat
    ON v.code_cat = cat.code_cat
LEFT JOIN Location_Equipement le
    ON l.id_location = le.id_location
LEFT JOIN Equipement e
    ON le.code_equip = e.code_equip
WHERE l.date_fin IS NOT NULL
GROUP BY
    l.id_location,
    l.date_debut,
    l.date_fin,
    cat.tarif_jour
ORDER BY l.id_location;
```

### لماذا `LEFT JOIN`؟

لأن location بدون équipement يجب أن تظهر أيضاً.

### لماذا `COALESCE`؟

إذا لم توجد équipement:

```sql
SUM(...) = NULL
```

ونريد:

```text
0
```

لذلك:

```sql
COALESCE(SUM(...), 0)
```

---

# 4.2 — Véhicules les plus loués par agence

المطلوب إظهار السيارة/السيارات الأكثر تأجيراً في **كل agence**، وإذا كان هناك تعادل يجب إظهار الجميع. TP1_SQL_AtlasCar

```sql
-- 4.2
WITH nb_locations AS (
    SELECT
        a.id_agence,
        a.nom_agence,
        v.immatriculation,
        v.marque,
        v.modele,
        COUNT(l.id_location) AS nombre_locations
    FROM Agence a
    JOIN Vehicule v
        ON a.id_agence = v.id_agence
    LEFT JOIN Location l
        ON v.immatriculation = l.immatriculation
    GROUP BY
        a.id_agence,
        a.nom_agence,
        v.immatriculation,
        v.marque,
        v.modele
),
classement AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            PARTITION BY id_agence
            ORDER BY nombre_locations DESC
        ) AS rang
    FROM nb_locations
)
SELECT
    id_agence,
    nom_agence,
    immatriculation,
    marque,
    modele,
    nombre_locations
FROM classement
WHERE rang = 1;
```

### Pourquoi `DENSE_RANK()` ?

Supposons:

```text
Voiture A → 5 locations
Voiture B → 5 locations
Voiture C → 3 locations
```

Les deux premières sont les plus louées.

`DENSE_RANK()` leur donne:

```text
A → 1
B → 1
C → 2
```

Donc:

```sql
WHERE rang = 1
```

retourne **A et B**.

---

# 4.3 — Client qui a le plus dépensé

Sans utiliser:

```sql
LIMIT 1
```

```sql
-- 4.3
SELECT
    c.id_client,
    c.nom,
    c.prenom,
    SUM(
        DATEDIFF(l.date_fin, l.date_debut) * cat.tarif_jour
    ) AS total_depense
FROM Client c
JOIN Location l
    ON c.id_client = l.id_client
JOIN Vehicule v
    ON l.immatriculation = v.immatriculation
JOIN Categorie cat
    ON v.code_cat = cat.code_cat
WHERE l.date_fin IS NOT NULL
GROUP BY
    c.id_client,
    c.nom,
    c.prenom
HAVING SUM(
    DATEDIFF(l.date_fin, l.date_debut) * cat.tarif_jour
) >= ALL (
    SELECT
        SUM(
            DATEDIFF(l2.date_fin, l2.date_debut) * cat2.tarif_jour
        )
    FROM Location l2
    JOIN Vehicule v2
        ON l2.immatriculation = v2.immatriculation
    JOIN Categorie cat2
        ON v2.code_cat = cat2.code_cat
    WHERE l2.date_fin IS NOT NULL
    GROUP BY l2.id_client
);
```

### Pourquoi `LIMIT 1` serait fragile ?

Avec:

```sql
ORDER BY total_depense DESC
LIMIT 1
```

si deux clients ont exactement le même montant maximal, MySQL ne retourne qu'**un seul** client.

La solution avec `>= ALL` permet de retourner **tous les clients ex æquo** au maximum.

---

## Résumé des notions à retenir pour l'examen

| Question | Notion principale              |
| -------- | ------------------------------ |
| 3.1      | `WHERE`, `IN`, `ORDER BY`      |
| 3.2      | `LIKE`                         |
| 3.3      | `BETWEEN`, `AND`               |
| 3.4      | `IS NULL`                      |
| 3.5      | `DISTINCT`                     |
| 3.6      | `JOIN`                         |
| 3.7      | `JOIN` + dates                 |
| 3.8      | `DATEDIFF` + calcul            |
| 3.9      | `LEFT JOIN`                    |
| 3.10     | `LEFT JOIN` + `IS NULL`        |
| 3.11     | `COUNT` + `GROUP BY`           |
| 3.12     | `COUNT`, `SUM`, `GROUP BY`     |
| 3.13     | `SUM` + `GROUP BY`             |
| 3.14     | `HAVING`                       |
| 3.15     | `AVG` + `HAVING`               |
| 3.16     | Sous-requête + `AVG`           |
| 3.17     | `NOT IN`                       |
| 3.18     | `IN` imbriqués                 |
| 3.19     | `ALL`                          |
| 3.20     | `NOT EXISTS`                   |
| 3.21     | `UNION`, `UNION ALL`           |
| 3.22     | `INTERSECT`, `IN`              |
| 4.1      | `LEFT JOIN`, `COALESCE`, `SUM` |
| 4.2      | `DENSE_RANK()`                 |
| 4.3      | `ALL` + agrégation             |

**Important:** I can give the exact SQL solutions from the structure and questions in your PDF, but I can't reliably give the **actual numeric/name results** for each query because the uploaded file contains the TP instructions, not the separate `tp1_donnees.sql` dataset. The PDF itself says that `tp1_donnees.sql` is the file used to populate the database from Exercise 2. TP1_SQL_AtlasCar

If you upload **`tp1_donnees.sql`**, I can also give you the **exact result of every 3.1–4.3 query**.
