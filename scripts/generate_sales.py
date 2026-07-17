from pathlib import Path
import pandas as pd
import random
import numpy as np

random.seed(42)
np.random.seed(42)

OUTPUT_DIR = Path(__file__).resolve().parents[1] / "data" / "raw"

customers = pd.read_csv(OUTPUT_DIR / "customers.csv")
products = pd.read_csv(OUTPUT_DIR / "products.csv")

payment_methods = [
    "Cash",
    "Credit Card",
    "Debit Card",
    "PayPal"
]

channels = [
    "Online",
    "Retail",
    "Mobile App"
]

warehouses = [
    "East",
    "West",
    "Central"
]

statuses = [
    "Delivered",
    "Pending",
    "Cancelled"
]

rows = []

for sale_id in range(1, 100001):

    customer = customers.sample(1).iloc[0]
    product = products.sample(1).iloc[0]

    qty = random.randint(1, 8)

    rows.append({
        "sale_id": sale_id,
        "order_number": f"ORD-{100000 + sale_id}",
        "customer_id": customer.customer_id,
        "product_id": product.product_id,
        "order_date": pd.Timestamp("2022-01-01") +
                      pd.to_timedelta(random.randint(0, 1200), unit="D"),
        "quantity": qty,
        "unit_price": product.selling_price,
        "discount_percent": random.choice(
            [0, 5, 10, 15, 20]
        ),
        "tax_percent": 8,
        "payment_method": random.choice(payment_methods),
        "sales_channel": random.choice(channels),
        "sales_rep": f"Rep {random.randint(1,25)}",
        "warehouse": random.choice(warehouses),
        "shipping_cost": round(random.uniform(5, 50), 2),
        "order_status": random.choice(statuses),
        "delivery_days": random.randint(1, 14)
    })

df = pd.DataFrame(rows)

# Dirty data
df.loc[15, "quantity"] = -5
df.loc[22, "discount_percent"] = 140

#df.loc[35, "customer_id"] = np.nan
#df.loc[60, "product_id"] = np.nan
#df.loc[100, "shipping_cost"] = np.nan

df.to_csv(OUTPUT_DIR / "sales.csv", index=False)

print("sales.csv created")