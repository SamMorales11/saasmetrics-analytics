import pandas as pd
from sqlalchemy import create_engine

# Ganti dengan connection string Neon milikmu
NEON_CONN_STRING = "postgresql://USER:PASSWORD@HOST/neondb?sslmode=require"

try:
    print("Menghubungkan ke Neon.tech...")
    engine = create_engine(NEON_CONN_STRING)
    
    # Load data dari folder lokal
    df_users = pd.read_csv('data/raw/users.csv')
    df_transactions = pd.read_csv('data/raw/transactions.csv')
    
    # Push ke Neon (if_exists='append' karena tabel sudah dibuat lewat DDL)
    print("Mengunggah data tabel 'users'...")
    df_users.to_sql('users', engine, if_exists='append', index=False)
    
    print("Mengunggah data tabel 'transactions'...")
    df_transactions.to_sql('transactions', engine, if_exists='append', index=False)
    
    print("🚀 Data berhasil dimigrasikan ke Cloud Neon.tech!")

except Exception as e:
    print(f"Terjadi kesalahan: {e}")