import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import os

# Set seed agar data konsisten setiap kali dijalankan
np.random.seed(42)

# 1. Konfigurasi Awal
start_date = datetime(2025, 1, 1)
months = 12
total_new_users = 1000

# Paket Langganan B2B SaaS
plans = {
    'Startup': {'amount': 99, 'weight': 0.60},
    'Growth': {'amount': 299, 'weight': 0.30},
    'Enterprise': {'amount': 999, 'weight': 0.10}
}

user_list = []
transaction_list = []
transaction_id_counter = 10001

# 2. Generate Data Pengguna dan Transaksi
for user_id in range(1, total_new_users + 1):
    # Distribusi pendaftaran user sepanjang tahun 2025
    signup_month = np.random.choice(range(0, months), p=[0.06, 0.06, 0.07, 0.07, 0.08, 0.08, 0.09, 0.09, 0.10, 0.10, 0.10, 0.10])
    days_offset = np.random.randint(0, 28)
    user_signup_date = start_date + timedelta(days=int(signup_month * 30 + days_offset))
    
    # Pilih Segment & Plan
    segment = np.random.choice(list(plans.keys()), p=[plans[p]['weight'] for p in plans])
    amount = plans[segment]['amount']
    
    user_list.append({
        'user_id': f'USR-{user_id:04d}',
        'signup_date': user_signup_date.strftime('%Y-%m-%d'),
        'segment': segment
    })
    
    # Simulasikan perilaku retensi bulanan (Efek Churn)
    if segment == 'Enterprise':
        retention_prob = 0.95  # Churn rate rendah (5%)
    elif segment == 'Growth':
        retention_prob = 0.88  # Churn rate sedang (12%)
    else:
        retention_prob = 0.80  # Churn rate tinggi (20%)
        
    current_date = user_signup_date
    # Transaksi Bulan ke-0 (Bulan Pendaftaran)
    active_months = [0]
    
    # Cek kelanjutan langganan untuk bulan-bulan berikutnya
    for m in range(1, months - signup_month):
        decayed_prob = retention_prob * (0.95 ** (m - 1))
        if np.random.rand() < decayed_prob:
            active_months.append(m)
        else:
            break # Jika churn, berhenti berlangganan

    # Catat semua transaksi untuk user ini
    for idx, m in enumerate(active_months):
        trans_date = user_signup_date + timedelta(days=int(m * 30.5))
        if trans_date <= datetime(2025, 12, 31):
            transaction_list.append({
                'transaction_id': f'TX-{transaction_id_counter}',
                'user_id': f'USR-{user_id:04d}',
                'transaction_date': trans_date.strftime('%Y-%m-%d'),
                'amount': amount
            })
            transaction_id_counter += 1

# 3. Konversi ke DataFrame & Simpan ke CSV
df_users = pd.DataFrame(user_list)
df_transactions = pd.DataFrame(transaction_list)

# Buat folder data/raw jika belum ada
os.makedirs('data/raw', exist_ok=True)

df_users.to_csv('data/raw/users.csv', index=False)
df_transactions.to_csv('data/raw/transactions.csv', index=False)

print("=========================================")
print("🚀 Selesai mengenerate data mock SaaS!")
print(f"Total Users Baru yang Terbuat : {len(df_users)}")
print(f"Total Transaksi Berhasil     : {len(df_transactions)}")
print("File disimpan di: data/raw/users.csv & transactions.csv")
print("=========================================")