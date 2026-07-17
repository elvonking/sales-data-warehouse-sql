from pathlib import Path
from faker import Faker
import pandas as pd
import random

fake = Faker()

random.seed(42)
Faker.seed(42)

OUTPUT_DIR = Path(__file__).resolve().parents[1] / "data" / "raw"
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

N_CUSTOMERS = 5000

segments = [
    "Consumer",
    "Corporate",
    "Small Business"
]

rows = []

for customer_id in range(1, N_CUSTOMERS + 1):

    rows.append({
        "customer_id": customer_id,
        "first_name": fake.first_name(),
        "last_name": fake.last_name(),
        "email": fake.email(),
        "phone": fake.phone_number(),
        "gender": random.choice(["Male", "Female"]),
        "birth_date": fake.date_of_birth(
            minimum_age=18,
            maximum_age=80
        ),
        "city": fake.city(),
        "state": fake.state(),
        "country": "United States",
        "signup_date": fake.date_between(
            start_date="-5y",
            end_date="today"
        ),
        "customer_segment": random.choice(segments),
        "loyalty_points": random.randint(0, 5000)
    })

df = pd.DataFrame(rows)

# Introduce some dirty data
df.loc[20, "email"] = "bademail"
df.loc[45, "phone"] = None
df.loc[100, "customer_segment"] = None
df.loc[50, "first_name"] = df.loc[50, "first_name"].upper()
df.loc[60, "last_name"] = "  " + df.loc[60, "last_name"] + " "

df.to_csv(OUTPUT_DIR / "customers.csv", index=False)

print("customers.csv created")