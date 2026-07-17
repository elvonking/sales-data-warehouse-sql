from pathlib import Path
import pandas as pd
import random
from faker import Faker

fake = Faker()

random.seed(42)

OUTPUT_DIR = Path(__file__).resolve().parents[1] / "data" / "raw"

categories = {
    "Electronics": [
        "Laptop",
        "Keyboard",
        "Mouse",
        "Monitor",
        "Headphones"
    ],
    "Home": [
        "Chair",
        "Desk",
        "Lamp",
        "Coffee Mug"
    ],
    "Sports": [
        "Football",
        "Basketball",
        "Yoga Mat",
        "Dumbbell"
    ],
    "Clothing": [
        "T-Shirt",
        "Jeans",
        "Jacket",
        "Sneakers"
    ]
}

brands = [
    "TechPro",
    "Nova",
    "Prime",
    "Apex",
    "Vertex",
    "Fusion"
]

rows = []

product_id = 1

for _ in range(500):

    category = random.choice(list(categories.keys()))
    product = random.choice(categories[category])

    cost = round(random.uniform(5, 500), 2)
    price = round(cost * random.uniform(1.2, 2.5), 2)

    rows.append({
        "product_id": product_id,
        "product_name": product,
        "category": category,
        "subcategory": product,
        "brand": random.choice(brands),
        "supplier": fake.company(),
        "unit_cost": cost,
        "selling_price": price,
        "stock_quantity": random.randint(0, 1000),
        "reorder_level": random.randint(10, 100),
        "launch_date": fake.date_between("-4y", "today"),
        "discontinued": random.choice([True, False])
    })

    product_id += 1

df = pd.DataFrame(rows)

# Dirty data
df.loc[10, "selling_price"] = -50
df.loc[25, "brand"] = None
df.loc[35, "category"] = "electronics"

df.to_csv(OUTPUT_DIR / "products.csv", index=False)

print("products.csv created")